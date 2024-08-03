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
    case homeInitView(HomeInitFeature)
}

@Reducer
struct RootCoordinator {
    @ObservableState
      struct State: Equatable {
          
          static let inital = Self(routes: [.root(.homeInitView(HomeInitFeature.State()), embedInNavigationView: true)])
                                   
          var routes: IdentifiedArrayOf<Route<RootScreen.State>>
          var viewState: ViewState = .loading
          var homeEmptyState = HomeEmptyFeature.State()
      }
    
    enum Action {
        case router(IdentifiedRouterActionOf<RootScreen>)
        
        case onAppear
        
        case fetchWorkspaceList
        
        case homeEmptyAction(HomeEmptyFeature.Action)
        case workspaceResultScene([WorkspaceListEntity])
      }
    
    enum ViewState {
        case loading
        case show
        case empty
    }
    
    let repository = CoordinatorRepository()
    
    var body: some ReducerOf<Self> {
        
        Scope(state: \.homeEmptyState, action: \.homeEmptyAction) {
            HomeEmptyFeature()
        }
        
        Reduce { state, action in
            switch action {
            case .onAppear:
                return .run { send in
                    await send(.fetchWorkspaceList)
                }
            case .fetchWorkspaceList:
                return .run { send in
                    let workspaceList = await repository.fetchWorkspaceList()
                    await send(.workspaceResultScene(workspaceList)) // 이렇게 하면 값만 전달하게 되는 것이다. 그래서 액션으로 값이 변경이 가능하다 하지만 사이드 이펙트에서는 변경이 불가능하다 (다른 쓰레드이므로)
                    
                    // state가 immutable하기 때문에 안된다
                    // inout으로 주소값을 가져와서 그 값이 있다라는 것을 인증하는 건데
                    // 이 함수는 비동기 함수이므로 비동기 함수 내부에서 언제 값이 변화가 될지 모르기때문에 여기안에서 수정이 불가능하다.
                    // 순수 함수에 대한 규칙이 깨짐 / 외부에서 State 접근하지 못하도록 하는게 순수함수
//                    state.viewState = workspaceList.isEmpty ? .empty : .show
                }
            case let .workspaceResultScene(entity):
                state.viewState = entity.isEmpty ? .empty : .show
                return .send(.router(.routeAction(id: .root, action: .homeInitView(.catchData(entity)))))
            case .homeEmptyAction(.delegate(.createSuccess)):
                return .run { send in
                    await send(.fetchWorkspaceList)
                }
            default:
                break
            }
            return .none
        }
        .forEachRoute(\.routes, action: \.router)
    }
        
}

