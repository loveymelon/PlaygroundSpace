//
//  WorkSpaceSideFeature.swift
//  PlaygroundSpace
//
//  Created by 김진수 on 8/5/24.
//

import Foundation
import ComposableArchitecture

@Reducer
struct WorkSpaceSideFeature {
    @ObservableState
    struct State: Equatable {
        var currentCase: CurrentViewCase = .loading
        var currentModels: [WorkspaceListEntity] = []
        var currentWorkSpaceID: String = ""
        var editIsOpen: Bool = false
        
        @Presents var workSpaceCreateState: WorkSpaceCreateFeature.State?
    }
    
    enum Action: BindableAction {
        case binding(BindingAction<State>)
        
        case onAppear
        case workSpaceEditButtonTapped
        case workSpaceEditType(WorkSpaceEditType)
        
        case sendToMakeWorkSpace
        case networking
        case networkSuccess([WorkspaceListEntity])
        
        case workSpaceCreateAction(PresentationAction<WorkSpaceCreateFeature.Action>)
        case workSpaceDelete
        
        case selectedModel(WorkspaceListEntity)
        case delegate(Delegate)
        
        enum Delegate {
            case selectWorkSpace(WorkspaceListEntity)
        }
    }
    
    enum CurrentViewCase {
        case loading
        case empty
        case over
    }
    
    enum WorkSpaceEditType {
        case workSpaceEdit
        case workSpaceOut
        case workSpaceChangeOwner
        case workSpaceDelete
    }
    
    private let repository = CoordinatorRepository()
    
    var body: some ReducerOf<Self> {
        BindingReducer()
        
        Reduce { state, action in
            switch action {
            case .onAppear:
                state.currentWorkSpaceID = UserDefaultsManager.shared.currentWorkSpaceId
                return .run { send in
                    await send(.networking)
                }

            case .networking:
                return .run { send in
                    let result = await repository.fetchWorkspaceList()
                    try await Task.sleep(for: .seconds(1))
                    await send(.networkSuccess(result))
                }
                
            case let .networkSuccess(datas):
                state.currentModels = datas
                state.currentCase = datas.isEmpty ? .empty : .over
                
            case let .selectedModel(data):
                return .run { send in
                    print("side", data)
                    await send(.delegate(.selectWorkSpace(data)))
                }
                
            case .workSpaceCreateAction(.presented(.delegate(.backButtonTapped))):
                return .run { send in
                    await send(.workSpaceCreateAction(.dismiss))
                }
                
            case .workSpaceCreateAction(.presented(.delegate(.workSpaceEdit))):
                return .run { send in
                    await send(.networking)
                    await send(.workSpaceCreateAction(.dismiss))
                }
                
            case .workSpaceEditButtonTapped:
                state.editIsOpen = true
                
            case .workSpaceEditType(.workSpaceEdit):
                state.workSpaceCreateState = WorkSpaceCreateFeature.State(beforeViewType: .sideMenu)
                
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
