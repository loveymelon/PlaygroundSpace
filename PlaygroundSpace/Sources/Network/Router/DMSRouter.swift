//
//  DMSRouter.swift
//  PlaygroundSpace
//
//  Created by 김진수 on 8/5/24.
//

import Foundation
import Alamofire

enum DMSRouter: Router {
    case fetchDMList
}

extension DMSRouter {
    var method: HTTPMethod {
        switch self {
        case .fetchDMList:
        return .get
        }
    }
    
    var path: String {
        switch self {
        case .fetchDMList:
            return APIKey.version + "/workspaces/" + "\(UserDefaultsManager.shared.currentWorkSpaceId)/" + "dms"
        }
    }
    
    var optionalHeaders: HTTPHeaders? {
        switch self {
        case .fetchDMList:
            return [HTTPHeader(name: "Authorization", value: UserDefaultsManager.shared.accessToken)]
        }
    }
    
    var parameters: Parameters? {
        switch self {
        case .fetchDMList:
            return nil
        }
    }
    
    var body: Data? {
        switch self {
        case .fetchDMList:
            return nil
        }
    }
    
    var encodingType: EncodingType {
        switch self {
        case .fetchDMList:
            return .url
        }
    }
}
