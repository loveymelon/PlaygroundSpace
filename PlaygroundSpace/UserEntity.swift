//
//  UserEntity.swift
//  PlaygroundSpace
//
//  Created by 김진수 on 7/30/24.
//

import Foundation

struct UserEntity {
    let userId: String
    let email: String
    let nickname: String
    let profileImage: String?
    let phone: String?
    let provider: String?
    let createdAt: String
    let token: TokenEntity
}

struct TokenEntity {
    let accessToken: String
    let refreshToken: String
}
