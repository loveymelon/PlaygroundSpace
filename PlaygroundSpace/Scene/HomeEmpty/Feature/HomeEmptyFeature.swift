//
//  HomeEmptyFeature.swift
//  PlaygroundSpace
//
//  Created by 김진수 on 7/30/24.
//

import Foundation
import ComposableArchitecture

@Reducer
struct HomeEmptyFeature {
    @ObservableState
    struct State: Equatable {
        var viewTextState = ViewTextState()
        @Presents var workSpaceCreateState: WorkSpaceCreateFeature.State?
    }
    
    enum Action {
        case workSpaceCreateButtonTapped
        case showWorkSpaceCreate
        case workSpaceCreateAction(PresentationAction<WorkSpaceCreateFeature.Action>)
    }
    
    struct ViewTextState: Equatable {
        var title = InfoText.HomeEmptyTextType.title
        var mainText = InfoText.HomeEmptyTextType.mainText
        var detailText = InfoText.HomeEmptyTextType.detailText
        var createText = InfoText.HomeEmptyTextType.create
    }
    
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .workSpaceCreateButtonTapped:
                return .run { send in
                    await send(.showWorkSpaceCreate)
                }
            case .showWorkSpaceCreate:
                state.workSpaceCreateState = WorkSpaceCreateFeature.State()
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
