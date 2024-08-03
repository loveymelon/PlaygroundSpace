//
//  ChannelDTO.swift
//  PlaygroundSpace
//
//  Created by 김진수 on 8/2/24.
//

import Foundation

struct ChannelDTO: DTO {
    let channelId: String
    let name: String
    let description: String?
    let coverImage: String?
    let ownerId: String
    let createdAt: String
    
    enum CodingKeys: String, CodingKey {
        case channelId = "channel_id"
        case name
        case description
        case coverImage
        case ownerId = "owner_id"
        case createdAt
    }
}

struct ChannelListDTO: DTO {
    let channelList: [ChannelDTO]
    
    init(from decoder: any Decoder) throws {
        var container = try decoder.unkeyedContainer()
        var channelList = [ChannelDTO] ()
        while !container.isAtEnd {
            let channel = try container.decode(ChannelDTO.self)
            channelList.append(channel)
        }
        self.channelList = channelList
    }
}
