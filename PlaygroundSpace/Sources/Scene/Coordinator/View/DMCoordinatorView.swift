//
//  DMCoordinatorView.swift
//  PlaygroundSpace
//
//  Created by 김진수 on 8/5/24.
//

import SwiftUI
import ComposableArchitecture
import TCACoordinators

struct DMCoordinatorView: View {
    @Perception.Bindable var store: StoreOf<DMCoordinator>
    
    var body: some View {
        WithPerceptionTracking {
            
            TCARouter(store.scope(state: \.routes, action: \.router)) { screen in
                switch screen.case {
                case let .dmListView(store):
                    DMListView(store: store)
                case let .chatView(store):
                    ChatView(store: store)
                }
            }
            
        }
    }
}

extension DMScreen.State: Identifiable {
    var id: ID {
        switch self {
        case .dmListView:
            return ID.root
        case .chatView:
            return ID.dm
        }
    }
    
    enum ID: Identifiable {
        
        case root
        case dm
        
        var id: ID { self }
    }
}
