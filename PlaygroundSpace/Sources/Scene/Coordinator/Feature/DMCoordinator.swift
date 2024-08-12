//
//  DMCoordinator.swift
//  PlaygroundSpace
//
//  Created by 김진수 on 8/5/24.
//

import Foundation
import ComposableArchitecture
import TCACoordinators

@Reducer(state: .equatable)
enum DMScreen {
    case dmListView(DMListFeature)
    case chatView(ChatFeature)
}

@Reducer
struct DMCoordinator {
    
    @ObservableState
    struct State: Equatable {
        static let inital = Self(routes: [.root(.dmListView(DMListFeature.State()), embedInNavigationView: true)])
        
        var routes: IdentifiedArrayOf<Route<DMScreen.State>>
        var isEmpty: Bool = true
    }
    
    enum Action {
        case router(IdentifiedRouterActionOf<DMScreen>)
        
        case workspaceResultScene(WorkspaceListEntity)
        case sideMenuTrigger(Bool)
    }
    
    // TabCoordinator에서 워크스페이스 리스트 통신후 HomeCoordinator에 값을 전달만 해주면 repository가 필요없지 않나?
    var body: some ReducerOf<Self> {
        
        Reduce { state, action in
            switch action {
            case let .workspaceResultScene(entity):
                return .run { send in
                    await send(.router(.routeAction(id: .root, action: .dmListView(.catchWorkSpaceData(entity)))))
                }
            case let .router(.routeAction(id: .root, action: .dmListView(.delegate(.memberTapped(entity))))):
                state.routes.push(.chatView(.init(chatRoomData: entity, beforeView: .dmList)))
            default:
                break
            }
            return .none
        }
        .forEachRoute(\.routes, action: \.router)
    }
}
