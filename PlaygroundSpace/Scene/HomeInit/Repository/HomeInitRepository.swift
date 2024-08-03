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
    
    func fetchChannel(workSpaceId: String) async -> ChannelListEntity? {
        print("work", workSpaceId)
        do {
            let result = try await network.requestNetwork(dto: ChannelListDTO.self, router: ChannelRouter.fetchMyChannel(workSpaceId))
            
            switch result {
            case .success(let data):
                print("success", data)
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
    
}
