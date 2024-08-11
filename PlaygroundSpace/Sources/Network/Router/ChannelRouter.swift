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
    case createChannel(String, String)
}

extension ChannelRouter {
    var method: HTTPMethod {
        switch self {
        case .fetchMyChannel:
            return .get
        case .createChannel:
            return .post
        }
    }
    
    var path: String {
        switch self {
        case let .fetchMyChannel(workSpaceId):
            return APIKey.version + "/workspaces/" + "\(workSpaceId)/" + "my-channels"
        case .createChannel:
            return APIKey.version + "/workspaces/\(UserDefaultsManager.shared.currentWorkSpaceId)/channels"
        }
    }
    
    var optionalHeaders: HTTPHeaders? {
        switch self {
        case .fetchMyChannel, .createChannel:
            return [HTTPHeader(name: "Authorization", value: UserDefaultsManager.shared.accessToken)]
        }
    }
    
    var parameters: Parameters? {
        switch self {
        case .fetchMyChannel, .createChannel:
            return nil
        }
    }
    
    var body: Data? {
        switch self {
        case .fetchMyChannel, .createChannel:
            return nil
        }
    }
    
    var encodingType: EncodingType {
        switch self {
        case .fetchMyChannel:
            return .url
        case let .createChannel(name, description):
            let data = MultipartFormData()
            
            data.append(name.data(using: .utf8)!, withName: "name")
            data.append(description.data(using: .utf8)!, withName: "description")
            
            return .multiPart(data)
        }
    }
    
}
