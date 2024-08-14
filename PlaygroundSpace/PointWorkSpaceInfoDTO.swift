//
//  PointWorkSpaceInfoDTO.swift
//  PlaygroundSpace
//
//  Created by 김진수 on 8/14/24.
//

import Foundation

struct PointWorkSpaceInfoDTO: DTO {
    let workspaceId: String
    let name: String
    let description: String
    let coverImage: String?
    let ownerId: String
    let createdAt: String
    let channels: ChannelListDTO
    let workspaceMembers: MemberIfnoListDTO
    
    enum CodingKeys: String, CodingKey {
        case workspaceId = "workspace_id"
        case name
        case description
        case coverImage
        case ownerId = "owner_id"
        case createdAt
        case channels
        case workspaceMembers
    }
    
    
}
