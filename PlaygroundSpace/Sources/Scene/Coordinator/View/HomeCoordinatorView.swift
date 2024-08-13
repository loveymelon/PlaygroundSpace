//
//  HomeCoordinatorView.swift
//  PlaygroundSpace
//
//  Created by 김진수 on 8/5/24.
//

import SwiftUI
import ComposableArchitecture
import TCACoordinators

struct HomeCoordinatorView: View {
    @Perception.Bindable var store: StoreOf<HomeCoordinator>
    
    var body: some View {
        WithPerceptionTracking {
            
            TCARouter(store.scope(state: \.routes, action: \.router)) { screen in
                switch screen.case {
                case let .homeInitView(store):
                    HomeInitView(store: store)
                case let .channelCoordinatorView(store):
                    ChannelCoordinatorView(store: store)
                case let .chatView(store):
                    ChatView(store: store)
                case let .channelSettingView(store):
                    ChannelSettingView(store: store)
                }
            }
            
        }
    }
}

extension HomeScreen.State: Identifiable {
    var id: ID {
        switch self {
        case .homeInitView:
            return ID.root
        case .channelCoordinatorView:
            return ID.channel
        case .chatView:
            return ID.chat
        case .channelSettingView:
            return ID.channelSetting
        }
    }
    
    enum ID: Identifiable {
        
        case root
        case channel
        case chat
        case channelSetting
        
        var id: ID { self }
    }
}
