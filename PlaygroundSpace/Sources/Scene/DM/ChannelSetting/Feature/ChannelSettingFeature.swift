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
        var channelData: PointChannelEntity
    }
    
    enum Action {
        case viewEventType(ViewEventType)
        case dataTransType(DataTransType)
        
        case delegate(Delegate)
        enum Delegate {
            case backButtonTapped
        }
    }
    
    enum ViewEventType {
        case onAppear
        case backButtonTapped
    }
    
    enum DataTransType {
        case pointChannelData(PointChannelEntity)
    }
    
    private let repository = ChannelSettingRepository()
    
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
                
            case .viewEventType(.onAppear):
                return .run { [state = state] send in
                    let result = await repository.fetchPointChannel(channelId: state.channelId)
                    
                    guard let data = result else { return }
                    
                    await send(.dataTransType(.pointChannelData(data)))
                }
                
            case .viewEventType(.backButtonTapped):
                return .run { send in
                    await send(.delegate(.backButtonTapped))
                }
                
            case let .dataTransType(.pointChannelData(entity)):
                state.channelData = entity
                
            default:
                break
            }
            return .none
        }
    }
}
