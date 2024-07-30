//
//  WorkspaceListDTO.swift
//  PlaygroundSpace
//
//  Created by 김진수 on 7/30/24.
//

import Foundation

struct WorkspaceDTO: DTO {
    let workspaceID: String
    let name: String
    let description: String
    let coverImage: String
    let ownerID: String
    let createdAt: String
    
    enum CodingKeys: String, CodingKey {
        case workspaceID = "workspace_id"
        case name
        case description
        case coverImage
        case ownerID = "owner_id"
        case createdAt
    }
}

struct WorkSpaceListDTO: DTO {
    let workSpaces: [WorkspaceDTO]
    
    init(from decoder: any Decoder) throws {
        var container = try decoder.unkeyedContainer()
        var workSpaces = [WorkspaceDTO] ()
        while !container.isAtEnd {
            let workspace = try container.decode(WorkspaceDTO.self)
            workSpaces.append(workspace)
        }
        self.workSpaces = workSpaces
    }
}
