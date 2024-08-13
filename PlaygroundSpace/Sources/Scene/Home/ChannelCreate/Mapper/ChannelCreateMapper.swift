//
//  ChannelCreateMapper.swift
//  PlaygroundSpace
//
//  Created by 김진수 on 8/13/24.
//

import Foundation

struct ChannelCreateMapper {
    func dtoToEntity(_ dto: ChannelDTO) -> ChannelEntity {
        return ChannelEntity(channelId: dto.channelId, name: dto.name, description: dto.description, coverImage: dto.coverImage, ownerId: dto.ownerId, createdAt: dto.createdAt)
    }
}

extension ChannelCreateMapper {
    private func dtoToEntity(_ dto: [MemberInfoDTO]) -> [MemberInfoEntity] {
        return dto.map { dtoToEntity($0) }
    }
    
    private func dtoToEntity(_ dto: MemberInfoDTO) -> MemberInfoEntity {
        return MemberInfoEntity(userId: dto.userId, email: dto.email, nickname: dto.nickname, profileImage: dto.profileImage)
    }
}
