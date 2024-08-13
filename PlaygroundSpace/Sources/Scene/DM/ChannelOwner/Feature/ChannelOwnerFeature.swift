//
//  ChannelOwnerFeature.swift
//  PlaygroundSpace
//
//  Created by 김진수 on 8/13/24.
//

import Foundation
import ComposableArchitecture

@Reducer
struct ChannelOwnerFeature {
    @ObservableState
    struct State: Equatable {
        var channelId: String
        var memberInfo: [MemberInfoEntity] = []
    }
    
    enum Action {
        case viewEventType(ViewEventType)
        case dataTransType(DataTransType)
        case networkType(NetworkType)
        
        case delegate(Delegate)
        enum Delegate {
            case backButtonTapped
            case ownerChange
        }
    }
    
    enum ViewEventType {
        case onAppear
        case backButtonTapped
        case memberTapped(String)
    }
    
    enum DataTransType {
        case memberInfo([MemberInfoEntity])
    }
    
    enum NetworkType {
        case fetchChannelMember
        case changeOwner(String)
    }
    
    private let repository = ChannelOwnerRepository()
    
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .viewEventType(.onAppear):
                return .run { send in
                    await send(.networkType(.fetchChannelMember))
                }
                
            case let .viewEventType(.memberTapped(userId)):
                return .run { send in
                    await send(.networkType(.changeOwner(userId)))
                }
                
            case .networkType(.fetchChannelMember):
                return .run { [state = state] send in
                    let result = await repository.fetchChannelMember(channelId: state.channelId)
                    
                    await send(.dataTransType(.memberInfo(result)))
                }
                
            case let .networkType(.changeOwner(ownerId)):
                return .run { [state = state] send in
                    let result = await repository.changeOwner(channelId: state.channelId, ownerId: ownerId)
                    
                    await send(.delegate(.ownerChange))
                }
                
            case let .dataTransType(.memberInfo(entitys)):
                state.memberInfo = entitys
                
            default:
                break
            }
            return .none
        }
    }
}
