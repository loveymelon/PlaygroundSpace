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
        @Presents var workSpaceCreateState: WorkSpaceCreateFeature.State?
    }
    
    enum Action {
        case onAppear
        case backButtonTapped
        case workSpaceCreateButtonTapped
        case showWorkSpaceCreate
        
        case workSpaceCreateAction(PresentationAction<WorkSpaceCreateFeature.Action>)
        
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
            case .showWorkSpaceCreate:
                state.workSpaceCreateState = WorkSpaceCreateFeature.State()
            case .workSpaceCreateButtonTapped:
                return .run { send in
                    await send(.showWorkSpaceCreate)
                }
            case .backButtonTapped:
                return .run { send in
                    await send(.delegate(.backButtonTap))
                }
            case .workSpaceCreateAction(.presented(.delegate(.backButtonTapped))):
                return .run { send in
                    await send(.workSpaceCreateAction(.dismiss))
                }
            default:
                break
            }
            return .none
        }
        .ifLet(\.$workSpaceCreateState, action: \.workSpaceCreateAction) {
            WorkSpaceCreateFeature()
        }
    }
}
