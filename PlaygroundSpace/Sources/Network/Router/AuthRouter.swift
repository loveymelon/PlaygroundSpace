//
//  AuthRouter.swift
//  PlaygroundSpace
//
//  Created by 김진수 on 8/6/24.
//

import Foundation
import Alamofire

enum AuthRouter: Router {
    case token
}

extension AuthRouter {
    var method: HTTPMethod {
        switch self {
        case .token:
        return .get
        }
    }
    
    var path: String {
        switch self {
        case .token:
            return APIKey.version + "/auth/" + "refresh"
        }
    }
    
    var optionalHeaders: HTTPHeaders? {
        switch self {
        case .token:
            return [HTTPHeader(name: "Authorization", value: UserDefaultsManager.shared.accessToken)]
        }
    }
    
    var parameters: Parameters? {
        switch self {
        case .token:
            return nil
        }
    }
    
    var body: Data? {
        switch self {
        case .token:
            return nil
        }
    }
    
    var encodingType: EncodingType {
        switch self {
        case .token:
            return .url
        }
    }
}
