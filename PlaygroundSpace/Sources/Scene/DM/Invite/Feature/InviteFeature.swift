//
//  InviteFeature.swift
//  PlaygroundSpace
//
//  Created by 김진수 on 8/8/24.
//

import Foundation
import ComposableArchitecture

@Reducer
struct InviteFeature {
    @ObservableState
    struct State: Equatable {
        var emailText: String = ""
        var requiredIsValid: Bool = false
    }
    
    enum Action: BindableAction {
        case binding(BindingAction<State>)
        
        case viewTouchType(ViewTouchType)
        case delegate(Delegate)
        case network
        
        enum Delegate {
            case backButtonTapped
            case inviteComplete(MemberInfoEntity)
        }
    }
    
    enum ViewTouchType {
        case backButtonTapped
        case inviteButtonTapped
    }
    
    private let repository = InviteRepository()
    
    var body: some ReducerOf<Self> {
        BindingReducer()
        
        Reduce { state, action in
            switch action {
            case .binding:
                let requiredValid = !state.emailText.isEmpty
                
                state.requiredIsValid = requiredValid
                
            case .viewTouchType(.backButtonTapped):
                return .run { send in
                    await send(.delegate(.backButtonTapped))
                }
            case .viewTouchType(.inviteButtonTapped):
                return .run { send in
                    await send(.network)
                }
            case .network:
                return .run { [state = state] send in
                    let result = await repository.inviteUser(email: state.emailText)
                    
                    guard let memberEntity = result else { return }
                    
                    await send(.delegate(.inviteComplete(memberEntity)))
                }
                
            default:
                break
            }
            return .none
        }
    }
}
