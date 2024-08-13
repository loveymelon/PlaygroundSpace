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
    case channelEdit(String, String, String)
    case changeOwner(String, OwnerRequestDTO)
    case fetchMembers(String)
    case channelOut(String)
    case channelDelete(String)
}

extension ChannelRouter {
    var method: HTTPMethod {
        switch self {
        case .fetchMyChannel, .fetchAllChannel, .fetchDMList, .fetchPointChannel, .fetchMembers, .channelOut:
            return .get
        case .createChannel, .pushMessage:
            return .post
        case .channelEdit, .changeOwner:
            return .put
        case .channelDelete:
            return .delete
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
        case let .channelEdit(channelId, _, _), let .channelDelete(channelId), let .fetchPointChannel(channelId):
            return APIKey.version + "/workspaces/\(UserDefaultsManager.shared.currentWorkSpaceId)/channels/\(channelId)"
        case let .changeOwner(channelId, _):
            return APIKey.version + "/workspaces/\(UserDefaultsManager.shared.currentWorkSpaceId)/channels/\(channelId)/transfer/ownership"
        case let .fetchMembers(channelId):
            return APIKey.version + "/workspaces/\(UserDefaultsManager.shared.currentWorkSpaceId)/channels/\(channelId)/members"
        case let .channelOut(channelId):
            return APIKey.version + "/workspaces/\(UserDefaultsManager.shared.currentWorkSpaceId)/channels/\(channelId)/exit"
        }
    }
    
    var optionalHeaders: HTTPHeaders? {
        switch self {
        case .fetchMyChannel, .createChannel, .fetchAllChannel, .fetchDMList, .pushMessage, .fetchPointChannel, .channelEdit, .changeOwner, .fetchMembers, .channelOut, .channelDelete:
            return [HTTPHeader(name: "Authorization", value: UserDefaultsManager.shared.accessToken)]
        }
    }
    
    var parameters: Parameters? {
        switch self {
        case .fetchMyChannel, .createChannel, .fetchAllChannel, .fetchDMList, .pushMessage, .fetchPointChannel, .channelEdit, .changeOwner, .fetchMembers, .channelOut, .channelDelete:
            return nil
        }
    }
    
    var body: Data? {
        switch self {
        case .fetchMyChannel, .createChannel, .fetchAllChannel, .fetchDMList, .pushMessage, .fetchPointChannel, .channelEdit, .fetchMembers, .channelOut, .channelDelete:
            return nil
        case let .changeOwner(_, requestDTO):
            return requestToBody(requestDTO)
        }
    }
    
    var encodingType: EncodingType {
        switch self {
        case .fetchMyChannel, .fetchAllChannel, .fetchDMList, .fetchPointChannel, .fetchMembers, .channelDelete, .channelOut:
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
        case let .channelEdit(_, name, description):
            let data = MultipartFormData()
            
            data.append(name.data(using: .utf8)!, withName: "name")
            data.append(description.data(using: .utf8)!, withName: "description")
            
            return .multiPart(data)
        case .changeOwner:
            return .json
        }
    }
    
}
