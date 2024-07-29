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
}

extension UserRouter {
    var method: HTTPMethod {
        switch self {
        case .duplicate:
            return .post
        case .signUpEnter:
            return .post
        }
    }
    
    var path: String {
        switch self {
        case .duplicate:
            return APIKey.version + "users/validation/email"
        case .signUpEnter:
            return APIKey.version + "users/join"
        }
    }
    
    var optionalHeaders: HTTPHeaders? {
        switch self {
        case .duplicate, .signUpEnter:
            return nil
        }
    }

    var parameters: Parameters? {
        switch self {
        case .duplicate, .signUpEnter:
            return nil
        }
    }
    
    var body: Data? {
        switch self {
        case .duplicate(let userEmailRequestDTO):
            return requestToBody(userEmailRequestDTO)
        case .signUpEnter(let userSignInfo):
            return requestToBody(userSignInfo)
        }
    }
    
    var encodingType: EncodingType {
        switch self {
        case .duplicate(_):
            return .json
        case .signUpEnter:
            return .json
        }
    }
}
