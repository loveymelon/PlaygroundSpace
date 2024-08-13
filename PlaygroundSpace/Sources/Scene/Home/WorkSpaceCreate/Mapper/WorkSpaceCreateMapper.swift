//
//  WorkSpaceCreateMapper.swift
//  PlaygroundSpace
//
//  Created by 김진수 on 8/14/24.
//

import Foundation

struct WorkSpaceCreateMapper {
    func dtoToEntity(_ dto: WorkspaceDTO) -> WorkspaceListEntity {
        return WorkspaceListEntity(workspaceID: dto.workspaceID, name: dto.name, description: dto.description, coverImage: dto.coverImage, ownerID: dto.ownerID, createdAt: dto.createdAt)
    }
}
