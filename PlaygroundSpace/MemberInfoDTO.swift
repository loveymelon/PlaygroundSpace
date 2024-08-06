//
//  MemberInfoDTO.swift
//  PlaygroundSpace
//
//  Created by 김진수 on 8/6/24.
//

import Foundation

struct MemberInfoDTO: DTO {
    let userId: String
    let email: String
    let nickname: String
    let profileImage: String?
    
    enum CodingKeys: String, CodingKey {
        case userId = "user_id"
        case email
        case nickname
        case profileImage
    }
}

struct MemberIfnoListDTO: DTO {
    let memberIfnoListDTO: [MemberInfoDTO]
    
    init(from decoder: any Decoder) throws {
        var container = try decoder.unkeyedContainer()
        var memberList = [MemberInfoDTO] ()
        while !container.isAtEnd {
            let member = try container.decode(MemberInfoDTO.self)
            memberList.append(member)
        }
        self.memberIfnoListDTO = memberList
    }
}
