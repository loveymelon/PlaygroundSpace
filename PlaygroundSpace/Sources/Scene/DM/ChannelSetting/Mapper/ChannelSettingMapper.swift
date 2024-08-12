//
//  ChannelSettingMapper.swift
//  PlaygroundSpace
//
//  Created by 김진수 on 8/12/24.
//

import Foundation

struct ChannelSettingMapper {
    func dtoToEntity(_ dto: PointChannelDTO) -> PointChannelEntity {
        return PointChannelEntity(channelId: dto.channelId, name: dto.name, description: dto.description, coverImage: dto.coverImage, ownerId: dto.ownerId, createdAt: dto.createdAt, channelMembers: dtoToEntity(dto.channelMembers.memberIfnoListDTO))
    }
}

extension ChannelSettingMapper {
    private func dtoToEntity(_ dto: [MemberInfoDTO]) -> [MemberInfoEntity] {
        return dto.map { dtoToEntity($0) }
    }
    
    private func dtoToEntity(_ dto: MemberInfoDTO) -> MemberInfoEntity {
        return MemberInfoEntity(userId: dto.userId, email: dto.email, nickname: dto.nickname, profileImage: dto.profileImage)
    }
}
