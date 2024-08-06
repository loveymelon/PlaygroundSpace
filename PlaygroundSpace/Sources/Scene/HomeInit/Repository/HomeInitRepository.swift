//
//  HomeInitRepository.swift
//  PlaygroundSpace
//
//  Created by 김진수 on 8/3/24.
//

import Foundation
import ComposableArchitecture

struct HomeInitRepository {
    
    private let mapper = HomeInitMapper()
    
    @Dependency(\.networkManager) var network
    
}

extension HomeInitRepository {
    /// fetchChannel
    func fetchData(workSpaceId: String) async -> ChannelListEntity? {
        do {
            let result = try await network.requestNetwork(dto: ChannelListDTO.self, router: ChannelRouter.fetchMyChannel(workSpaceId))
            
            switch result {
            case .success(let data):
                return mapper.dtoToEntity(data)
            case .failure(let error):
                print("error", error)
                return nil
            }
        } catch {
            print(error.localizedDescription)
            return nil
        }
    }
    
    /// fetchDMS
    func fetchData() async -> DMListEntity? {
        do {
            let result = try await network.requestNetwork(dto: DMListDTO.self, router: DMSRouter.fetchDMList)
            
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
