//
//  RootCoordinator.swift
//  PlaygroundSpace
//
//  Created by 김진수 on 7/27/24.
//

import Foundation
import ComposableArchitecture
import FlowStacks
import TCACoordinators

@Reducer(state: .equatable)
enum RootScreen {
    case completeView(CompleteFeature)
    case HomeEmptyView(HomeEmptyFeature)
}

@Reducer
struct RootCoordinator {
    @ObservableState
      struct State: Equatable {
          var routes: IdentifiedArrayOf<Route<RootScreen.State>>
          var viewState: ViewState = .loading
          
          static let inital = Self(routes: [.root(.completeView(CompleteFeature.State()), embedInNavigationView: true)]
          )
      }
    
    enum Action {
        case router(IdentifiedRouterActionOf<RootScreen>)
        
        case onAppear
      }
    
    enum ViewState {
        case loading
        case show
    }
    
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .router(.routeAction(id: _, action: .completeView(.delegate(.backButtonTap)))):
                print("tapbackback")
            case .onAppear:
                state.viewState = .show
            default:
                break
            }
            return .none
        }
        .forEachRoute(\.routes, action: \.router)
    }
}

