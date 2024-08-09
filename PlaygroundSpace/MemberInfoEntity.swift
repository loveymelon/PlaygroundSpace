//
//  MemberInfoEntity.swift
//  PlaygroundSpace
//
//  Created by 김진수 on 8/6/24.
//

import Foundation

struct MemberInfoEntity: Entity {
    let userId: String
    let email: String
    let nickname: String
    let profileImage: String?
    
    init(userId: String = "", email: String = "", nickname: String = "", profileImage: String? = nil) {
        self.userId = userId
        self.email = email
        self.nickname = nickname
        self.profileImage = profileImage
    }
}

struct MemberInfoListEntity: Entity {
    let memberInfoList: [MemberInfoEntity]
}
