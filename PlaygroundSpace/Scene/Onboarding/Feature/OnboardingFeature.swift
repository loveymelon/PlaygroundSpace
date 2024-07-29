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
        
        // @Presents?
        @Presents var authViewState: AuthFeature.State?
        @Presents var signUpViewState: SignUpFeature.State?
        var completeViewState: CompleteFeature.State?
    }
    
    enum Action {
        case onAppear
        
        // 사이드 이펙트
        case onSplash
        case onView(ViewState)
        
        case startButtonTapped
        case showSignUpView
        case changeViewComplete
        
        case authViewAction(PresentationAction<AuthFeature.Action>)
        case signUpViewAction(PresentationAction<SignUpFeature.Action>)
        case completeViewAction(CompleteFeature.Action)
    }
    
    // 사이드 이펙트
    enum ViewState {
        case loading
        case on
        case login
        case logout
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
                    await send(.onView(.on))
                }
                .debounce(id: cancelID.splash, for: 1, scheduler: RunLoop.main, options: .none) // 타이머
                
            case .onView(let viewState):
                state.currentViewState = viewState
            case .startButtonTapped:
                state.authViewState = AuthFeature.State()
              
//            case .authViewAction(.dismiss):
                // 이벤트가 하나다(dismiss)만 감지
                // 그래서 어떤 버튼을 눌러서 돌아왔는지 알 수가 없다
                // 물론 아무런 동작을 하지 않는 뷰라면 해도된다. 왜냐하면 유저가 그냥 내렸을때도 감지하기 때문이다.
//                print("asd")
            case .authViewAction(.presented(.delegate(.authViewAction))):
                return .run { send in
                    await send(.authViewAction(.dismiss))
                    await send(.showSignUpView)
                }
            case .showSignUpView:
                state.signUpViewState = SignUpFeature.State()
                
            case .signUpViewAction(.presented(.delegate(.signUpAction))):
                return .run { send in
                    await send(.signUpViewAction(.dismiss))
                }
            case .signUpViewAction(.presented(.delegate(.signUpFinish))):
                return .run { send in
                    await send(.signUpViewAction(.dismiss))
                    await send(.changeViewComplete)
                    await send(.onView(.login))
                }
            case .changeViewComplete:
                state.completeViewState = CompleteFeature.State()
            default:
                break
                
            }
            
            return .none
        }
        .ifLet(\.$authViewState, action: \.authViewAction) {
            AuthFeature()
        }
        .ifLet(\.$signUpViewState, action: \.signUpViewAction) {
            SignUpFeature()
        }
        .ifLet(\.completeViewState, action: \.completeViewAction) {
            CompleteFeature()
        }
    }
}
