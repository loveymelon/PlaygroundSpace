//
//  DMListRepository.swift
//  PlaygroundSpace
//
//  Created by 김진수 on 8/6/24.
//

import Foundation
import ComposableArchitecture

struct DMListRepository {
    private let mapper = DMListMapper()
    
    @Dependency(\.networkManager) var network
    
    func createDMRoom(opponentId: String) async -> DMSEntity? {
        
        let requestDTO = mapper.userIdToRequestDTO(userId: opponentId)
        
        do {
            let result = try await network.requestNetwork(dto: DMSDTO.self, router: DMSRouter.createDMRoom(requestDTO))
            
            switch result {
            case .success(let data):
                return mapper.dtoToEntity(dto: data)
            case .failure(let error):
                print(error)
                return nil
            }
            
        } catch {
            print(error)
            return nil
        }
    }
    
    /// fetch[MemberInfoEntity]
    func fetchMember() async -> [MemberInfoEntity]? {
        do {
            let result = try await network.requestNetwork(dto: MemberIfnoListDTO.self, router: WorkspaceRouter.fetchMember)
            
            switch result {
            case .success(let data):
                return mapper.dtoToEntity(data.memberIfnoListDTO) 
            case .failure(let error):
                print(error)
                return nil
            }
        } catch {
            print(error.localizedDescription)
            return nil
        }
    }
    
    /// fetch[DMSEntity]
    func fetchDMRoomList() async -> [DMSEntity]? {
        do {
            let result = try await network.requestNetwork(dto: DMRoomList.self, router: DMSRouter.fetchDMRoomList)
            
            switch result {
            case .success(let data):
                return mapper.dtoToEntity(data.dmListDTO)
            case .failure(let error):
                print(error)
                return nil
            }
        } catch {
            print(error.localizedDescription)
            return nil
        }
    }
    
    func fetchDMList(roomId: String) async -> [DMEntity]? {
        do {
            let result = try await network.requestNetwork(dto: DMListDTO.self, router: DMSRouter.fetchDMList(roomId))
            
            switch result {
            case .success(let data):
                print(data)
                return mapper.dtoToEntity(data.dmListDTO)
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
