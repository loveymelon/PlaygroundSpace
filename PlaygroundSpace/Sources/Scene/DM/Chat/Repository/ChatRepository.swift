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
    
    func pushMessage(roomId: String, content: String, files: [Data]) async -> DMEntity? {
        do {
            let result = try await network.requestNetwork(dto: DMDTO.self, router: DMSRouter.pushMessage(roomId, content, files))
            
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
    
    func connectSocket(roomId: String) -> AsyncStream<DMEntity?> {
        return AsyncStream { continues in
            Task {
                let result = SocketIOManager.shared.connectDTO(to: .dmsChat(roomID: roomId), type: DMDTO.self)
                
                for await item in result {
                    switch item {
                    case .success(let data):
                        continues.yield(mapper.dtoToEntity(dto: data))
                    case .failure(let error):
                        continues.yield(nil)
                    }
                }
            }
        }
        
    }
    
    func channelPushMessage(channelId: String, content: String, files: [Data]) async -> ChatEntity? {
        do {
            let result = try await network.requestNetwork(dto: ChatDTO.self, router: ChannelRouter.pushMessage(channelId, content, files))
            
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
    
    func channelFetchMessageList(channelId: String) async -> [ChatEntity]? {
        do {
            let result = try await network.requestNetwork(dto: ChatListDTO.self, router: ChannelRouter.fetchDMList(channelId))
            
            switch result {
            case .success(let data):
                print(data.chatListDTO.last)
                return mapper.dtoToEntity(dto: data.chatListDTO)
            case .failure(let error):
                print(error)
                return nil
            }
        } catch {
            print(error.localizedDescription)
            return nil
        }
    }
    
    func connectChannelSocket(channelId: String) -> AsyncStream<ChatEntity?> {
        return AsyncStream { continues in
            Task {
                let result = SocketIOManager.shared.connectDTO(to: .channelChat(channelID: channelId), type: ChatDTO.self)
                
                for await item in result {
                    switch item {
                    case let .success(data):
                        continues.yield(mapper.dtoToEntity(dto: data))
                    case let .failure(failure):
                        continues.yield(nil)
                    }
                }
            }
        }
    }
}
