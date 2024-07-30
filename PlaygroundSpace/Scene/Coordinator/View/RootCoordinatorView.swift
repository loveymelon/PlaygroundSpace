//
//  RootCoordinatorView.swift
//  PlaygroundSpace
//
//  Created by 김진수 on 7/30/24.
//

import SwiftUI
import ComposableArchitecture
import TCACoordinators

struct RootCoordinatorView: View {
    
    @Perception.Bindable var store: StoreOf<RootCoordinator>
    
    var body: some View {
        WithPerceptionTracking {
            
            switch store.state.viewState {
            case .loading:
                ProgressView()
                    .onAppear {
                        store.send(.onAppear)
                    }
            case .show:
                TCARouter(store.scope(state: \.routes, action: \.router)) { screen in
                    switch screen.case {
                    case .completeView(let store):
                        CompleteView(store: store)
                    case .HomeEmptyView(let store):
                        HomeEmptyView(store: store)
                    }
                }
            }
            
        }
    }
}

extension RootScreen.State: Identifiable {
    var id: ID {
        switch self {
        case .completeView:
            return ID.root
        case .HomeEmptyView:
            return ID.homeEmpty
        }
    }
    
    enum ID: Identifiable {
        
        case root
        case homeEmpty
        
        var id: ID { self }
    }
}
