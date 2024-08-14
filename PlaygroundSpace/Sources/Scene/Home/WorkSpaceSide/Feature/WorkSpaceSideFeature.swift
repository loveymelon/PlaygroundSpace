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
        var editIsOpen: Bool = false
        var isOwner: Bool = false
        var channelIsOwner: Bool = false
        var selectIndex: Int = 0
//        var workSpaceIsOwner: Bool = false
        
        @Presents var workSpaceCreateState: WorkSpaceCreateFeature.State?
        @Presents var workSpaceChangeOwnerState: ChannelOwnerFeature.State?
    }
    
    enum Action: BindableAction {
        case binding(BindingAction<State>)
        
        case onAppear
        case workSpaceEditButtonTapped(WorkspaceListEntity)
        case workSpaceEditType(WorkSpaceEditType)
        case dataTransType(DataTransType)
        
        case sendToMakeWorkSpace
        case networking
        case networkSuccess([WorkspaceListEntity])
        case networkCheckWorkSpaceInfo
        case networkWorkSpaceOut
        case checkWorkOwnerAndChannelOwner
        case networkWorkSpaceDelete
        
        case checkWorkSpace([WorkspaceListEntity])
        
        case workSpaceCreateAction(PresentationAction<WorkSpaceCreateFeature.Action>)
        case workSpaceChangeOwnerAction(PresentationAction<ChannelOwnerFeature.Action>)
        case workSpaceDelete
        
        case selectedModel(WorkspaceListEntity, Int)
        case delegate(Delegate)
        
        enum Delegate {
            case selectWorkSpace(WorkspaceListEntity)
            case workSpaceOutComplete([WorkspaceListEntity])
            case workSpaceDeleteComplete([WorkspaceListEntity])
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
    
    enum DataTransType {
//        case workSpaceIsOwner([String])
        case channelIsOwner([String])
        case deleteWorkSpace
    }
    
    private let repository = CoordinatorRepository()
    
    var body: some ReducerOf<Self> {
        BindingReducer()
        
        Reduce { state, action in
            switch action {
            case .onAppear:
               
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
                
            case let .selectedModel(data, index):
                state.isOwner = (data.ownerID == UserDefaultsManager.shared.userId)
                state.selectIndex = index
                
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
                
            case .workSpaceChangeOwnerAction(.presented(.delegate(.workSpaceOwnerChange(_)))):
                return .run { send in
                    await send(.networking)
                    await send(.workSpaceChangeOwnerAction(.dismiss))
                }
                
            case .workSpaceEditType(.workSpaceDelete):
                return .run { send in
                    await send(.networkWorkSpaceDelete)
                }
                
            case .workSpaceEditType(.workSpaceOut):
                return .run { send in
                    
                    await send(.networkCheckWorkSpaceInfo)
                }
                
            case .checkWorkOwnerAndChannelOwner:
                if state.channelIsOwner == false && state.isOwner == false {
                    return .run { send in
                        await send(.networkWorkSpaceOut)
                    }
                } else {
                    print("nonononoonononon")
                }
                
            case .networkWorkSpaceDelete:
                return .run { [state = state] send in
                    let result: Void? = await repository.deleteWorkSpace()
                    
                    guard let data = result else { return }
                    
                    await send(.dataTransType(.deleteWorkSpace))
                }
                
            case let .checkWorkSpace(workSpaceList):
                return .run { send in
                    if workSpaceList.isEmpty {
                        await send(.networkSuccess(workSpaceList))
                    } else {
                        print("network")
                        await send(.networking)
                    }
                    await send(.delegate(.workSpaceDeleteComplete(workSpaceList)))
                }
                
            case .networkCheckWorkSpaceInfo:
                return .run { send in
                    let result = await repository.fetchPointChannel()
                    
                    await send(.dataTransType(.channelIsOwner(result.filter { $0.name != "일반" }.map { $0.ownerId })))
                }
                
            case .networkWorkSpaceOut:
                return .run { send in
                    let result = await repository.workSpaceOut()
                    
                    if !result.isEmpty {
                        await send(.networking)
                    } else {
                        await send(.networkSuccess(result))
                    }
                    // 워크스페이스 나갔으니 상위에 나 나갔으니 첫번째 워크스페이스로 이동해서 model을 뿌려줘 만약 아무것도 없으면 사이드 메뉴 내리고 viewState를 empty로 변경해줘
                    await send(.delegate(.workSpaceOutComplete(result)))
                }
                
            case .dataTransType(.deleteWorkSpace):

                state.currentModels.remove(at: state.selectIndex)
                
                return .run { [state = state] send in
                    await send(.checkWorkSpace(state.currentModels))
                }
                
            case let .dataTransType(.channelIsOwner(ownerIds)):
                
                state.channelIsOwner = ownerIds.map { $0 == UserDefaultsManager.shared.userId }.contains(true)
                
                return .run { send in
                    await send(.checkWorkOwnerAndChannelOwner)
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
