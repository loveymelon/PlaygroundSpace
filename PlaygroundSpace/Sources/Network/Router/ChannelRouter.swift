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
    case fetchAllChannel
    case fetchDMList(String)
    case pushMessage(String, String, [Data])
    case fetchPointChannel(String)
}

extension ChannelRouter {
    var method: HTTPMethod {
        switch self {
        case .fetchMyChannel, .fetchAllChannel, .fetchDMList, .fetchPointChannel:
            return .get
        case .createChannel, .pushMessage:
            return .post
        }
    }
    
    var path: String {
        switch self {
        case let .fetchMyChannel(workSpaceId):
            return APIKey.version + "/workspaces/" + "\(workSpaceId)/" + "my-channels"
        case .createChannel, .fetchAllChannel:
            return APIKey.version + "/workspaces/\(UserDefaultsManager.shared.currentWorkSpaceId)/channels"
        case let .fetchDMList(channelId), let .pushMessage(channelId, _, _):
            return APIKey.version + "/workspaces/\(UserDefaultsManager.shared.currentWorkSpaceId)/channels/\(channelId)/chats"
        case let .fetchPointChannel(channelId):
            return APIKey.version + "/workspaces/\(UserDefaultsManager.shared.currentWorkSpaceId)/channels/\(channelId)"
        }
    }
    
    var optionalHeaders: HTTPHeaders? {
        switch self {
        case .fetchMyChannel, .createChannel, .fetchAllChannel, .fetchDMList, .pushMessage, .fetchPointChannel:
            return [HTTPHeader(name: "Authorization", value: UserDefaultsManager.shared.accessToken)]
        }
    }
    
    var parameters: Parameters? {
        switch self {
        case .fetchMyChannel, .createChannel, .fetchAllChannel, .fetchDMList, .pushMessage, .fetchPointChannel:
            return nil
        }
    }
    
    var body: Data? {
        switch self {
        case .fetchMyChannel, .createChannel, .fetchAllChannel, .fetchDMList, .pushMessage, .fetchPointChannel:
            return nil
        }
    }
    
    var encodingType: EncodingType {
        switch self {
        case .fetchMyChannel, .fetchAllChannel, .fetchDMList, .fetchPointChannel:
            return .url
        case let .createChannel(name, description):
            let data = MultipartFormData()
            
            data.append(name.data(using: .utf8)!, withName: "name")
            data.append(description.data(using: .utf8)!, withName: "description")
            
            return .multiPart(data)
        case let .pushMessage(_, content, files):
            let data = MultipartFormData()
            
            if !content.isEmpty {
                data.append(content.data(using: .utf8)!, withName: "content")
            }
            
            for (index, file) in files.enumerated() {
                let fieldName = "file[\(index)]"
                data.append(file, withName: "files", fileName: fieldName, mimeType: "image/jpeg")
            }
            
            return .multiPart(data)
        }
    }
    
}
