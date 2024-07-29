//
//  UserDTOModel.swift
//  PlaygroundSpace
//
//  Created by 김진수 on 7/27/24.
//

import Foundation

struct UserDTOModel: DTO {
    let userId: String
    let email: String
    let nickname: String
    let profileImage: String?
    let phone: String?
    let provider: String?
    let createdAt: String
    let token: Token
    
    enum CodingKeys: String, CodingKey {
        case userId = "user_id"
        case email
        case nickname
        case profileImage
        case phone
        case provider
        case createdAt
        case token
    }
}
