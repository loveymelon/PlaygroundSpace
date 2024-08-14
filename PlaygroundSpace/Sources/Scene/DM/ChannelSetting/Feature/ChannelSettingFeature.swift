//
//  ChannelSettingFeature.swift
//  PlaygroundSpace
//
//  Created by 김진수 on 8/12/24.
//

import Foundation
import ComposableArchitecture

@Reducer
struct ChannelSettingFeature {
    @ObservableState
    struct State: Equatable {
        var channelId: String
        var channelData: PointChannelEntity = PointChannelEntity()
        var ownerIsValid: Bool = false
        
        @Presents var channelEditState: ChannelCreateFeature.State?
        @Presents var channelOwnerState: ChannelOwnerFeature.State?
    }
    
    enum Action {
        case viewEventType(ViewEventType)
        case dataTransType(DataTransType)
        case networkType(NetworkType)
        
        case checkOwner
        
        case channelEditAction(PresentationAction<ChannelCreateFeature.Action>)
        case channelOwnerAction(PresentationAction<ChannelOwnerFeature.Action>)
        
        case delegate(Delegate)
        enum Delegate {
            case channelEditComplete(String)
            case channelOut
            case channelDelete
        }
    }
    
    enum ViewEventType {
        case onAppear
        case channelButtonType(ChannelButtonType)
        
        enum ChannelButtonType {
            case channelEdit
            case channelOut
            case channelOwnerChange
            case channelDelete
        }
    }
    
    enum DataTransType {
        case pointChannelData(PointChannelEntity)
    }
    
    enum NetworkType {
        case fetchPointChannel
    }
    
    private let repository = ChannelSettingRepository()
    
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
                
            case .viewEventType(.onAppear):
                return .run { send in
                    await send(.networkType(.fetchPointChannel))
                }
                
            case .networkType(.fetchPointChannel):
                return .run { [state = state] send in
                    let result = await repository.fetchPointChannel(channelId: state.channelId)
                    
                    guard let data = result else { return }
                    
                    await send(.dataTransType(.pointChannelData(data)))
                }
                
            case let .dataTransType(.pointChannelData(entity)):
                state.channelData = entity
                
                return .send(.checkOwner)
                
            case .checkOwner:
                state.ownerIsValid = (state.channelData.ownerId == UserDefaultsManager.shared.userId) ? true : false
                
            case .viewEventType(.channelButtonType(.channelEdit)):
                state.channelEditState = ChannelCreateFeature.State(beforeView: .channelSetting, channelId: state.channelId)
                
            case .channelEditAction(.presented(.delegate(.backButtonTapped))):
                return .run { send in
                    await send(.channelEditAction(.dismiss))
                }
                
            case let .channelEditAction(.presented(.delegate(.editComplete(channelTitle)))):
                return .run { send in
                    await send(.channelEditAction(.dismiss))
                    await send(.networkType(.fetchPointChannel))
                    await send(.delegate(.channelEditComplete(channelTitle)))
                }
                
            case .viewEventType(.channelButtonType(.channelOwnerChange)):
                state.channelOwnerState = ChannelOwnerFeature.State(channelId: state.channelId, beforeViewType: .channel)
                
            case .channelOwnerAction(.presented(.delegate(.backButtonTapped))):
                return .run { send in
                    await send(.channelOwnerAction(.dismiss))
                }
                
            case .channelOwnerAction(.presented(.delegate(.ownerChange))):
                return .run { send in
                    await send(.networkType(.fetchPointChannel))
                    await send(.channelOwnerAction(.dismiss))
                }
                
            case .viewEventType(.channelButtonType(.channelOut)):
                return .run { [state = state] send in
                    if !state.ownerIsValid {
                        let result = await repository.channelOut(channelId: state.channelId)
                        
                        await send(.delegate(.channelOut))
                    } else {
                        print("nononononono")
                    }
                }
                
            case .viewEventType(.channelButtonType(.channelDelete)):
                return .run { [state = state] send in
                    let result = await repository.deleteChannel(channelId: state.channelId)
                    
                    guard let void = result else {
                        print("error")
                        return
                    }
                    
                    await send(.delegate(.channelDelete))
                }
                
            default:
                break
            }
            return .none
        }
        .ifLet(\.$channelEditState, action: \.channelEditAction) {
            ChannelCreateFeature()
        }
        .ifLet(\.$channelOwnerState, action: \.channelOwnerAction) {
            ChannelOwnerFeature()
        }
    }
}
