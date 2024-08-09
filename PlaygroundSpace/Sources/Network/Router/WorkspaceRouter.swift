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
    case create(String, String, Data)
    case fetchMember
    case invite(EmailRequestDTO)
}

extension WorkspaceRouter {
    var method: HTTPMethod {
        switch self {
        case .fetch:
            return .get
        case .create:
            return .post
        case .fetchMember:
            return .get
        case .invite:
            return .post
        }
    }
    
    var path: String {
        switch self {
        case .fetch, .create:
            return APIKey.version + "/workspaces"
        case .fetchMember, .invite:
            return APIKey.version + "/workspaces/" + UserDefaultsManager.shared.currentWorkSpaceId + "/members"
        }
    }
    
    var optionalHeaders: HTTPHeaders? {
        switch self {
        case .fetch, .create, .fetchMember, .invite:
            return [HTTPHeader(name: "Authorization", value: UserDefaultsManager.shared.accessToken)]
        }
    }
    
    var parameters: Parameters? {
        switch self {
        case .fetch, .create, .fetchMember, .invite:
            return nil
        }
    }
    
    var body: Data? {
        switch self {
        case .fetch, .create, .fetchMember:
            return nil
        case let .invite(data):
            return requestToBody(data)
        }
    }
    
    var encodingType: EncodingType {
        switch self {
        case .fetch, .fetchMember:
            return .url
        case let .create(name, description, imageData):
            let data = MultipartFormData()
            
            data.append(name.data(using: .utf8)!, withName: "name")
            data.append(description.data(using: .utf8)!, withName: "description")
            data.append(imageData, withName: "image", fileName: "workSpaceImage.jpeg", mimeType: "image/jpeg")
            
            return .multiPart(data)
        case .invite:
            return .json
        }
    }
    
}
