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
        var emailText: String = ""
        var nicknameText: String = ""
        var phoneText: String = ""
        var passwordText: String = ""
        var checkPasswordText: String = ""
        
        var emailEdit: Bool = false
        var requiredIsValid: Bool = false
    }
    
    enum Action: BindableAction {
        case binding(BindingAction<State>)
        
        case backButtonTapped
        
        case delegate(Delegate)
        enum Delegate {
            case signUpAction
        }
    }
    
    var body: some ReducerOf<Self> {
        BindingReducer()
        
        Reduce { state, action in
            switch action {
            case .backButtonTapped:
                return .run { send in
                    await send(.delegate(.signUpAction))
                }
            
            case .binding:
                state.emailEdit = !state.emailText.isEmpty
            
                let requiredValid = (state.emailEdit && !state.nicknameText.isEmpty && !state.passwordText.isEmpty && !state.checkPasswordText.isEmpty)
                
                state.requiredIsValid = requiredValid
            default:
                break
            }
            return .none
        }
    }
}
