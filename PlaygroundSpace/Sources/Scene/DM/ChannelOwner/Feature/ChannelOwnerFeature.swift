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
        var beforeViewType: BeforeViewType
    }
    
    enum BeforeViewType {
        case channel
        case sideMenu
    }
    
    enum Action {
        case viewEventType(ViewEventType)
        case dataTransType(DataTransType)
        case networkType(NetworkType)
        
        case delegate(Delegate)
        enum Delegate {
            case backButtonTapped
            case ownerChange
            case workSpaceOwnerChange(String)
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
        case fetchWorkSpaceMember
        case changeOwner(String)
        case workSpaceChangeOwner(String)
    }
    
    private let repository = ChannelOwnerRepository()
    
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .viewEventType(.onAppear):
                return .run { [state = state] send in
                    if state.beforeViewType == .channel {
                        await send(.networkType(.fetchChannelMember))
                    } else {
                        await send(.networkType(.fetchWorkSpaceMember))
                    }
                }
                
            case let .viewEventType(.memberTapped(userId)):
                return .run { [state = state] send in
                    if state.beforeViewType == .channel {
                        await send(.networkType(.changeOwner(userId)))
                    } else {
                        await send(.networkType(.workSpaceChangeOwner(userId)))
                    }
                }
                
            case .networkType(.fetchChannelMember):
                return .run { [state = state] send in
                    let result = await repository.fetchChannelMember(channelId: state.channelId)
                    
                    await send(.dataTransType(.memberInfo(result)))
                }
                
            case .networkType(.fetchWorkSpaceMember):
                return .run { send in
                    let result = await repository.fetchWorkSpaceMember()
                    
                    await send(.dataTransType(.memberInfo(result)))
                }
                
            case let .networkType(.changeOwner(ownerId)):
                return .run { [state = state] send in
                    let result = await repository.changeOwner(channelId: state.channelId, ownerId: ownerId)
                    
                    await send(.delegate(.ownerChange))
                }
                
            case let .networkType(.workSpaceChangeOwner(ownerId)):
                return .run { send in
                    let result = await repository.workSpaceChangeOwner(ownerId: ownerId)
                    
                    guard let data = result else { return }
                    
                    await send(.delegate(.workSpaceOwnerChange(data.ownerID)))
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
