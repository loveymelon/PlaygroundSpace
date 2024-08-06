//
//  DMListFeature.swift
//  PlaygroundSpace
//
//  Created by 김진수 on 8/5/24.
//

import Foundation
import ComposableArchitecture

@Reducer
struct DMListFeature {
    @ObservableState
    struct State: Equatable {
        var workSpaceData: WorkspaceListEntity?
        var isEmpty: Bool = true
    }
    
    enum Action {
        case catchWorkSpaceData(WorkspaceListEntity)
        case checkWorkSpace
    }
    
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case let .catchWorkSpaceData(entity):
                state.workSpaceData = entity
                
            default:
                break
            }
            return .none
        }
    }
}
