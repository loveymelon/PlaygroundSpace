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
        
    }
    
    enum Action {
        
    }
    
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            default:
                break
            }
            return .none
        }
    }
}
