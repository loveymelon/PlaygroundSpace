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
    case kakaoLogin(KakaoLoginRequestDTO)
    case appleLogin(AppleLoginRequestDTO)
}

extension UserRouter {
    var method: HTTPMethod {
        switch self {
        case .duplicate, .signUpEnter, .emailLogin, .kakaoLogin, .appleLogin:
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
        case .kakaoLogin:
            return APIKey.version + "/users/login/kakao"
        case .appleLogin:
            return APIKey.version + "/users/login/apple"
        }
    }
    
    var optionalHeaders: HTTPHeaders? {
        switch self {
        case .duplicate, .signUpEnter, .emailLogin, .kakaoLogin, .appleLogin:
            return nil
        }
    }

    var parameters: Parameters? {
        switch self {
        case .duplicate, .signUpEnter, .emailLogin, .kakaoLogin, .appleLogin:
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
        case let .kakaoLogin(token):
            return requestToBody(token)
        case let .appleLogin(appleInfo):
            return requestToBody(appleInfo)
        }
    }
    
    var encodingType: EncodingType {
        switch self {
        case .duplicate, .signUpEnter, .emailLogin, .kakaoLogin, .appleLogin:
            return .json
        }
    }
}
