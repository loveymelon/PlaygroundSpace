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
//
//@Reducer(state: .equatable)
//enum Screen {
//    case onboarding(OnboardingFeature)
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
//        case router(IdentifiedRouterActionOf<Screen>)
//      }
//    
//    var body: some ReducerOf<Self> {
//        Reduce { state, action in
//            switch action {
////            case .router(.routeAction(id: _, action: .onboarding(.onSplash))):
////                <#code#>
////            }
//            default:
//                break
//            }
//            return .none
//        }
//    }
//}
