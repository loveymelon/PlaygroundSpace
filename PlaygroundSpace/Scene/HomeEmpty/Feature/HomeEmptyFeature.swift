//
//  HomeEmptyFeature.swift
//  PlaygroundSpace
//
//  Created by 김진수 on 7/30/24.
//

import Foundation
import ComposableArchitecture

@Reducer
struct HomeEmptyFeature {
    @ObservableState
    struct State: Equatable {
        var viewTextState = ViewTextState()
    }
    
    enum Action {
        
    }
    
    struct ViewTextState: Equatable {
        var title = InfoText.HomeEmptyTextType.title
        var mainText = InfoText.HomeEmptyTextType.mainText
        var detailText = InfoText.HomeEmptyTextType.detailText
        var createText = InfoText.HomeEmptyTextType.create
    }
    
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
                
            }
            return .none
        }
    }
}
