//
//  EmailLoginFeature.swift
//  PlaygroundSpace
//
//  Created by 김진수 on 7/30/24.
//

import Foundation
import ComposableArchitecture

@Reducer
struct EmailLoginFeature {
    @ObservableState
    struct State: Equatable {
        var viewState = ViewState()
        var emailText: String = ""
        var passwordText: String = ""
        
        var requiredIsValid: Bool = false
    }
    
    enum Action: BindableAction {
        case binding(BindingAction<State>)
        
        case loginButtonTapped
        case backButtonTapped
        
        case showCompleteView
        
        case userDefaultSetting(TokenEntity, String)
        
        case delegate(Delegate)
        enum Delegate{
            case showCompleteView
            case emailLoginBackAction
        }
    }
    
    struct ViewState: Equatable {
        let emailLogin = InfoText.EmailLoginType.allCases
        let loginButton = InfoText.login
        let title = InfoText.login
        let backImgae = ImageNames.backButton
    }
    
    let repository = EmailLoginRepository()
    
    var body: some ReducerOf<Self> {
        BindingReducer()
        
        Reduce { state, action in
            switch action {
            case .binding:
                let requiredValid = (!state.emailText.isEmpty && !state.passwordText.isEmpty)
                
                state.requiredIsValid = requiredValid
                
            case .loginButtonTapped:
                return .run { [email = state.emailText, password = state.passwordText] send in
                    guard let entity = await repository.login(email: email, password: password) else { return }
                    
                    await send(.userDefaultSetting(entity.token, entity.nickname))
                }
                
            case .userDefaultSetting(let token, let nickname):
                UserDefaultsManager.shared.accessToken = token.accessToken
                UserDefaultsManager.shared.refreshToken = token.refreshToken
                UserDefaultsManager.shared.userNickname = nickname
                
                return .send(.showCompleteView)
                
            case .showCompleteView:
                return .run { send in
                    await send(.delegate(.showCompleteView))
                }
                
            case .backButtonTapped:
                return .run { send in
                    await send(.delegate(.emailLoginBackAction))
                }
            default:
                break
            }
            return .none
        }
    }
}
