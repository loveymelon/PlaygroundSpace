//
//  TabCoordinatorView.swift
//  PlaygroundSpace
//
//  Created by 김진수 on 8/5/24.
//

import SwiftUI
import ComposableArchitecture
import TCACoordinators

struct TabCoordinatorView: View {
    @Perception.Bindable var store: StoreOf<TabCoordinator>
    
    var body: some View {
        WithPerceptionTracking {
            
            switch store.state.viewState {
            case .loading:
                ProgressView()
                    .onAppear {
                        store.send(.onAppear)
                    }
            case .show:
                ZStack {
                    TabView(selection: $store.selectedTab.sending(\.tabSelected)) {
                        HomeCoordinatorView(
                            store: store.scope(
                                state: \.homeState,
                                action: \.homeAction
                            )
                        )
                        .tabItem { 
                            store.selectedTab == .home ? Image(ImageNames.homeSelect) : Image(ImageNames.home)
                            Text("홈")
                        }
                        .tag(TabCoordinator.Tab.home)
                        
                        DMCoordinatorView(
                            store: store.scope(
                                state: \.dmState,
                                action: \.dmAction
                            )
                        )
                        .tabItem { 
                            store.selectedTab == .dm ? Image(ImageNames.messageSelect) : Image(ImageNames.message)
                            Text("DM")
                        }
                        .tag(TabCoordinator.Tab.dm)
                    }
                    .tint(.brBlack)
                    
                    SideMenuView(isShowing: $store.isOpen.sending(\.sideMenuTrigger), direction: .leading) {
                        IfLetStore(store.scope(state: \.sideMenuState, action: \.sideMenuAction )) { store in
                            WorkSpaceSideView(store: store)
                        }
                        .frame(width: UIScreen.main.bounds.width * 0.8)
                    }
                    
                }
            case .empty:
                HomeEmptyView(store: store.scope(state: \.homeEmptyState, action: \.homeEmptyAction))
            }
            
        }
    }
}
