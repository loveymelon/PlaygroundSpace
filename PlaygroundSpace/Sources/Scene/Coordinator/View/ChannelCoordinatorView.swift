//
//  ChannelCoordinatorView.swift
//  PlaygroundSpace
//
//  Created by 김진수 on 8/11/24.
//

import SwiftUI
import ComposableArchitecture
import TCACoordinators

struct ChannelCoordinatorView: View {
    @Perception.Bindable var store: StoreOf<ChannelCoordinator>
    
    var body: some View {
        WithPerceptionTracking {
            
            TCARouter(store.scope(state: \.routes, action: \.router)) { screen in
                switch screen.case {
                case let .channelAllView(store):
                    AllChannelView(store: store)
                }
            }
            
        }
    }
}

extension ChannelScreen.State: Identifiable {
    var id: ID {
        switch self {
        case .channelAllView:
            return ID.root
        }
    }
    
    enum ID: Identifiable {
        
        case root
        
        var id: ID { self }
    }
}
