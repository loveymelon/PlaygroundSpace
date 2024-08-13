//
//  ChannelSettingRepository.swift
//  PlaygroundSpace
//
//  Created by 김진수 on 8/12/24.
//

import Foundation
import ComposableArchitecture

struct ChannelSettingRepository {
    private let mapper = ChannelSettingMapper()
    
    @Dependency(\.networkManager) var network
    
    func fetchPointChannel(channelId: String) async -> PointChannelEntity? {
        do {
            let result = try await network.requestNetwork(dto: PointChannelDTO.self, router: ChannelRouter.fetchPointChannel(channelId))
            
            switch result {
            case .success(let data):
                return mapper.dtoToEntity(data)
            case .failure(let error):
                print(error.localizedDescription)
                return nil
            }
        } catch {
            print(error.localizedDescription)
            return nil
        }
    }
    
    func channelOut(channelId: String) async -> [ChannelEntity] {
        do {
            let result = try await network.requestNetwork(dto: ChannelListDTO.self, router: ChannelRouter.channelOut(channelId))
            
            switch result {
            case .success(let data):
                return mapper.dtoToEntity(data.channelList)
            case .failure(let error):
                print(error.localizedDescription)
                return []
            }
        } catch {
            print(error)
            return []
        }
    }
    
    func deleteChannel(channelId: String) async -> Void? {
        do {
            let result = try await network.requestNetwork(router: ChannelRouter.channelDelete(channelId))
            
            switch result {
            case .success(let data):
                return ()
            case .failure(let error):
                print(error.localizedDescription)
                return nil
            }
        } catch {
            print(error.localizedDescription)
            return nil
        }
    }

}
