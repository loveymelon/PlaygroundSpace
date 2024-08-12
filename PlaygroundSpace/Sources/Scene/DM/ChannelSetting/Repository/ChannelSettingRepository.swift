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
}
