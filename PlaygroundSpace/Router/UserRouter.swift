//
//  SignUpRouter.swift
//  PlaygroundSpace
//
//  Created by 김진수 on 7/27/24.
//

import Foundation
import Alamofire

enum UserRouter: Router {
    case duplicate(UserEmailRequestDTO)
    case signUpEnter(UserSignUpRequestDTO)
    case emailLogin(EmailLoginRequestDTO)
}

extension UserRouter {
    var method: HTTPMethod {
        switch self {
        case .duplicate:
            return .post
        case .signUpEnter:
            return .post
        case .emailLogin:
            return .post
        }
    }
    
    var path: String {
        switch self {
        case .duplicate:
            return APIKey.version + "/users/validation/email"
        case .signUpEnter:
            return APIKey.version + "/users/join"
        case .emailLogin:
            return APIKey.version + "/users/login"
        }
    }
    
    var optionalHeaders: HTTPHeaders? {
        switch self {
        case .duplicate, .signUpEnter, .emailLogin:
            return nil
        }
    }

    var parameters: Parameters? {
        switch self {
        case .duplicate, .signUpEnter, .emailLogin:
            return nil
        }
    }
    
    var body: Data? {
        switch self {
        case .duplicate(let userEmailRequestDTO):
            return requestToBody(userEmailRequestDTO)
        case .signUpEnter(let userSignInfo):
            return requestToBody(userSignInfo)
        case .emailLogin(let emailLogin):
            return requestToBody(emailLogin)
        }
    }
    
    var encodingType: EncodingType {
        switch self {
        case .duplicate:
            return .json
        case .signUpEnter:
            return .json
        case .emailLogin:
            return .json
        }
    }
}
