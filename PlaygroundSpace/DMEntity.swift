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
}

struct DMListEntity: Entity {
    let dmListEntity: [DMEntity]
}
