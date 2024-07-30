//
//  AuthFeature.swift
//  PlaygroundSpace
//
//  Created by 김진수 on 7/27/24.
//

import Foundation
import ComposableArchitecture

@Reducer
struct AuthFeature {
    @ObservableState
    struct State: Equatable {
        
    }
    
    enum Action {
        case signUpButtonTapped
        case emailLoginTapped
        
        case delegate(Delegate)
        enum Delegate {
            case authViewAction
            case emailPresentAction
        }
    }
    
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .signUpButtonTapped:
                return .run { send in
                    await send(.delegate(.authViewAction))
                }
            case .emailLoginTapped:
                return .run { send in
                    await send(.delegate(.emailPresentAction))
                }
            default:
                break
            }
            return .none
        }
    }
}
