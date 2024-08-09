//
//  EmailLoginMapper.swift
//  PlaygroundSpace
//
//  Created by 김진수 on 7/30/24.
//

import Foundation

final class EmailLoginMapper {
    func entityToRequestDTO(email: String, password: String) -> EmailLoginRequestDTO {
        return EmailLoginRequestDTO(email: email, password: password)
    }
    
    func dtoToEntity(dto: UserDTOModel) -> UserEntity {
        return UserEntity(userId: dto.userId, email: dto.email, nickname: dto.nickname, profileImage: dto.profileImage, phone: dto.phone, provider: dto.provider, createdAt: dto.createdAt, token: TokenEntity(accessToken: dto.token.accessToken, refreshToken: dto.token.refreshToken))
    }
    
}
