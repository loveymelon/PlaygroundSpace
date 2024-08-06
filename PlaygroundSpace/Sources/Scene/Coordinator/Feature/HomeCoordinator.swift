//
//  HomeCoordinator.swift
//  PlaygroundSpace
//
//  Created by 김진수 on 8/5/24.
//

import TCACoordinators
import ComposableArchitecture

@Reducer(state: .equatable)
enum HomeScreen {
    case homeInitView(HomeInitFeature)
}

@Reducer
struct HomeCoordinator {
    
    @ObservableState
    struct State: Equatable {
        
        static let initial = Self(routes: [.root(.homeInitView(HomeInitFeature.State()), embedInNavigationView: true)])
        
        var routes: IdentifiedArrayOf<Route<HomeScreen.State>>
    }
    
    enum Action {
        case router(IdentifiedRouterActionOf<HomeScreen>)
        
//        case catchWorkSpaceData(WorkspaceListEntity)
        case workspaceResultScene(WorkspaceListEntity)
        case delegate(Delegate)
        enum Delegate {
            case sideMenuTrigger
        }
    }
    
    // TabCoordinator에서 워크스페이스 리스트 통신후 HomeCoordinator에 값을 전달만 해주면 repository가 필요없지 않나?
    var body: some ReducerOf<Self> {
        
        Reduce { state, action in
            switch action {
            case let .workspaceResultScene(entity):
                return .run { send in
                    await send(.router(.routeAction(id: .root, action: .homeInitView(.catchWorkSpaceData(entity)))))
                }
            case .router(.routeAction(id: _, action: .homeInitView(.delegate(.showSideMenu)))):
                return .send(.delegate(.sideMenuTrigger))
            default:
                break
            }
            return .none
        }
        .forEachRoute(\.routes, action: \.router)
    }
}
