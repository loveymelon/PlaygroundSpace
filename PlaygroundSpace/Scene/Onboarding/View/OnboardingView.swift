//
//  OnboardingView.swift
//  PlaygroundSpace
//
//  Created by 김진수 on 7/24/24.
//

import SwiftUI
import ComposableArchitecture

struct OnboardingView: View {
    
    @Perception.Bindable var store: StoreOf<OnboardingFeature>
    
    var body: some View {
        VStack {
            
            
            SplashView()
            
            Button {
                
            } label: {
                Text(InfoText.start)
                    .asText(type: .title2, foreColor: .brWhite, backColor: .brGreen)
                    
            }
            .padding(.horizontal, 20)
            .padding(.bottom, 30)
            
        }
        .onAppear {
            store.send(.onAppear)
        }
    }
}
