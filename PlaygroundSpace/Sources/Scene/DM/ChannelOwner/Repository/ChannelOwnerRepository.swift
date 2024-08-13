//
//  ChannelOwnerRepository.swift
//  PlaygroundSpace
//
//  Created by 김진수 on 8/13/24.
//

import Foundation
import ComposableArchitecture

struct ChannelOwnerRepository {
    
    private let mapper = ChannelOwnerMapper()
    
    @Dependency(\.networkManager) var network
    
    func fetchChannelMember(channelId: String) async -> [MemberInfoEntity] {
        do {
            let result = try await network.requestNetwork(dto: MemberIfnoListDTO.self, router: ChannelRouter.fetchMembers(channelId))
            
            switch result {
            case .success(let data):
                return mapper.dtoToEntity(data.memberIfnoListDTO)
            case .failure(let error):
                print(error.localizedDescription)
                return []
            }
        } catch {
            print(error.localizedDescription)
            return []
        }
    }
    
    func changeOwner(channelId: String, ownerId: String) async -> ChannelEntity? {
        let requestDTO = OwnerRequestDTO(owner_id: ownerId)
        
        do {
            let result = try await network.requestNetwork(dto: ChannelDTO.self, router: ChannelRouter.changeOwner(channelId, requestDTO))
            
            switch result {
            case .success(let data):
                return mapper.dtoToEntity(data)
            case .failure(let error):
                print(error)
                return nil
            }
        } catch {
            print(error.localizedDescription)
            return nil
        }
    }
    
}
