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
        
        @Presents var workSpaceCreateState: WorkSpaceCreateFeature.State?
    }
    
    enum Action {
        case onAppear
        
        case sendToMakeWorkSpace
        case networking
        case networkSuccess([WorkspaceListEntity])
        
        case workSpaceCreateAction(PresentationAction<WorkSpaceCreateFeature.Action>)
        
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
    
    private let repository = CoordinatorRepository()
    
    var body: some ReducerOf<Self> {
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
                
            case .sendToMakeWorkSpace:
                state.workSpaceCreateState = WorkSpaceCreateFeature.State()
                
            case .workSpaceCreateAction(.presented(.delegate(.backButtonTapped))):
                return .run { send in
                    await send(.workSpaceCreateAction(.dismiss))
                }
                
            case .workSpaceCreateAction(.presented(.delegate(.workSpaceCreate))):
                return .run { send in
                    await send(.networking)
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
