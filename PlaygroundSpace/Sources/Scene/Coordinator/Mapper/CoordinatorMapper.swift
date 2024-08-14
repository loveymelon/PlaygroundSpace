//
//  CoordinatorMapper.swift
//  PlaygroundSpace
//
//  Created by 김진수 on 7/30/24.
//

import Foundation

final class CoordinatorMapper {
    func dtoToEntity(dto: WorkSpaceListDTO) -> [WorkspaceListEntity] {
        
        return dto.workSpaces.map { WorkspaceListEntity(workspaceID: $0.workspaceID, name: $0.name, description: $0.description, coverImage: $0.coverImage, ownerID: $0.ownerID, createdAt: $0.createdAt) }
    }
    
    func dtoToEntity(_ dto: [ChannelDTO]) -> [ChannelEntity] {
        return dto.map { dtoToEntity($0) }
    }
}

extension CoordinatorMapper {
    private func dtoToEntity(_ dto: ChannelDTO) -> ChannelEntity {
        return ChannelEntity(channelId: dto.channelId, name: dto.name, description: dto.description, coverImage: dto.coverImage, ownerId: dto.ownerId, createdAt: dto.createdAt)
    }
}
