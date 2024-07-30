//
//  CompleteFeature.swift
//  PlaygroundSpace
//
//  Created by 김진수 on 7/29/24.
//

import Foundation
import ComposableArchitecture

@Reducer
struct CompleteFeature {
    @ObservableState
    struct State: Equatable {
        var textState = ViewTextState()
    }
    
    enum Action {
        case onAppear
        case backButtonTapped
        
        case delegate(Delegate)
        enum Delegate {
            case backButtonTap
        }
    }
    
    struct ViewTextState: Equatable {
        var start = InfoText.start
        var title = InfoText.already
        var detail = InfoText.startDetail
        var nickname: String = ""
        var backImgae = ImageNames.backButton
    }
    
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .onAppear:
                state.textState.nickname = UserDefaultsManager.shared.userNickname
            case .backButtonTapped:
                return .run { send in
                    await send(.delegate(.backButtonTap))
                }
            default:
                break
            }
            return .none
        }
    }
}
