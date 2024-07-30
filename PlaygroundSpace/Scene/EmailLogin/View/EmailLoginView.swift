//
//  EmailLoginView.swift
//  PlaygroundSpace
//
//  Created by 김진수 on 7/30/24.
//

import SwiftUI
import ComposableArchitecture

struct EmailLoginView: View {
    @Perception.Bindable var store: StoreOf<EmailLoginFeature>
    
    var body: some View {
        WithPerceptionTracking {
            makeTopBar()
            
            ZStack(alignment: .bottom) {
                Color(.baPrimary)
                
                makeSignUpView()
                makeButton()
                    .frame(height: 68)
                    .padding(.horizontal, 25)
            }
        }
    }
}

extension EmailLoginView {
    private func makeSignUpView() -> some View {
        VStack(spacing: 10) {
            ForEach(store.viewState.emailLogin, id: \.self) { item in
                makeLabeledTextField(type: item)
            }
            
            Spacer()
        }
        .padding(.top, 30)
        .padding(.horizontal, 25)
    }
    
    private func makeLabeledTextField(type: InfoText.EmailLoginType) -> some View {
        VStack {
            HStack {
                Text(type.rawValue)
                    .setTextStyle(type: .title2)
                    .foregroundStyle(.brBlack)
                
                Spacer()
            }
            
            makeTextField(type: type)
        }
    }
    
    private func makeTextField(type: InfoText.EmailLoginType) -> some View {
        RoundedRectangle(cornerRadius: 10)
            .foregroundStyle(.baSecondary)
            .frame(height: 44)
            .overlay {
                Group {
                    switch type {
                    case .email:
                        TextField(type.placeHolder, text: $store.emailText)
                    case .password:
                        SecureField(type.placeHolder, text: $store.passwordText)
                    }
                }
                .foregroundStyle(.brBlack)
                .background(.baSecondary)
                .textFieldStyle(.plain)
                .padding(.horizontal, 10)
            }
    }
    
    private func makeButton() -> some View {
        Button {
            store.send(.loginButtonTapped)
        } label: {
            Text(store.viewState.loginButton)
                .asText(type: .title2, foreColor: .brWhite, backColor: store.requiredIsValid ? .brGreen: .brInactive)
        }
        .disabled(!store.requiredIsValid)
        
    }
    
    private func makeTopBar() -> some View {
        VStack {
            Color(.clear)
                .frame(height: 2)
            HStack(alignment: .center) {
                Button {
                    store.send(.backButtonTapped)
                } label: {
                    Image(store.viewState.backImgae)
                }
                .padding(.leading, 8)
                
                Spacer()
                
                Text(store.viewState.title)
                    .setTextStyle(type: .title2)
                    .foregroundStyle(.brBlack)
                    .padding(.trailing, 28)
                
                Spacer()
                    
            }
        }
        .frame(height: 44)
        .frame(maxWidth: .infinity)
        .ignoresSafeArea()
    }
    
}
