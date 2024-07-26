//
//  OnboardingFeature.swift
//  PlaygroundSpace
//
//  Created by 김진수 on 7/24/24.
//

import Foundation
import ComposableArchitecture

@Reducer
struct OnboardingFeature {
    @ObservableState
    struct State: Equatable {
        var isLaunching = false
    }
    
    enum Action {
        case onAppear
    }
    
    var body: some Reducer<State, Action> {
        Reduce { state, action in
            switch action {
            case .onAppear:
                break
            }
            
            return .none
        }
    }
}
