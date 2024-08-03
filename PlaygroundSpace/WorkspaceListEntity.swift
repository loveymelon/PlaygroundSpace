//
//  WorkspaceListEntity.swift
//  PlaygroundSpace
//
//  Created by 김진수 on 7/30/24.
//

import Foundation

struct WorkspaceListEntity: Equatable {
    let workspaceID: String
    let name: String
    let description: String
    let coverImage: String
    let ownerID: String
    let createdAt: String
}
