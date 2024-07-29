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
        WithPerceptionTracking { // store를 추적하기 위해서
            VStack {
                
                switch store.currentViewState {
                case .on:
                    SplashView()
                    makeButton()
                case .loading:
                    SplashView()
                case .login:
                    IfLetStore(store.scope(state: \.completeViewState, action: \.completeViewAction)) { store in
                        CompleteView(store: store)
                    }
                case .logout:
                    EmptyView()
                }
                
            }
            .sheet(item: $store.scope(state: \.authViewState, action: \.authViewAction)) { store in
                AuthView(store: store)
                    .presentationDetents([.height(250)])
                    .presentationDragIndicator(.visible)
            }
            .sheet(item: $store.scope(state: \.signUpViewState, action: \.signUpViewAction), content: { store in
                SignUpView(store: store)
                    .presentationDetents([.large])
                    .presentationDragIndicator(.visible)
            })
            .onAppear {
                store.send(.onAppear)
            }
        }
    }
}

extension OnboardingView {
    func makeButton() -> some View {
        Button {
            store.send(.startButtonTapped)
        } label: {
            Text(InfoText.start)
                .asText(type: .title2, foreColor: .brWhite, backColor: .brGreen)
        }
        .padding(.horizontal, 20)
        .padding(.bottom, 30)
    }
}
