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
                    case .homeInitView(let store):
                        HomeInitView(store: store)
                    }
                }
            case .empty:
                HomeEmptyView(store: store.scope(state: \.homeEmptyState, action: \.homeEmptyAction))
            }
            
        }
    }
}

extension RootScreen.State: Identifiable {
    var id: ID {
        switch self {
        case .homeInitView:
            return ID.root
        }
    }
    
    enum ID: Identifiable {
        
        case root
        
        var id: ID { self }
    }
}
