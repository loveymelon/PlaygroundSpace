//
//  DMDTO.swift
//  PlaygroundSpace
//
//  Created by 김진수 on 8/7/24.
//

import Foundation

struct DMDTO: DTO {
    let dmId: String
    let roomId: String
    let content: String?
    let createdAt: String
    let files: [String]
    let user: MemberInfoDTO
    
    enum CodingKeys: String, CodingKey {
        case dmId = "dm_id"
        case roomId = "room_id"
        case content
        case createdAt
        case files
        case user
    }
}

struct DMListDTO: DTO {
    let dmListDTO: [DMDTO]
    
    init(from decoder: any Decoder) throws {
        var container = try decoder.unkeyedContainer()
        var dmList = [DMDTO] ()
        while !container.isAtEnd {
            let dm = try container.decode(DMDTO.self)
            dmList.append(dm)
        }
        self.dmListDTO = dmList
    }
}
