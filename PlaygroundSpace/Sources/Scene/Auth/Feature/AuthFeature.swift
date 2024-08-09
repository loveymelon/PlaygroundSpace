//
//  AuthFeature.swift
//  PlaygroundSpace
//
//  Created by 김진수 on 7/27/24.
//

import Foundation
import ComposableArchitecture

// NotificationCenter

@Reducer
struct AuthFeature {
    @ObservableState
    struct State: Equatable {
        
    }
    
    enum Action {
        case signUpButtonTapped
        case emailLoginTapped
        case kakaoLoginTapped(String)
        case appleLoginTapped(String, String)
        
        case userDefaultSetting(TokenEntity, String, String)
        
        case network(Network)
        case delegate(Delegate)
        
        enum Delegate {
            case authViewAction
            case emailPresentAction
            case loginSuccess
        }
    }
    
    enum Network {
        case kakaoLogin(String)
        case appleLogin(String, String)
    }
    
    private let repository = AuthRepository()
    
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
            case let .kakaoLoginTapped(outhToken):
                return .run { send in
                    await send(.network(.kakaoLogin(outhToken)))
                }
            case let .appleLoginTapped(token, nickname):
                return .run { send in
                    await send(.network(.appleLogin(token, nickname)))
                }
                
            case let .network(.kakaoLogin(outhToken)):
                return .run { send in
                    let result = await repository.kakaoLogin(oauthToken: outhToken)
                    
                    guard let data = result else { return }
                    await send(.userDefaultSetting(data.token, data.nickname, data.userId))
                }
                
            case let .network(.appleLogin(token, nickname)):
                return .run { send in
                    let result = await repository.appleLogin(token: token, nickname: nickname)
                    
                    guard let data = result else { return }
                    
                    await send(.userDefaultSetting(data.token, data.nickname, data.userId))
                }
                
            case let .userDefaultSetting(token, nickname, userId):
                UserDefaultsManager.shared.accessToken = token.accessToken
                UserDefaultsManager.shared.refreshToken = token.refreshToken
                UserDefaultsManager.shared.userNickname = nickname
                UserDefaultsManager.shared.userId = userId
                
                return .send(.delegate(.loginSuccess))
            default:
                break
            }
            return .none
        }
    }
}
