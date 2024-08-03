//
//  WorkSpaceInfoDTO.swift
//  PlaygroundSpace
//
//  Created by 김진수 on 8/2/24.
//

import Foundation

struct WorkSpaceInfoDTO: DTO {
    let workspaceId: String
    let name: String
    let description: String
    let coverImage: String?
    let ownerId: String
    let createdAt: String
    
    enum CodingKeys: String, CodingKey {
        case workspaceId = "workspace_id"
        case name
        case description
        case coverImage
        case ownerId = "owner_id"
        case createdAt
    }
}
