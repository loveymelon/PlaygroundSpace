//
//  OnboardingFeature.swift
//  PlaygroundSpace
//
//  Created by 김진수 on 7/24/24.
//

import Foundation
import ComposableArchitecture

@Reducer
struct OnboardingFeature {
    @ObservableState
    struct State: Equatable {
        var isLaunching = false
        var currentViewState: ViewState = .loading
        var nextPage = false
        
        @Presents var authViewState: AuthFeature.State?
    }
    
    enum Action {
        case onAppear
        
        // 사이드 이펙트
        case onSplash
        case onView
        
        case startButtonTapped
        
        case authViewAction(PresentationAction<AuthFeature.Action>)
    }
    
    // 사이드 이펙트
    enum ViewState {
        case loading
        case on
    }
    
    // 이거의 용도눈??
    // 액션을 정확하게 끊기 위해서 아이디 등록 후 나중에 정리할때 한 번에 한다.
    enum cancelID: Hashable {
        case splash
    }
    
    var body: some Reducer<State, Action> {
        Reduce { state, action in
            switch action {
            case .onAppear:
                
//                return .send(<#T##action: Action##Action#>) // 동기적으로 처리
                return .run { send in // 비동기적으로 처리
                    await send(.onSplash)
                }
                
            case .onSplash:
                
                return .run { send in
                    await send(.onView)
                }
                .debounce(id: cancelID.splash, for: 1, scheduler: RunLoop.main, options: .none) // 타이머
                
            case .onView:
                state.currentViewState = .on
            case .startButtonTapped:
                state.authViewState = AuthFeature.State()
            default:
                break
                
            }
            
            return .none
        }
        .ifLet(\.$authViewState, action: \.authViewAction) {
            AuthFeature()
        }
    }
}
