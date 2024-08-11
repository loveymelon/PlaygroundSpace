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
        var selectedUIImage: Data?
        var showImagePicker = false
        
        var requiredIsValid: Bool = false
    }
    
    enum Action: BindableAction {
        case binding(BindingAction<State>)
        
        case backButtonTapped
        case completeButtonTapped(Data)
        case workSpaceImageTapped
        case selectedFinish(Data)
        case workSpaceCreateNetwork(Data)
        
        case delegate(Delegate)
        enum Delegate {
            case backButtonTapped
            case workSpaceCreate
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
    
    let repository = WorkSpaceCreateRepository()
    
    var body: some ReducerOf<Self> {
        BindingReducer()
        
        Reduce { state, action in
            switch action {
            case .backButtonTapped:
                return .run { send in
                    await send(.delegate(.backButtonTapped))
                }
            case .binding:
                let requiredValid = (!state.workSpaceNameText.isEmpty && !state.workSpaceExplain.isEmpty)
                
                state.requiredIsValid = requiredValid
            case .workSpaceImageTapped:
                state.showImagePicker = true
            case let .selectedFinish(imageData):
                state.selectedUIImage = imageData
            case let .completeButtonTapped(imageData):
                
                return .run { [image = state.selectedUIImage] send in
                    await send(.workSpaceCreateNetwork(image ?? imageData))
                }
            case let .workSpaceCreateNetwork(image):
                return .run { [state = state] send in
                    let result = await repository.workSpaceCreateFinish(name: state.workSpaceNameText, description: state.workSpaceExplain, imageData: image)
                    
                    guard let success = result else { return }
                    
                    await send(.delegate(.workSpaceCreate))
                }
            default:
                break
            }
            return .none
        }
    }
}
