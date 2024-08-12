//
//  PointChannelEntity.swift
//  PlaygroundSpace
//
//  Created by 김진수 on 8/12/24.
//

import Foundation

struct PointChannelEntity: Entity {
    let channelId: String
    let name: String
    let description: String?
    let coverImage: String?
    let ownerId: String
    let createdAt: String
    let channelMembers: [MemberInfoEntity]
}
