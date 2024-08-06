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
}

struct DMListEntity: Entity {
    let dmlist: [DMSEntity]
}

