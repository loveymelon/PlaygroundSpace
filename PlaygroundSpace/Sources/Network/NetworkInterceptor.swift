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
    let retryLimit = 3
    
    func adapt(_ urlRequest: URLRequest, for session: Session, completion: @escaping (Result<URLRequest, any Error>) -> Void) {
        
        var modifiedURLRequest = urlRequest
        modifiedURLRequest.setValue(UserDefaultsManager.shared.accessToken, forHTTPHeaderField: HeaderType.auth)
        completion(.success(modifiedURLRequest))
    }
    
    func retry(_ request: Request, for session: Session, dueTo error: any Error, completion: @escaping (RetryResult) -> Void) {
        
        if request.retryCount < retryLimit {
            network.refreshNetwork { isValid in
                if isValid {
                    completion(.retryWithDelay(1))
                } else {
                    UserDefaultsManager.shared.accessToken = ""
                    NotificationCenter.default.post(name: .refreshTokenDie, object: nil)
                    completion(.doNotRetryWithError(error))
                }
            }
        } else {
            UserDefaultsManager.shared.accessToken = ""
            NotificationCenter.default.post(name: .refreshTokenDie, object: nil)
            completion(.doNotRetryWithError(error))
        }
        
    }
}
