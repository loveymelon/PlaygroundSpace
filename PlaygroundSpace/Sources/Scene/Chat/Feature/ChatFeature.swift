//
//  ChatFeature.swift
//  PlaygroundSpace
//
//  Created by 김진수 on 8/8/24.
//

import Foundation
import ComposableArchitecture

@Reducer
struct ChatFeature {
    @ObservableState
    struct State: Equatable {
        var chatRoomData: DMSEntity
        var dmList: [DMEntity] = []
    }
    
    enum Action {
        case onAppear
        case dataTransType(DataTransType)
        case pushChat(String)
        case network(NetworkType)
    }
    
    enum NetworkType {
        case fetchDMList
        case pushMessage(String)
    }
    
    enum DataTransType {
        case dmList([DMEntity])
    }
    
    private let repository = ChatRepository()
    
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .onAppear:
                return .run { send in
                    await send(.network(.fetchDMList))
                }
                
            case let .pushChat(content):
                return .run { send in
                    await send(.network(.pushMessage(content)))
                }
                
            case let .network(.pushMessage(content)):
                return .run { [state = state] send in
                    let result = await repository.pushMessage(roomId: state.chatRoomData.roomId, content: content, files: [])
                    
                    guard let data = result else { return }
                    
                    print(data)
                }
                
            case .network(.fetchDMList):
                return .run { [state = state] send in
                    let result = await repository.fetchMessageList(roomId: state.chatRoomData.roomId)
                    
                    guard let dmList = result else { return }
                    
                    await send(.dataTransType(.dmList(dmList)))
                }
                
            case let .dataTransType(.dmList(dmList)):
                state.dmList = dmList
                
            default:
                break
            }
            
            return .none
        }
    }
}
