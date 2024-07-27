//
//  SignUpView.swift
//  PlaygroundSpace
//
//  Created by 김진수 on 7/26/24.
//

import SwiftUI
import ComposableArchitecture

struct SignUpView: View {
    
    @Perception.Bindable var store: StoreOf<SignUpFeature>
    
    var body: some View {
        WithPerceptionTracking {
            makeTopBar()
            
            ZStack(alignment: .bottom) {
                Color(.baPrimary)
                
                makeSignUpView()
                
                makeButton(buttonType: .signUpEnter)
                    .frame(height: 68)
                    .padding(.horizontal, 25)
            }
        }
    }
}

extension SignUpView {
    private func makeSignUpView() -> some View {
        VStack(spacing: 10) {
            ForEach(SignUp.allCases, id: \.self) { item in
                makeLabeledTextField(type: item)
            }
            
            Spacer()
        }
        .padding(.top, 30)
        .padding(.horizontal, 25)
    }
    
    private func makeLabeledTextField(type: SignUp) -> some View {
        VStack {
            HStack {
                Text(type.rawValue)
                    .setTextStyle(type: .title2)
                    .foregroundStyle(.brBlack)
                
                Spacer()
            }
            
            checkDuplicateTextField(type: type)
        }
    }
    
    private func makeButton(buttonType: InfoText.SignUpButtonType) -> some View {
        
        switch buttonType {
        case .duplicate:
            Button {
                print("duplicate")
            } label: {
                Text(buttonType.rawValue)
                    .asText(type: .title2, foreColor: .brWhite, backColor: store.emailEdit ? .brGreen: .brInactive)
            }
            .disabled(!store.emailEdit)
        case .signUpEnter:
            Button {
                print("signUpEnter")
            } label: {
                Text(buttonType.rawValue)
                    .asText(type: .title2, foreColor: .brWhite, backColor: store.requiredIsValid ? .brGreen: .brInactive)
            }
            .disabled(!store.requiredIsValid)
        }
    }
    
    private func makeTopBar() -> some View {
        VStack {
            Color(.clear)
                .frame(height: 2)
            HStack {
                Button {
                    store.send(.backButtonTapped)
                } label: {
                    Image(ImageNames.backButton)
                }
                .padding(.leading, 8)
                
                Spacer()
                
                Text(InfoText.signUpTitle)
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
    
    @ViewBuilder
    private func makeTextField(type: SignUp) -> some View {
        RoundedRectangle(cornerRadius: 10)
            .foregroundStyle(.baSecondary)
            .frame(height: 44)
            .overlay {
                Group {
                    switch type {
                    case .email:
                        TextField(type.placeHolder, text: $store.emailText)
                    case .nickname:
                        TextField(type.placeHolder, text: $store.nicknameText)
                    case .phone:
                        TextField(type.placeHolder, text: $store.phoneText)
                    case .password:
                        SecureField(type.placeHolder, text: $store.passwordText)
                    case .checkPassword:
                        SecureField(type.placeHolder, text: $store.checkPasswordText)
                    }
                }
                .foregroundStyle(.brBlack)
                .background(.baSecondary)
                .textFieldStyle(.plain)
                .padding(.horizontal, 10)
            }
            
    }
    
    @ViewBuilder
    private func checkDuplicateTextField(type: SignUp) -> some View {
        
        if type != SignUp.email {
            makeTextField(type: type)
        } else {
            HStack(spacing: 10) {
                makeTextField(type: type)
                
                makeButton(buttonType: .duplicate)
                    .frame(width: 100, height: 44)
            }
        }
        
    }
}
