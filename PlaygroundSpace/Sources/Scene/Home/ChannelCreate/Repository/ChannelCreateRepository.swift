//
//  ChannelCreateRepository.swift
//  PlaygroundSpace
//
//  Created by 김진수 on 8/11/24.
//

import Foundation
import ComposableArchitecture

struct ChannelCreateRepository {
    private let mapper = ChannelCreateMapper()
    
    @Dependency(\.networkManager) var network
    
    func createChannel(name: String, explain: String) async -> Void? {
        do {
            let result = try await network.requestNetwork(dto: ChannelDTO.self, router: ChannelRouter.createChannel(name, explain))
            
            switch result {
            case .success(_):
                return ()
            case .failure(let error):
                print(error)
                return nil
            }
        } catch {
            print(error.localizedDescription)
            return nil
        }
    }
    
    func channelEdit(channelId: String, content: String, description: String) async -> ChannelEntity? {
        do {
            let result = try await network.requestNetwork(dto: ChannelDTO.self, router: ChannelRouter.channelEdit(channelId, content, description))
            
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
