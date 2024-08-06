//
//  DMListView.swift
//  PlaygroundSpace
//
//  Created by 김진수 on 8/5/24.
//

import SwiftUI
import ComposableArchitecture

struct DMListView: View {
    @Perception.Bindable var store: StoreOf<DMListFeature>
    
    var body: some View {
        WithPerceptionTracking {
            Text("Hello, World!")
                .toolbar {
                    ToolbarItem(placement: .topBarLeading) {
                        Text("Direct Message")
                    }
                }
        }
    }
}
