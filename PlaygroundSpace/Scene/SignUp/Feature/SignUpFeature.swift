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
        
        var completeViewState: CompleteFeature.State?
    }
    
    enum Action: BindableAction {
        case binding(BindingAction<State>)
        
        case backButtonTapped
        case duplicateButtonTapped
        case signUpButtonTapped
        case phoneRegex
        case showCompleteView
        
        case completeViewAction(CompleteFeature.Action)
        
        case networking(NetworkType)
        
        case delegate(Delegate)
        enum Delegate {
            case signUpAction
            case signUpFinish
        }
    }
    
    enum NetworkType {
        case duplicate
        case signUpEnter
    }
    
    let repository = SignUpRepository()
    
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
                
                return .run { send in
                    await send(.phoneRegex)
                }
            case .phoneRegex:
                state.phoneText = state.phoneText.formatPhoneNumber
            case .duplicateButtonTapped:
                return .run { send in
                    await send(.networking(.duplicate))
                }
            case .signUpButtonTapped:
                return .run { send in
                    await send(.networking(.signUpEnter))
                    await send(.delegate(.signUpFinish))
                }
            case .showCompleteView:
                state.completeViewState = CompleteFeature.State()
                
            case .networking(.duplicate):
                return .run { [emailText = state.emailText] send in
                    repository.duplicatedEmail(email: emailText)
                }
            case .networking(.signUpEnter):
                return .run { [emailText = state.emailText, nickname = state.nicknameText, number = state.phoneText, password = state.passwordText] send in
                    repository.signUpEnter(email: emailText, nick: nickname, number: number, password: password)
                }
                // networking Type을 받자
//            case .networking(.one):
//                
//            case .networking(.two):
//                
//            case .networking(.three):
//
            default:
                break
            }
            return .none
        }
        .ifLet(\.completeViewState, action: \.completeViewAction) {
            CompleteFeature()
        }
    }
}
