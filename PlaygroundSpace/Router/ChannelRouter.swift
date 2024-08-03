//
//  ChannelRouter.swift
//  PlaygroundSpace
//
//  Created by 김진수 on 8/2/24.
//

import Foundation
import Alamofire

enum ChannelRouter: Router {
    case fetchMyChannel(String)
}

extension ChannelRouter {
    var method: HTTPMethod {
        switch self {
        case .fetchMyChannel:
            return .get
        }
    }
    
    var path: String {
        switch self {
        case let .fetchMyChannel(workSpaceId):
            return APIKey.version + "/workspaces/" + "\(workSpaceId)/" + "my-channels"
        }
    }
    
    var optionalHeaders: HTTPHeaders? {
        switch self {
        case .fetchMyChannel:
            return [HTTPHeader(name: "Authorization", value: UserDefaultsManager.shared.accessToken)]
        }
    }
    
    var parameters: Parameters? {
        switch self {
        case .fetchMyChannel:
            return nil
        }
    }
    
    var body: Data? {
        switch self {
        case .fetchMyChannel:
            return nil
        }
    }
    
    var encodingType: EncodingType {
        switch self {
        case .fetchMyChannel:
            return .url
        }
    }
    
}
