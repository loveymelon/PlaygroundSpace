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
        var channelId: String = ""
        var channelTitle: String = ""
        var dmList: [DMEntity] = []
        var chatList: [ChatEntity] = []
        var messageText: String = ""
        var beforeView: BeforeView
        var showImage: Bool = false
        var imageData: [Data] = []
        
        var imageLimit = 5
        var title: String = ""
        
        var onAppearTrigger = true
    }
    
    enum Action: BindableAction {
        case binding(BindingAction<State>)
        
        case onAppear
        case pushChat
        case selectedFinish([Data])
        case finishPush
        case plusTapped
        case deleteImage(Int)
        case channelSettingTapped
        
        case catchTitle(String)
        
        case dataTransType(DataTransType)
        case network(NetworkType)
        
        case delegate(Delegate)
        enum Delegate {
            case channelSettingTapped(String)
        }
    }
    
    enum NetworkType {
        case fetchDMList
        case fetchChatList
        case socketConnect
        case pushMessage(String)
    }
    
    enum DataTransType {
        case dmList([DMEntity])
        case dmAppend(DMEntity)
        case chatList([ChatEntity])
        case chatAppend(ChatEntity)
        case title(String)
    }
    
    enum BeforeView {
        case dmList
        case allChannel
    }
    
    private let repository = ChatRepository()
    
    var body: some ReducerOf<Self> {
        BindingReducer()
        
        Reduce { state, action in
            switch action {
            case .onAppear:
                return .run { [state = state] send in
                    if state.beforeView == .dmList {
                        await send(.network(.fetchDMList))
                        await send(.dataTransType(.title(state.chatRoomData.user.nickname)))
                    } else {
                        await send(.network(.fetchChatList))
                        if state.onAppearTrigger {
                            await send(.dataTransType(.title(state.channelTitle)))
                        }
                    }
                }
                
            case .pushChat:
                return .run { [state = state] send in
                    await send(.network(.pushMessage(state.messageText)))
                }
                
            case let .network(.pushMessage(content)):
                return .run { [state = state] send in
                    if state.beforeView == .dmList {
                        let result = await repository.pushMessage(roomId: state.chatRoomData.roomId, content: content, files: state.imageData)
                        
                        guard let data = result else { return }
                        
                        await send(.finishPush)
                    } else {
                        let result = await repository.channelPushMessage(channelId: state.channelId, content: content, files: state.imageData)
                        
                        guard let data = result else { return }
                        
                        await send(.finishPush)
                    }
                }
                
            case .network(.fetchDMList):
                return .run { [state = state] send in
                    
                    let result = await repository.fetchMessageList(roomId: state.chatRoomData.roomId)
                    
                    guard let dmList = result else { return }
                    
                    await send(.dataTransType(.dmList(dmList)))
                    
                }
                
            case .network(.fetchChatList):
                return .run { [state = state] send in
                    let result = await repository.channelFetchMessageList(channelId: state.channelId)
                    
                    guard let chatList = result else { return }
                    
                    await send(.dataTransType(.chatList(chatList)))
                }
                
            case .network(.socketConnect):
                return .run { [state = state] send in
                    if state.beforeView == .dmList {
                        for await item in repository.connectSocket(roomId: state.chatRoomData.roomId) {
                            guard let dm = item else { return }
                            
                            await send(.dataTransType(.dmAppend(dm)))
                        }
                    } else {
                        for await item in repository.connectChannelSocket(channelId: state.channelId) {
                            guard let chat = item else { return }
                            
                            await send(.dataTransType(.chatAppend(chat)))
                        }
                    }
                }
                
            case let .dataTransType(.dmList(dmList)):
                state.dmList = dmList
                
                return .run { send in
                    await send(.network(.socketConnect))
                }
                
            case let .dataTransType(.dmAppend(dmEntity)):
                state.dmList.append(dmEntity)
                
            case let .dataTransType(.chatList(chatList)):
                state.chatList = chatList
                
                return .run { send in
                    await send(.network(.socketConnect))
                }
                
            case let .dataTransType(.chatAppend(chatEntity)):
                state.chatList.append(chatEntity)
                
            case .plusTapped:
                if state.imageLimit == 0 {
                    state.showImage = false
                } else {
                    state.showImage = true
                }
                
            case let .selectedFinish(imageData):
                state.imageData.append(contentsOf: imageData)
                state.imageLimit = 5 - imageData.count
                
            case let .deleteImage(index):
                state.imageData.remove(at: index)
                state.imageLimit += 1
                
            case .channelSettingTapped:
                return .run { [state = state] send in
                    await send(.delegate(.channelSettingTapped(state.channelId)))
                }
                
            case let .dataTransType(.title(title)):
                state.title = title
                state.onAppearTrigger = false
                
            case let .catchTitle(title):
                print("catchcatchcatch", title)
                state.title = title
                
            case .finishPush:
                state.messageText = ""
                state.imageData = []
            default:
                break
            }
            
            return .none
        }
    }
}
