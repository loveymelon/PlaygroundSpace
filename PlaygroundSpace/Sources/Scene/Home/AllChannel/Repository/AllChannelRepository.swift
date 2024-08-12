//
//  AllChannelRepository.swift
//  PlaygroundSpace
//
//  Created by 김진수 on 8/11/24.
//

import Foundation
import ComposableArchitecture

struct AllChannelRepository {
    
    private let mapper = AllChannelMapper()
    
    @Dependency(\.networkManager) var network
    
    func fetchAllChannel() async -> [ChannelEntity]? {
        do {
            
            let result = try await network.requestNetwork(dto: ChannelListDTO.self, router: ChannelRouter.fetchAllChannel)
            
            switch result {
            case let .success(data):
                return mapper.dtoToEntity(dto: data.channelList)
            case let .failure(error):
                print(error.localizedDescription)
                return nil
            }
            
        } catch {
            print(error.localizedDescription)
            return nil
        }
        
    }
}
