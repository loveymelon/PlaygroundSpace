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
                case .homeInitView(let store):
                    HomeInitView(store: store)
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
        }
    }
    
    enum ID: Identifiable {
        
        case root
        
        var id: ID { self }
    }
}
