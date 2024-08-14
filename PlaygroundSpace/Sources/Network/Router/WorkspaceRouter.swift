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
    case edit(String, String, Data)
    case changeOwner(OwnerRequestDTO)
    case workSpaceOut
    case fetchPointWorkSpace
}

extension WorkspaceRouter {
    var method: HTTPMethod {
        switch self {
        case .fetch, .fetchMember, .workSpaceOut, .fetchPointWorkSpace:
            return .get
        case .create, .invite:
            return .post
        case .edit, .changeOwner:
            return .put
        }
    }
    
    var path: String {
        switch self {
        case .fetch, .create:
            return APIKey.version + "/workspaces"
        case .fetchMember, .invite:
            return APIKey.version + "/workspaces/" + UserDefaultsManager.shared.currentWorkSpaceId + "/members"
        case .edit, .fetchPointWorkSpace:
            return APIKey.version + "/workspaces/\(UserDefaultsManager.shared.currentWorkSpaceId)"
        case .changeOwner:
            return APIKey.version + "/workspaces/\(UserDefaultsManager.shared.currentWorkSpaceId)/transfer/ownership"
        case .workSpaceOut:
            return APIKey.version + "/workspaces/\(UserDefaultsManager.shared.currentWorkSpaceId)/exit"
        }
    }
    
    var optionalHeaders: HTTPHeaders? {
        switch self {
        case .fetch, .create, .fetchMember, .invite, .edit, .changeOwner, .workSpaceOut, .fetchPointWorkSpace:
            return [HTTPHeader(name: "Authorization", value: UserDefaultsManager.shared.accessToken)]
        }
    }
    
    var parameters: Parameters? {
        switch self {
        case .fetch, .create, .fetchMember, .invite, .edit, .changeOwner, .workSpaceOut, .fetchPointWorkSpace:
            return nil
        }
    }
    
    var body: Data? {
        switch self {
        case .fetch, .create, .fetchMember, .edit, .workSpaceOut, .fetchPointWorkSpace:
            return nil
        case let .invite(data):
            return requestToBody(data)
        case let .changeOwner(requestDTO):
            return requestToBody(requestDTO)
        }
    }
    
    var encodingType: EncodingType {
        switch self {
        case .fetch, .fetchMember, .workSpaceOut, .fetchPointWorkSpace:
            return .url
        case let .create(name, description, imageData):
            let data = MultipartFormData()
            
            data.append(name.data(using: .utf8)!, withName: "name")
            data.append(description.data(using: .utf8)!, withName: "description")
            data.append(imageData, withName: "image", fileName: "workSpaceImage.jpeg", mimeType: "image/jpeg")
            
            return .multiPart(data)
        case .invite, .changeOwner:
            return .json
        case let .edit(name, description, image):
            let data = MultipartFormData()
            
            data.append(name.data(using: .utf8)!, withName: "name")
            data.append(description.data(using: .utf8)!, withName: "description")
            data.append(image, withName: "image", fileName: "workSpceImage.jpeg", mimeType: "image/jpeg")
            
            return .multiPart(data)
        }
    }
    
}
