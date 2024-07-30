//
//  WorkspaceRouter.swift
//  PlaygroundSpace
//
//  Created by 김진수 on 7/30/24.
//

import Foundation
import Alamofire

enum WorkspaceRouter: Router {
    case fetch
}

extension WorkspaceRouter {
    var method: HTTPMethod {
        switch self {
        case .fetch:
            return .get
        }
    }
    
    var path: String {
        switch self {
        case .fetch:
            return APIKey.version + "workspaces"
        }
    }
    
    var optionalHeaders: HTTPHeaders? {
        switch self {
        case .fetch:
            return [HTTPHeader(name: "Authorization", value: UserDefaultsManager.shared.accessToken)]
        }
    }
    
    var parameters: Parameters? {
        switch self {
        case .fetch:
            return nil
        }
    }
    
    var body: Data? {
        switch self {
        case .fetch:
            return nil
        }
    }
    
    var encodingType: EncodingType {
        switch self {
        case .fetch:
            return .url
        }
    }
    
}
