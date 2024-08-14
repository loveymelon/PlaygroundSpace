//
//  SocketManager.swift
//  PlaygroundSpace
//
//  Created by 김진수 on 8/10/24.
//

import UIKit
import SocketIO

final class SocketIOManager {
    
    static let shared = SocketIOManager()
    private var manager: SocketManager?
    private var socket: SocketIOClient?
    private init() {
        setup()
    }
    
    func startSocket() {
        print("소켓 시도 시작")
        socket?.connect()
    }
    
    func stopAndRemoveSocket() {
        stopSocket()
        removeSocket()
    }
    
    func stopSocket() {
        print("소켓 멈춥니다.")
        socket?.disconnect()
    }
    
    func removeSocket() {
        print("소켓 완전 제거")
        if let socket {
            manager?.removeSocket(socket)
        }
        socket = nil
    }
    
    deinit {
        print("소켓 디이닛 (나올수 없는 상황)")
    }
}

extension SocketIOManager {
    
    func connectDTO<T: DTO>(to socketCase: SocketCase, type: T.Type) -> AsyncStream<Result<T, NetworkError>> {
        let base = APIKey.baseURL
        guard let url = URL(string: base) else {
            print("유효하지 않은 소켓 URL")
            return AsyncStream { continuation in
                
                continuation.finish()
            }
        }
        print("소켓 요청 URL :" + url.absoluteString)
        
        let config: SocketIOClientConfiguration = [
            .log(true), // 로그
            .compress, // 압축
            .reconnects(true),
            .reconnectWait(10),
            .reconnectAttempts(-1), // 무한 재연결
            .forceNew(true), // 새로운 것이 있을 시 예전 것 삭제
            .secure(false), // https
        ]
        
        manager = SocketManager(socketURL: url, config: config)
        socket = manager?.socket(forNamespace: socketCase.address)
        
        return AsyncStream { [weak self] continuation in
            guard let self else {
                print("소켓에 Weak Self Error")
//                continuation.yield(.failure(.weakError))
                self?.stopAndRemoveSocket()
                continuation.finish()
                return
            }
            print("소켓 AsyncStream Start")
            self.setupSocketHandlers(continuation: continuation, type: type, eventName: socketCase.eventName)
            socket?.connect()
            
            continuation.onTermination = { @Sendable _ in
                print("소켓 생성자 다이")
                self.stopSocket()
            }
        }
    }
    
    private func setupSocketHandlers<T: DTO>(continuation: AsyncStream<Result<T, NetworkError>>.Continuation, type: T.Type, eventName: String) {
        socket?.on(clientEvent: .connect) { data, ack in
            print("소켓 시작 되었습니다.")
            print("\(data) - \(ack)")
        }
        
        socket?.on(clientEvent: .disconnect) { data, ack in
            print("소켓이 정지 됩니다.")
            print("\(data) - \(ack)")
        }
        
        socket?.on(clientEvent: .error) { data, ack in
            print("소켓에 문제가 발생합니다.")
//            continuation.yield(.failure(.weakError))
            self.stopAndRemoveSocket()
            continuation.finish()
        }
        
        socket?.on(eventName) { dataArray, ack in
            print("소켓 channel ->>> ")
            do {
                if let dataFirst = dataArray.first {
                    print("소켓 jsonData try")
                    let jsonData = try JSONSerialization.data(withJSONObject: dataFirst, options: [])
                    print("소켓 jsonDecoding try")
                    let dto = JSONManager.shared.decoder(type: T.self, data: jsonData)
                    print("소켓 방출")
                    
                    switch dto {
                    case .success(let data):
                        continuation.yield(.success(data))
                    case .failure(let error):
                        print(error)
                    }
                } else {
                    print("소켓에 jSON Error")
//                    continuation.yield(.failure(.))
                    self.stopAndRemoveSocket()
                    continuation.finish()
                }
            } catch {
                print("소켓에 Unknown Error")
//                continuation.yield(.failure(.weakError))
                self.stopAndRemoveSocket()
                continuation.finish()
            }
        }
    }
}

extension SocketIOManager {
    private func setup() {
        NotificationCenter.default.addObserver(self, selector: #selector(suspendSocket), name: UIApplication.didEnterBackgroundNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(restartSocket), name: UIApplication.willEnterForegroundNotification, object: nil)
    }
}

extension SocketIOManager {
    @objc
    private func suspendSocket() {
        stopSocket()
    }
    
    @objc
    private func restartSocket() {
        startSocket()
    }
}
