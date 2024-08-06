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
}

extension WorkspaceRouter {
    var method: HTTPMethod {
        switch self {
        case .fetch:
            return .get
        case .create:
            return .post
        }
    }
    
    var path: String {
        switch self {
        case .fetch, .create:
            return APIKey.version + "/workspaces"
        }
    }
    
    var optionalHeaders: HTTPHeaders? {
        switch self {
        case .fetch, .create:
            return [HTTPHeader(name: "Authorization", value: UserDefaultsManager.shared.accessToken)]
        }
    }
    
    var parameters: Parameters? {
        switch self {
        case .fetch, .create:
            return nil
        }
    }
    
    var body: Data? {
        switch self {
        case .fetch, .create:
            return nil
        }
    }
    
    var encodingType: EncodingType {
        switch self {
        case .fetch:
            return .url
        case let .create(name, description, imageData):
            let data = MultipartFormData()
            
            data.append(name.data(using: .utf8)!, withName: "name")
            data.append(description.data(using: .utf8)!, withName: "description")
            data.append(imageData, withName: "image", fileName: "workSpaceImage.jpeg", mimeType: "image/jpeg")
            
            return .multiPart(data)
        }
    }
    
}
