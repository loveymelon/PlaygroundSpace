//
//  HomeInitMapper.swift
//  PlaygroundSpace
//
//  Created by 김진수 on 8/3/24.
//

import Foundation

struct HomeInitMapper {
    
    func dtoToEntity(channelDTO: ChannelDTO) -> ChannelEntity {
        return ChannelEntity(channelId: channelDTO.channelId, name: channelDTO.name, description: channelDTO.description, coverImage: channelDTO.coverImage, ownerId: channelDTO.ownerId, createdAt: channelDTO.createdAt)
    }
    
    func dtoToEntity(_ channelListDTO: ChannelListDTO) -> ChannelListEntity {
        return ChannelListEntity(channelList: channelListDTO.channelList.map { dtoToEntity(channelDTO: $0) })
    }
    
    /// MemberInfoDTO -> MemberInfoEntity
    func dtoToEntity(_ memberInfoDTO: MemberInfoDTO) -> MemberInfoEntity {
        return MemberInfoEntity(userId: memberInfoDTO.userId, email: memberInfoDTO.email, nickname: memberInfoDTO.nickname, profileImage: memberInfoDTO.profileImage)
    }
    
    /// DMSDTO -> DMSEntity
    func dtoToEntity(_ dmsDTO: DMSDTO) -> DMSEntity {
        return DMSEntity(roomId: dmsDTO.roomId, createdAt: dmsDTO.createdAt, user: dtoToEntity(dmsDTO.user))
    }
    
    /// DMListDTO -> DMListEntity
    func dtoToEntity(_ dmListDTO: DMListDTO) -> DMListEntity {
        return DMListEntity(dmlist: dmListDTO.dmListDTO.map { dtoToEntity($0) } )
    }
}
