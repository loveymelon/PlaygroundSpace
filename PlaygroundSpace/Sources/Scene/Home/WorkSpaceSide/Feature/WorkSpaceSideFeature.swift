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
        var isOwner: Bool = false
        
        @Presents var workSpaceCreateState: WorkSpaceCreateFeature.State?
        @Presents var workSpaceChangeOwnerState: ChannelOwnerFeature.State?
    }
    
    enum Action: BindableAction {
        case binding(BindingAction<State>)
        
        case onAppear
        case workSpaceEditButtonTapped(WorkspaceListEntity)
        case workSpaceEditType(WorkSpaceEditType)
        
        case sendToMakeWorkSpace
        case networking
        case networkSuccess([WorkspaceListEntity])
        
        case workSpaceCreateAction(PresentationAction<WorkSpaceCreateFeature.Action>)
        case workSpaceChangeOwnerAction(PresentationAction<ChannelOwnerFeature.Action>)
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
                
//                for data in datas {
//                    if data.ownerID == UserDefaultsManager.shared.userId {
//                        state.isOwner = true
//                        break
//                    }
//                }
                
            case let .selectedModel(data):
                state.isOwner = (data.ownerID == UserDefaultsManager.shared.userId)
                
                return .run { send in
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
                
            case let .workSpaceEditButtonTapped(model):
                state.editIsOpen = true
                UserDefaultsManager.shared.currentWorkSpaceId = model.workspaceID
                state.isOwner = (model.ownerID == UserDefaultsManager.shared.userId)
                
            case .workSpaceEditType(.workSpaceEdit):
                state.workSpaceCreateState = WorkSpaceCreateFeature.State(beforeViewType: .sideMenu)
                
            case .workSpaceEditType(.workSpaceChangeOwner):
                state.workSpaceChangeOwnerState = ChannelOwnerFeature.State(channelId: "", beforeViewType: .sideMenu)
                
            case let .workSpaceChangeOwnerAction(.presented(.delegate(.workSpaceOwnerChange(ownerId)))):
                return .run { send in
                    await send(.networking)
                    await send(.workSpaceChangeOwnerAction(.dismiss))
                }
                
            default:
                break
            }
            return .none
        }
        .ifLet(\.$workSpaceCreateState, action: \.workSpaceCreateAction) {
            WorkSpaceCreateFeature()
        }
        .ifLet(\.$workSpaceChangeOwnerState, action: \.workSpaceChangeOwnerAction) {
            ChannelOwnerFeature()
        }
    }
}
