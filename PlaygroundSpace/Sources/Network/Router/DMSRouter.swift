//
//  DMSRouter.swift
//  PlaygroundSpace
//
//  Created by 김진수 on 8/5/24.
//

import Foundation
import Alamofire

enum DMSRouter: Router {
    case fetchDMRoomList
    case fetchDMList(String)
    case createDMRoom(DMRequestDTO)
    case pushMessage(String, String, [Data])
}

extension DMSRouter {
    var method: HTTPMethod {
        switch self {
        case .fetchDMRoomList, .fetchDMList:
            return .get
        case .createDMRoom:
            return .post
        case .pushMessage:
            return .post
        }
    }
    
    var path: String {
        switch self {
        case .fetchDMRoomList:
            return APIKey.version + "/workspaces/" + "\(UserDefaultsManager.shared.currentWorkSpaceId)/" + "dms"
        case let .fetchDMList(roomId), let .pushMessage(roomId, _, _):
            return APIKey.version + "/workspaces/" + "\(UserDefaultsManager.shared.currentWorkSpaceId)/" + "dms/" + "\(roomId)/" + "chats"
        case .createDMRoom:
            return APIKey.version + "/workspaces/\(UserDefaultsManager.shared.currentWorkSpaceId)/dms"
        }
    }
    
    var optionalHeaders: HTTPHeaders? {
        switch self {
        case .fetchDMRoomList, .fetchDMList, .createDMRoom, .pushMessage:
            return [HTTPHeader(name: "Authorization", value: UserDefaultsManager.shared.accessToken)]
        }
    }
    
    var parameters: Parameters? {
        switch self {
        case .fetchDMRoomList, .fetchDMList, .createDMRoom, .pushMessage:
            return nil
        }
    }
    
    var body: Data? {
        switch self {
        case .fetchDMRoomList, .fetchDMList, .pushMessage:
            return nil
        case let .createDMRoom(userId):
            return requestToBody(userId)
        }
    }
    
    var encodingType: EncodingType {
        switch self {
        case .fetchDMRoomList, .fetchDMList:
            return .url
        case .createDMRoom:
            return .json
        case let .pushMessage(_, content, files):
            let data = MultipartFormData()
            
            if !content.isEmpty {
                data.append(content.data(using: .utf8)!, withName: "content")
            }
            for (index, file) in files.enumerated() {
                let fieldName = "files[\(index)]"
                data.append(file, withName: "files", fileName: fieldName, mimeType: "image/jpeg")
            }
            
            return .multiPart(data)
        }
    }
}
