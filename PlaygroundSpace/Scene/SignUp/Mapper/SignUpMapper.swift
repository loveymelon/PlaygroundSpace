//
//  SignUpMapper.swift
//  PlaygroundSpace
//
//  Created by 김진수 on 7/29/24.
//

import Foundation

final class SignUpMapper {
    
    func emailEntityToDTO(email: String) -> UserEmailRequestDTO {
        return UserEmailRequestDTO(email: email)
    }
    
    func signUpInfoEntityToDTO(email: String, nick: String, number: String, password: String) -> UserSignUpRequestDTO {
        return UserSignUpRequestDTO(email: email, password: password, nickname: nick, phone: number)
    }
    
    func dtotoEntity(dto: UserDTOModel) -> UserEntity {
        return UserEntity(userId: dto.userId, email: dto.email, nickname: dto.nickname, profileImage: dto.profileImage, phone: dto.phone, provider: dto.provider, createdAt: dto.createdAt, token: TokenEntity(accessToken: dto.token.accessToken, refreshToken: dto.token.refreshToken))
    }
}
