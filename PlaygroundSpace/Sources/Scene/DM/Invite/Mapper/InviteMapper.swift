//
//  InviteMapper.swift
//  PlaygroundSpace
//
//  Created by 김진수 on 8/8/24.
//

import Foundation

struct InviteMapper {
    func emailToRequestDTO(email: String) -> EmailRequestDTO {
        return EmailRequestDTO(email: email)
    }
    
    func dtoToEntity(dto: MemberInfoDTO) -> MemberInfoEntity {
        return MemberInfoEntity(userId: dto.userId, email: dto.email, nickname: dto.nickname, profileImage: dto.profileImage)
    }
}
