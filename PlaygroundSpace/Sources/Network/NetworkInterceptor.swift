//
//  NetworkInterceptor.swift
//  PlaygroundSpace
//
//  Created by 김진수 on 8/6/24.
//

import Foundation
import Alamofire
import ComposableArchitecture

final class NetworkInterceptor: RequestInterceptor {
    
    @Dependency(\.networkManager) var network
    
    static let shared = NetworkInterceptor()
    
    private init() { }
    
    private let retryLimit = 3
    private var retryRequests: [(RetryResult) -> Void] = []
    
    func adapt(_ urlRequest: URLRequest, for session: Session, completion: @escaping (Result<URLRequest, any Error>) -> Void) {
        
        var modifiedURLRequest = urlRequest
        modifiedURLRequest.setValue(UserDefaultsManager.shared.accessToken, forHTTPHeaderField: HeaderType.auth)
        completion(.success(modifiedURLRequest))
    }
    
    func retry(_ request: Request, for session: Session, dueTo error: any Error, completion: @escaping (RetryResult) -> Void) {
        
        retryRequests.append(completion)
        
        if request.retryCount < retryLimit {
            network.refreshNetwork { [weak self] isValid in
                guard let self else { return }
                if isValid {
                    retryRequests.forEach { $0(.retry) }
                    retryRequests.removeAll()
                } else {
                    UserDefaultsManager.shared.accessToken = ""
                    NotificationCenter.default.post(name: .refreshTokenDie, object: nil)
                    retryRequests.removeAll()
                    completion(.doNotRetryWithError(error))
                }
            }
        } else {
            UserDefaultsManager.shared.accessToken = ""
            NotificationCenter.default.post(name: .refreshTokenDie, object: nil)
            retryRequests.removeAll()
            completion(.doNotRetryWithError(error))
        }
        
        
    }
}
