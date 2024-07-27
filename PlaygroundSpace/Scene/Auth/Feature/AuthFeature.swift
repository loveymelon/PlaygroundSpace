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
        
        case delegate(Delegate)
        enum Delegate {
            case authViewAction
        }
    }
    
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .signUpButtonTapped:
                return .run { send in
                    await send(.delegate(.authViewAction))
                }
            default:
                break
            }
            return .none
        }
    }
}
