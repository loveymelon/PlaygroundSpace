//
//  DMEntity.swift
//  PlaygroundSpace
//
//  Created by 김진수 on 8/7/24.
//

import Foundation

struct DMEntity: Entity {
    let dmId: String
    let roomId: String
    let content: String?
    let createdAt: String
    let files: [String]
    let user: MemberInfoEntity
    
    init(dmId: String = "", roomId: String = "", content: String? = nil, createdAt: String = "", files: [String] = [], user: MemberInfoEntity = MemberInfoEntity()) {
        self.dmId = dmId
        self.roomId = roomId
        self.content = content
        self.createdAt = createdAt
        self.files = files
        self.user = user
    }
}

struct DMListEntity: Entity {
    let dmListEntity: [DMEntity]
}
