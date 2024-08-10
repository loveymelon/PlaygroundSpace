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
        var messageText: String = ""
    }
    
    enum Action: BindableAction {
        case binding(BindingAction<State>)
        
        case onAppear
        case dataTransType(DataTransType)
        case pushChat
        case network(NetworkType)
        case finishPush
    }
    
    enum NetworkType {
        case fetchDMList
        case socketConnect
        case pushMessage(String)
    }
    
    enum DataTransType {
        case dmList([DMEntity])
        case dmAppend(DMEntity)
    }
    
    private let repository = ChatRepository()
    
    var body: some ReducerOf<Self> {
        BindingReducer()
        
        Reduce { state, action in
            switch action {
            case .onAppear:
                return .run { send in
                    await send(.network(.fetchDMList))
                }
                
            case .pushChat:
                return .run { [state = state] send in
                    await send(.network(.pushMessage(state.messageText)))
                }
                
            case let .network(.pushMessage(content)):
                return .run { [state = state] send in
                    let result = await repository.pushMessage(roomId: state.chatRoomData.roomId, content: content, files: [])
                    
                    guard let data = result else { return }
                    
                    await send(.finishPush)
                }
                
            case .network(.fetchDMList):
                return .run { [state = state] send in
                    let result = await repository.fetchMessageList(roomId: state.chatRoomData.roomId)
                    
                    guard let dmList = result else { return }
                    
                    await send(.dataTransType(.dmList(dmList)))
                }
                
            case let .dataTransType(.dmList(dmList)):
                state.dmList = dmList
                
                return .run { send in
                    await send(.network(.socketConnect))
                }
                
            case .network(.socketConnect):
                return .run { [state = state] send in
                    for await item in repository.connectSocket(roomId: state.chatRoomData.roomId) {
                        guard let dm = item else { return }
                        
                        await send(.dataTransType(.dmAppend(dm)))
                    }
                }
                
            case let .dataTransType(.dmAppend(dmEntity)):
                state.dmList.append(dmEntity)
                
            case .finishPush:
                state.messageText = ""
                
            default:
                break
            }
            
            return .none
        }
    }
}
