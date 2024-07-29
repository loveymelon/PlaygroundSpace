//
//  NetworkManager.swift
//  PlaygroundSpace
//
//  Created by 김진수 on 7/27/24.
//

import Foundation
import Alamofire

final class NetworkManager {
    
    static let shared = NetworkManager()
    
    private init() { }
    
    func duplicateEmail(userEmailDTO: UserEmailRequestDTO) {
        do {
            let request = try UserRouter.duplicate(userEmailDTO).asURLRequest()
            
            AF.request(request)
                .validate(statusCode: 200..<300)
                .response { result in
                    switch result.result {
                    case .success(_):
                        print("success")
                    case .failure(let error):
                        guard let data = result.data else { return }
                        let errorResult = JSONManager.shared.decoder(type: ErrorDTO.self, data: data)
                        switch errorResult {
                        case .success(let success):
                            print(success.errorCode)
                        case .failure(let failure):
                            print(failure)
                        }
                    }
                }
            
        } catch {
            print(error)
        }
        
    }
    
    func signUpFinish(userInfo: UserSignUpRequestDTO) {
        do {
            let request = try UserRouter.signUpEnter(userInfo).asURLRequest()
            
            AF.request(request)
                .validate(statusCode: 200..<300)
                .responseDecodable(of: UserDTOModel.self) { result in
                    switch result.result {
                    case .success(let data):
                        print(data)
                    case .failure(let error):
                        guard let data = result.data else { return }
                        let errorResult = JSONManager.shared.decoder(type: ErrorDTO.self, data: data)
                        switch errorResult {
                        case .success(let success):
                            print(success.errorCode)
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
