//
//  ChatDTO.swift
//  PlaygroundSpace
//
//  Created by 김진수 on 8/12/24.
//

import Foundation

struct ChatDTO: DTO {
    let channelId: String
    let channelName: String
    let chatId: String
    let content: String?
    let createdAt: String
    let files: [String]
    let user: MemberInfoDTO
    
    enum CodingKeys: String, CodingKey {
        case channelId = "channel_id"
        case channelName
        case chatId = "chat_id"
        case content
        case createdAt
        case files
        case user
    }
}

struct ChatListDTO: DTO {
    let chatListDTO: [ChatDTO]
    
    init(from decoder: any Decoder) throws {
        var container = try decoder.unkeyedContainer()
        var chatList = [ChatDTO] ()
        while !container.isAtEnd {
            let chat = try container.decode(ChatDTO.self)
            chatList.append(chat)
        }
        self.chatListDTO = chatList
    }
}
