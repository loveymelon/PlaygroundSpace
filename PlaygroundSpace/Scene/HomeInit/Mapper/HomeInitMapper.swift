//
//  HomeInitMapper.swift
//  PlaygroundSpace
//
//  Created by 김진수 on 8/3/24.
//

import Foundation

final class HomeInitMapper {
    
    func dtoToEntity(channelDTO: ChannelDTO) -> ChannelEntity {
        return ChannelEntity(channelId: channelDTO.channelId, name: channelDTO.name, description: channelDTO.description, coverImage: channelDTO.coverImage, ownerId: channelDTO.ownerId, createdAt: channelDTO.createdAt)
    }
    
    func dtoToEntity(_ channelListDTO: ChannelListDTO) -> ChannelListEntity {
        return ChannelListEntity(channelList: channelListDTO.channelList.map { dtoToEntity(channelDTO: $0) })
    }
    
}
