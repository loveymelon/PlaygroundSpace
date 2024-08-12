//
//  PointChannelDTO.swift
//  PlaygroundSpace
//
//  Created by 김진수 on 8/12/24.
//

import Foundation

struct PointChannelDTO: DTO {
    let channelId: String
    let name: String
    let description: String?
    let coverImage: String?
    let ownerId: String
    let createdAt: String
    let channelMembers: MemberIfnoListDTO
    
    enum CodingKeys: String, CodingKey {
        case channelId = "channel_id"
        case name
        case description
        case coverImage
        case ownerId = "owner_id"
        case createdAt
        case channelMembers
    }
}
