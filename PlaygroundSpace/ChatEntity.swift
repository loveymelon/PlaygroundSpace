//
//  ChatEntity.swift
//  PlaygroundSpace
//
//  Created by 김진수 on 8/12/24.
//

import Foundation

struct ChatEntity: Entity {
    let channelId: String
    let channelName: String
    let chatId: String
    let content: String?
    let createdAt: String
    let files: [String]
    let user: MemberInfoEntity
    
    init(channelId: String = "", channelName: String = "", chatId: String = "", content: String? = nil, createdAt: String = "", files: [String] = [], user: MemberInfoEntity = MemberInfoEntity()) {
        self.channelId = channelId
        self.channelName = channelName
        self.chatId = chatId
        self.content = content
        self.createdAt = createdAt
        self.files = files
        self.user = user
    }
}
