//
//  ChannelCoordinator.swift
//  PlaygroundSpace
//
//  Created by 김진수 on 8/11/24.
//

import Foundation
import TCACoordinators
import ComposableArchitecture

@Reducer(state: .equatable)
enum ChannelScreen {
    case channelAllView(AllChannelFeature)
}

@Reducer
struct ChannelCoordinator {
    
    @ObservableState
    struct State: Equatable {
        
        static let initial = Self(routes: [.root(.channelAllView(AllChannelFeature.State()), embedInNavigationView: true)])
        
        var routes: IdentifiedArrayOf<Route<ChannelScreen.State>>
    }
    
    enum Action {
        case router(IdentifiedRouterActionOf<ChannelScreen>)
        
        case delegate(Delegate)
        enum Delegate {
            case dismissPresent
            case channelTouch(ChannelEntity)
        }
    }
    
    var body: some ReducerOf<Self> {
        
        Reduce { state, action in
            switch action {
            case .router(.routeAction(id: _, action: .channelAllView(.delegate(.backButtonTapped)))):
                return .run { send in
                    await send(.delegate(.dismissPresent))
                }
            case let .router(.routeAction(id: _, action: .channelAllView(.delegate(.channelTapped(entity))))):
                return .run { send in
                    await send(.delegate(.channelTouch(entity)))
                }
                
            default:
                break
            }
            return .none
        }
        .forEachRoute(\.routes, action: \.router)
    }
}
