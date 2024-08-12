//
//  AllChannelMapper.swift
//  PlaygroundSpace
//
//  Created by 김진수 on 8/11/24.
//

import Foundation

struct AllChannelMapper {
    func dtoToEntity(dto: [ChannelDTO]) -> [ChannelEntity] {
        return dto.map { dtoToEntity(dto: $0) }
    }
}

extension AllChannelMapper {
    private func dtoToEntity(dto: ChannelDTO) -> ChannelEntity {
        return ChannelEntity(channelId: dto.channelId, name: dto.name, description: dto.description, coverImage: dto.coverImage, ownerId: dto.ownerId, createdAt: dto.createdAt)
    }
}
