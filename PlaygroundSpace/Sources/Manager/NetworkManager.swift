//
//  NetworkManager.swift
//  PlaygroundSpace
//
//  Created by 김진수 on 7/27/24.
//

import Foundation
import Alamofire
import ComposableArchitecture

final class NetworkManager {
    
    static let shared = NetworkManager()
    
    private init() { }
    
    func refreshNetwork(completionHandler: @escaping (Bool) -> Void) {
        
        do {
            
            let requset = try AuthRouter.token.asURLRequest()
            
            AF.request(requset)
                .responseDecodable(of: RefreshDTO.self) { result in
                    switch result.result {
                    case let .success(data):
                        UserDefaultsManager.shared.accessToken = data.accessToken
                        completionHandler(true)
                    case .failure(_):
                        
                        guard let data = result.data else { 
                            completionHandler(false)
                            return
                        }
                        
                        let errorResult = JSONManager.shared.decoder(type: ErrorDTO.self, data: data)
                        
                        switch errorResult {
                        case .success(let success):
                            
                            print(success.errorCode)
                            
                            if success.errorCode == "E06" || success.errorCode == "E98" {
                                completionHandler(false)
                            } else {
                                completionHandler(true)
                            }
                            
                        case .failure(_):
                            completionHandler(false)
                        }
                    }
                }
        } catch {
            print(error)
            completionHandler(false)
        }
    }
    
    // DTO 없는 버전
    func requestNetwork<R: Router/*, E: Error*/>(router: R) async throws -> Result<Void, APIError> {
        return try await withCheckedThrowingContinuation { continuation in
            do {
                let request = try router.asURLRequest()
                
                AF.request(request, interceptor: NetworkInterceptor.shared)
                    .validate(statusCode: 200..<300)
                    .response { result in
                        switch result.result {
                        case .success(_):
                            continuation.resume(returning: .success(()))
                        case .failure(_):
                            guard let data = result.data else { return }
                            let errorResult = JSONManager.shared.decoder(type: ErrorDTO.self, data: data)
                            switch errorResult {
                            case .success(let success):
                                continuation.resume(returning: .failure(.httpError(success.errorCode)))
                            case .failure(let failure):
                                print(failure)
                            }
                        }
                    }
            } catch {
                print(error)
            }
        }
    }
    
    // DTO 있는 버전,
    func requestNetwork<T: DTO, R: Router/*, E: Error*/>(dto: T.Type, router: R) async throws -> Result<T, APIError> {
        return try await withCheckedThrowingContinuation { continuation in
            do {
                let request = try router.asURLRequest()
                
                print(request.url)
                
                if case let .multiPart(multipartFormData) = router.encodingType {
                    AF.upload(multipartFormData: multipartFormData, to: request.url!, method: request.method!, headers: request.headers, interceptor: NetworkInterceptor.shared)
                        .responseDecodable(of: T.self) { result in
                            switch result.result {
                            case let .success(data):
                                continuation.resume(returning: .success(data))
                            case .failure(_):
                                guard let data = result.data else {
                                    continuation.resume(throwing: APIError.httpError("badURL"))
                                    return
                                }
                                let errorResult = JSONManager.shared.decoder(type: ErrorDTO.self, data: data)
                                switch errorResult {
                                case .success(let success):
                                    print(success)
                                    continuation.resume(returning: .failure(.httpError(success.errorCode)))
                                case .failure(let error):
                                    print(error)
                                }
                            }
                        }
                    
                } else {
                    
                    AF.request(request, interceptor: NetworkInterceptor.shared)
                        .responseDecodable(of: T.self) { result in
                            switch result.result {
                            case .success(let data):
                                continuation.resume(returning: .success(data))
                            case .failure(_):
                                guard let data = result.data else { return }
                                let errorResult = JSONManager.shared.decoder(type: ErrorDTO.self, data: data)
                                switch errorResult {
                                case .success(let success):
                                    continuation.resume(returning: .failure(.httpError(success.errorCode)))
                                case .failure(let failure):
                                    print(failure)
                                }
                            }
                        }
                    
                }
            } catch {
                print(error)
            }
        }
    }
    
}

extension NetworkManager: DependencyKey {
    static var liveValue: NetworkManager = NetworkManager.shared
}

extension DependencyValues {
    var networkManager: NetworkManager {
        get { self[NetworkManager.self] }
        set { self[NetworkManager.self] = newValue }
    }
}
