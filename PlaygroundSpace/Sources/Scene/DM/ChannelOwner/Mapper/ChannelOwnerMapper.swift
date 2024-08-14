//
//  ChannelOwnerMapper.swift
//  PlaygroundSpace
//
//  Created by 김진수 on 8/13/24.
//

import Foundation

struct ChannelOwnerMapper {
    func idToRequestDTO(_ ownerId: String) -> OwnerRequestDTO {
        return OwnerRequestDTO(owner_id: ownerId)
    }
    
    func dtoToEntity(_ dto: ChannelDTO) -> ChannelEntity {
        return ChannelEntity(channelId: dto.channelId, name: dto.name, description: dto.description, coverImage: dto.coverImage, ownerId: dto.ownerId, createdAt: dto.createdAt)
    }
    
    func dtoToEntity(_ dto: [MemberInfoDTO]) -> [MemberInfoEntity] {
        return dto.map { dtoToEntity($0) }
    }
    
    func dtoToEntity(_ dto: WorkspaceDTO) -> WorkspaceListEntity {
        return WorkspaceListEntity(workspaceID: dto.workspaceID, name: dto.name, description: dto.description, coverImage: dto.coverImage, ownerID: dto.ownerID, createdAt: dto.createdAt)
    }
}

extension ChannelOwnerMapper {
    private func dtoToEntity(_ dto: MemberInfoDTO) -> MemberInfoEntity {
        return MemberInfoEntity(userId: dto.userId, email: dto.email, nickname: dto.nickname, profileImage: dto.profileImage)
    }
}
