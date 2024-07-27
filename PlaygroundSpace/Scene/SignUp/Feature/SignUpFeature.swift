//
//  SignUpFeature.swift
//  PlaygroundSpace
//
//  Created by 김진수 on 7/27/24.
//

import Foundation
import ComposableArchitecture

@Reducer
struct SignUpFeature {
    @ObservableState
    struct State: Equatable {
        
    }
    
    enum Action {
        case backButtonTapped
        
        case delegate(Delegate)
        enum Delegate {
            case signUpAction
        }
    }
    
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .backButtonTapped:
                return .run { send in
                    await send(.delegate(.signUpAction))
                }
            default:
                break
            }
            return .none
        }
    }
}
