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
        
        var beforeViewType: BeforeViewType
    }
    
    enum BeforeViewType {
        case emptyView
        case sideMenu
        
        var title: String {
            return switch self {
            case .emptyView:
                "워크스페이스 생성"
            case .sideMenu:
                "워크스페이스 편집"
            }
        }
        
        var button: String {
            return switch self {
            case .emptyView:
                "완료"
            case .sideMenu:
                "저장"
            }
        }
    }
    
    enum Action: BindableAction {
        case binding(BindingAction<State>)
        
        case backButtonTapped
        case completeButtonTapped(Data)
        case workSpaceImageTapped
        case selectedFinish([Data])
        case workSpaceCreateNetwork(Data)
        case workSpaceEditNetwork(Data)
        
        case delegate(Delegate)
        enum Delegate {
            case backButtonTapped
            case workSpaceCreate
            case workSpaceEdit
        }
    }
    
    struct ViewStateText: Equatable {
        let workSpaceType = InfoText.WorkSpaceCreateType.allCases
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
                state.selectedUIImage = imageData.first
            case let .completeButtonTapped(imageData):
                
                return .run { [image = state.selectedUIImage, state = state] send in
                    if state.beforeViewType == .emptyView {
                        await send(.workSpaceCreateNetwork(image ?? imageData))
                    } else {
                        await send(.workSpaceEditNetwork(image ?? imageData))
                    }
                }
                
            case let .workSpaceCreateNetwork(image):
                return .run { [state = state] send in
                    let result = await repository.workSpaceCreateFinish(name: state.workSpaceNameText, description: state.workSpaceExplain, imageData: image)
                    
                    guard let success = result else { return }
                    
                    await send(.delegate(.workSpaceCreate))
                }
                
            case let .workSpaceEditNetwork(image):
                return .run { [state = state] send in
                    let result = await repository.workSpaceEdit(name: state.workSpaceNameText, description: state.workSpaceExplain, imageData: image)
                    
                    guard let data = result else  { return }
                    
                    await send(.delegate(.workSpaceEdit))
                }
                
            default:
                break
            }
            return .none
        }
    }
}
