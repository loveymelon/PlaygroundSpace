//
//  WorkSpaceCreateFeature.swift
//  PlaygroundSpace
//
//  Created by 김진수 on 7/31/24.
//

import Foundation
import ComposableArchitecture

@Reducer
struct WorkSpaceCreateFeature {
    @ObservableState
    struct State: Equatable {
        var workSpaceNameText = ""
        var workSpaceExplain = ""
        let workSpaceType = ViewStateText()
        let workSpaceImage = ViewStateImage()
        
        var requiredIsValid: Bool = false
    }
    
    enum Action: BindableAction {
        case binding(BindingAction<State>)
        
        case backButtonTapped
        case completeButtonTapped
        
        case delegate(Delegate)
        enum Delegate {
            case backButtonTapped
        }
    }
    
    struct ViewStateText: Equatable {
        let workSpaceType = InfoText.WorkSpaceCreateType.allCases
        let workSpaceCreate = InfoText.HomeEmptyTextType.create
    }
    
    struct ViewStateImage: Equatable {
        let backButton = ImageNames.backButton
        let workSpaceImage = ImageNames.workSpaceDefaultImage
        let camerImage = ImageNames.camera
    }
    
    var body: some ReducerOf<Self> {
        BindingReducer()
        
        Reduce { state, action in
            switch action {
            case .backButtonTapped:
                return .run { send in
                    await send(.delegate(.backButtonTapped))
                }
            case .completeButtonTapped:
                print("tap")
            case .binding:
                let requiredValid = (!state.workSpaceNameText.isEmpty && !state.workSpaceExplain.isEmpty)
                
                state.requiredIsValid = requiredValid
            default:
                break
            }
            return .none
        }
    }
}
