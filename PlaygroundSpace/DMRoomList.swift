//
//  DMListDTO.swift
//  PlaygroundSpace
//
//  Created by 김진수 on 8/5/24.
//

import Foundation

struct DMSDTO: DTO {
    let roomId: String
    let createdAt: String
    let user: MemberInfoDTO
    
    enum CodingKeys: String, CodingKey {
        case roomId = "room_id"
        case createdAt
        case user
    }
}

struct DMRoomList: DTO {
    let dmListDTO: [DMSDTO]
    
    init(from decoder: any Decoder) throws {
        var container = try decoder.unkeyedContainer()
        var dmList = [DMSDTO] ()
        while !container.isAtEnd {
            let dmData = try container.decode(DMSDTO.self)
            dmList.append(dmData)
        }
        self.dmListDTO = dmList
    }
}
