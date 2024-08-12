//
//  DMListMapper.swift
//  PlaygroundSpace
//
//  Created by 김진수 on 8/6/24.
//

import Foundation

struct DMListMapper {
    
    func userIdToRequestDTO(userId: String) -> DMRequestDTO {
        return DMRequestDTO(opponent_id: userId)
    }
    
    /// DMSDTO -> DMSEntity
    func dtoToEntity(dto: DMSDTO) -> DMSEntity {
        return DMSEntity(roomId: dto.roomId, createdAt: dto.createdAt, user: dtoToEntity(dto.user))
    }
    
    /// [MemberInfoDTO] -> [MemberInfoEntity]
    func dtoToEntity(_ dto: [MemberInfoDTO]) -> [MemberInfoEntity] {
        return dto.map { MemberInfoEntity(userId: $0.userId, email: $0.email, nickname: $0.nickname, profileImage: $0.profileImage) }
    }

    /// [DMSDTO] -> [DMSEntity]
    func dtoToEntity(_ dto: [DMSDTO]) -> [DMSEntity] {
        return dto.map { DMSEntity(roomId: $0.roomId, createdAt: $0.createdAt, user: dtoToEntity($0.user))}
    }
    
    func dtoToEntity(_ dto: [DMDTO]) -> [DMEntity] {
        return dto.map { DMEntity(dmId: $0.dmId, roomId: $0.roomId, content: $0.content, createdAt: $0.createdAt, files: $0.files, user: dtoToEntity($0.user)) }
    }
    
    func dtoToEntity(dto: [DMDTO]) -> [DMEntity] {
        return dto.map { DMEntity(dmId: $0.dmId, roomId: $0.roomId, content: $0.content, createdAt: $0.createdAt, files: $0.files, user: dtoToEntity($0.user)) }
    }
}

extension DMListMapper {
    private func dtoToEntity(_ dto: MemberInfoDTO) -> MemberInfoEntity {
        return MemberInfoEntity(userId: dto.userId, email: dto.email, nickname: dto.nickname, profileImage: dto.profileImage)
    }
}
