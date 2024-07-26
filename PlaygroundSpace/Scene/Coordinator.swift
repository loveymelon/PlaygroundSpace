//
//  Coordinator.swift
//  PlaygroundSpace
//
//  Created by 김진수 on 7/24/24.
//

import Foundation
import ComposableArchitecture
import FlowStacks
import TCACoordinators

//@Reducer(state: .equatable)
//enum Screen {
//    case splash(SplashView)
//    case onboarding(OnboardingView)
//}
//
//@Reducer
//struct Coordinator {
//    @ObservableState
//      struct State: Equatable {
//          var routes: [Route<Screen.State>]
//      }
//    
//    enum Action {
//        case router(IndexedRouterActionOf<Screen>)
//      }
//    
//    var body: some ReducerOf<Self> {
//        Reduce<State, Action> { state, action in
//            switch action {
//                //            case .router(.routeAction(id: _, action: .)):
//                //                <#code#>
//                //            }
//            default:
//                break
//            }
//            return .none
//        }
//    }
//}
