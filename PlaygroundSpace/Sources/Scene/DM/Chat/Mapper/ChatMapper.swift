//
//  ChatMapper.swift
//  PlaygroundSpace
//
//  Created by 김진수 on 8/8/24.
//

import Foundation

struct ChatMapper {
    
    func dtoToEntity(dto: [DMDTO]) -> [DMEntity] {
        return dto.map { DMEntity(dmId: $0.dmId, roomId: $0.roomId, content: $0.content, createdAt: $0.createdAt, files: $0.files, user: dtoToEntity(dto: $0.user)) }
    }
    
    func dtoToEntity(dto: [ChatDTO]) -> [ChatEntity] {
        return dto.map { ChatEntity(channelId: $0.channelId, channelName: $0.channelName, chatId: $0.chatId, content: $0.content, createdAt: $0.createdAt, files: $0.files, user: dtoToEntity(dto: $0.user))}
    }
    
    func dtoToEntity(dto: DMDTO) -> DMEntity {
        return DMEntity(dmId: dto.dmId, roomId: dto.roomId, content: dto.content, createdAt: dto.createdAt, files: dto.files, user: dtoToEntity(dto: dto.user))
    }
    
    func dtoToEntity(dto: ChatDTO) -> ChatEntity {
        return ChatEntity(channelId: dto.channelId, channelName: dto.channelName, chatId: dto.chatId, content: dto.content, createdAt: dto.createdAt, files: dto.files, user: dtoToEntity(dto: dto.user))
    }
}

extension ChatMapper {
    private func dtoToEntity(dto: MemberInfoDTO) -> MemberInfoEntity {
        return MemberInfoEntity(userId: dto.userId, email: dto.email, nickname: dto.nickname, profileImage: dto.profileImage)
    }
}
