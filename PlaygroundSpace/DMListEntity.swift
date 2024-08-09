//
//  DMListEntity.swift
//  PlaygroundSpace
//
//  Created by 김진수 on 8/5/24.
//

import Foundation

struct DMSEntity: Entity {
    let roomId: String
    let createdAt: String
    let user: MemberInfoEntity
    
    init(roomId: String = "", createdAt: String = "", user: MemberInfoEntity = MemberInfoEntity()) {
        self.roomId = roomId
        self.createdAt = createdAt
        self.user = user
    }
}

struct DMRoomListEntity: Entity {
    let dmlist: [DMSEntity]
}

