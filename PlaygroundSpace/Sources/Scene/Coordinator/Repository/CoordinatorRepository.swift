//
//  CoordinatorRepository.swift
//  PlaygroundSpace
//
//  Created by 김진수 on 7/30/24.
//

import Foundation
import ComposableArchitecture

final class CoordinatorRepository {
    private let mapper = CoordinatorMapper()
    
    @Dependency(\.networkManager) var network
    
    func fetchWorkspaceList() async -> [WorkspaceListEntity] {
        do {
            let result = try await network.requestNetwork(dto: WorkSpaceListDTO.self, router: WorkspaceRouter.fetch)
            
            switch result {
            case .success(let data):
                return mapper.dtoToEntity(dto: data)
            case .failure(let error):
                print(error)
                return []
            }
        } catch {
            print(error)
            return []
        }
    }
    
    func workSpaceOut() async -> [WorkspaceListEntity] {
        do {
            let result = try await network.requestNetwork(dto: WorkSpaceListDTO.self, router: WorkspaceRouter.workSpaceOut)
            
            switch result {
            case .success(let data):
                return mapper.dtoToEntity(dto: data)
            case .failure(let error):
                print("workOut", error)
                return []
            }
        } catch {
            print(error)
            return []
        }
    }
    
    func fetchPointChannel() async -> [ChannelEntity] {
        do {
            let result = try await network.requestNetwork(dto: PointWorkSpaceInfoDTO.self, router: WorkspaceRouter.fetchPointWorkSpace)
            
            switch result {
            case .success(let data):
                return mapper.dtoToEntity(data.channels.channelList)
            case .failure(let error):
                print(error)
                return []
            }
        } catch {
            print(error)
            return []
        }
    }
    
    func deleteWorkSpace() async -> Void? {
        do {
            let result = try await network.requestNetwork(router: WorkspaceRouter.workSpaceDelete)
            
            switch result {
            case .success(_):
                return ()
            case .failure(let error):
                print(error)
                return nil
            }
        } catch {
            print(error)
            return nil
        }
    }
}
