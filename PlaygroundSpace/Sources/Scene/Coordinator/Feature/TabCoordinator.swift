//
//  TabCoordinator.swift
//  PlaygroundSpace
//
//  Created by 김진수 on 8/5/24.
//

// 이렇게 하면 값만 전달하게 되는 것이다. 그래서 액션으로 값이 변경이 가능하다 하지만 사이드 이펙트에서는 변경이 불가능하다 (다른 쓰레드이므로)

// state가 immutable하기 때문에 안된다
// inout으로 주소값을 가져와서 그 값이 있다라는 것을 인증하는 건데
// 이 함수는 비동기 함수이므로 비동기 함수 내부에서 언제 값이 변화가 될지 모르기때문에 여기안에서 수정이 불가능하다.
// 순수 함수에 대한 규칙이 깨짐 / 외부에서 State 접근하지 못하도록 하는게 순수함수
//                    state.viewState = workspaceList.isEmpty ? .empty : .show

import SwiftUI
import ComposableArchitecture
import TCACoordinators

@Reducer
struct TabCoordinator {
    enum Tab: Hashable {
        case home, dm
    }
    
    @ObservableState
    struct State: Equatable {
        static let initial = State(
            homeState: .initial,
            dmState: .inital,
            selectedTab: .home
        )
        
        var homeState: HomeCoordinator.State
        var dmState: DMCoordinator.State
        
        var homeEmptyState = HomeEmptyFeature.State()
        var viewState: ViewState = .loading
        
        var selectedTab: Tab
        var isOpen: Bool = false
        var selectWorkSpace: WorkspaceListEntity = WorkspaceListEntity()
        
        var sideMenuState: WorkSpaceSideFeature.State? = nil
    }
    
    enum ViewState {
        case loading
        case show
        case empty
    }
    
    enum Action {
        case homeAction(HomeCoordinator.Action)
        case dmAction(DMCoordinator.Action)
        case homeEmptyAction(HomeEmptyFeature.Action)
        case sideMenuAction(WorkSpaceSideFeature.Action)
        case workspaceResultScene([WorkspaceListEntity])
        case tabSelected(Tab)
        
        case coordiAction(CoordiAction)
        case onAppear
        case sideMenuTrigger(Bool)
        case fetchWorkSpaceList
        
        case reload
    }
    
    enum CoordiAction {
        case home(HomeAction)
        case dm(DMAction)
        
        enum HomeAction {
            case homeEmptyAction(HomeEmptyFeature.Action)
            case workspaceResultScene([WorkspaceListEntity])
        }
        enum DMAction {
            case workspaceResultScene(WorkspaceListEntity)
        }
    }
    
    let repository = CoordinatorRepository()
    
    var body: some ReducerOf<Self> {
        Scope(state: \.homeEmptyState, action: \.homeEmptyAction) {
            HomeEmptyFeature()
        } // reducer 추적
        
        Scope(state: \.homeState, action: \.homeAction) {
            HomeCoordinator()
        }
        
        Scope(state: \.dmState, action: \.dmAction) {
            DMCoordinator()
        }
        
        Reduce { state, action in
            switch action {
            case .onAppear:
                return .run { send in
                    await send(.fetchWorkSpaceList)
                }
                
            case .fetchWorkSpaceList:
                return .run { send in
                    let workspaceList = await repository.fetchWorkspaceList()
                    await send(.coordiAction(.home(.workspaceResultScene(workspaceList))))
                }
                
            case let .coordiAction(.home(.workspaceResultScene(entity))):
                guard let workSpace = entity.first else {
                    state.viewState = .empty
                    return .none
                }
                state.viewState = .show
                UserDefaultsManager.shared.currentWorkSpaceId = workSpace.workspaceID
                
                return .run { send in
                    await send(.homeAction(.workspaceResultScene(workSpace)))
                    await send(.dmAction(.workspaceResultScene(workSpace)))
                }
                
            case let .tabSelected(tab):
                state.selectedTab = tab
            case .homeAction(.delegate(.sideMenuTrigger)):
                return .run { send in
                    await send(.sideMenuTrigger(true))
                }
            case let .sideMenuTrigger(isValid):
                if isValid {
                    state.sideMenuState = WorkSpaceSideFeature.State()
                } else {
                    state.sideMenuState = nil
                    
//                    return .send(.reload)
                }
                state.isOpen = isValid
                
//            case .reload:
//                return .run { send in
//                    try await Task.sleep(for: .seconds(2))
//                    await send(.homeAction(.parentAction(.reloadHome)))
//                }
                
            case let .sideMenuAction(.delegate(.selectWorkSpace(entity))):
                state.selectWorkSpace = entity
                UserDefaultsManager.shared.currentWorkSpaceId = entity.workspaceID
                
                return .run { send in
                    await send(.homeAction(.workspaceResultScene(entity)))
                    await send(.dmAction(.workspaceResultScene(entity)))
                    await send(.sideMenuTrigger(false))
                }
                
            default:
                break
            }
            return .none
        }
        .ifLet(\.sideMenuState, action: \.sideMenuAction) {
            WorkSpaceSideFeature()
        }
    }
}
