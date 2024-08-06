//
//  NetworkInterceptor.swift
//  PlaygroundSpace
//
//  Created by 김진수 on 8/6/24.
//

import Foundation
import Alamofire
import ComposableArchitecture

class NetworkInterceptor: RequestInterceptor {
    
    @Dependency(\.networkManager) var network
    
    func adapt(_ urlRequest: URLRequest, for session: Session, completion: @escaping (Result<URLRequest, any Error>) -> Void) {
        
        // 이게 다시 새로운 accessToken세팅해주는 것일까?
        var modifiedURLRequest = urlRequest
        modifiedURLRequest.setValue(UserDefaultsManager.shared.accessToken, forHTTPHeaderField: HeaderType.auth)
        completion(.success(modifiedURLRequest))
        
    }
    
    func retry(_ request: Request, for session: Session, dueTo error: any Error, completion: @escaping (RetryResult) -> Void) {
        guard let responses = request.task?.response as? HTTPURLResponse, responses.statusCode == 419 else {
            completion(.doNotRetryWithError(error))
            return
        }
        
        do {
            Task {
                let result = try await network.requestNetwork(dto: TokenDTO.self, router: AuthRouter.token)
                
                switch result {
                case .success(let data):
                    UserDefaultsManager.shared.accessToken = data.accessToken
                    completion(.retry)
                case .failure(let error):
                    completion(.doNotRetryWithError(error))
                }
            }
        } catch {
            print(error)
        }
    }
}
