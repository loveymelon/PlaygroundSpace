//
//  ChatRepository.swift
//  PlaygroundSpace
//
//  Created by 김진수 on 8/8/24.
//

import Foundation
import ComposableArchitecture

struct ChatRepository {
    
    private let mapper = ChatMapper()
    
    @Dependency(\.networkManager) var network
    
    func fetchMessageList(roomId: String) async -> [DMEntity]? {
        do {
            let result = try await network.requestNetwork(dto: DMListDTO.self, router: DMSRouter.fetchDMList(roomId))
            
            switch result {
            case .success(let data):
                return mapper.dtoToEntity(dto: data.dmListDTO)
            case .failure(let error):
                print(error)
                return nil
            }
        } catch {
            print(error.localizedDescription)
            return nil
        }
    }
    
    func pushMessage(roomId: String, content: String, files: [String]) async -> DMEntity? {
        do {
            let result = try await network.requestNetwork(dto: DMDTO.self, router: DMSRouter.pushMessage(roomId, content, []))
            
            switch result {
            case .success(let data):
                print("sendResult", data)
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
}
