//
//  AllChannelFeature.swift
//  PlaygroundSpace
//
//  Created by 김진수 on 8/11/24.
//

import Foundation
import ComposableArchitecture

@Reducer
struct AllChannelFeature {
    @ObservableState
    struct State: Equatable {
        var channelList: [ChannelEntity] = []
    }
    
    enum Action {
        case networkType(NetworkType)
        case transDataType(TransDataType)
        case viewEventType(ViewEventType)
        
        case delegate(Delegate)
        enum Delegate {
            case channelTapped(ChannelEntity)
            case backButtonTapped
        }
    }
    
    enum NetworkType {
        case fetchAllChannel
    }
    
    enum TransDataType {
        case channelList([ChannelEntity])
    }
    
    enum ViewEventType {
        case onAppear
        case channelTapped(ChannelEntity)
        case backButtonTapped
    }
    
    private let repository = AllChannelRepository()
    
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .viewEventType(.onAppear):
                return .run { send in
                    await send(.networkType(.fetchAllChannel))
                }
                
            case let .viewEventType(.channelTapped(entity)):
                return .run { send in
                    await send(.delegate(.channelTapped(entity)))
                }
                
            case .viewEventType(.backButtonTapped):
                return .run { send in
                    await send(.delegate(.backButtonTapped))
                }
                
            case .networkType(.fetchAllChannel):
                return .run { send in
                    let result = await repository.fetchAllChannel()
                    
                    guard let channels = result else { return }
                    
                    await send(.transDataType(.channelList(channels)))
                }
                
            case let .transDataType(.channelList(entity)):
                state.channelList = entity
                
            default:
                break
            }
            return .none
        }
    }
}
