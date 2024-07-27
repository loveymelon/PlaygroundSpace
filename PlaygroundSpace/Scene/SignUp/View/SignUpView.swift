//
//  SignUpView.swift
//  PlaygroundSpace
//
//  Created by 김진수 on 7/26/24.
//

import SwiftUI

struct SignUpView: View {
    @State var text: String = ""
    @State var numberText: String = ""
    
    var body: some View {
        ZStack(alignment: .bottom) {
            Color(.baPrimary)
            
            makeSignUpView()
            
            makeButton(text: InfoText.signUpEnter)
                .frame(height: 68)
                .padding(.horizontal, 25)
        }
    }
}

extension SignUpView {
    private func makeSignUpView() -> some View {
        VStack(spacing: 10) {
            ForEach(SignUp.allCases, id: \.self) { item in
                makeLabeledTextField(type: item, secure: item.secure)
            }
            
            Spacer()
        }
        .padding(.top, 30)
        .padding(.horizontal, 25)
    }
    
    private func makeLabeledTextField(type: SignUp, secure: Bool) -> some View {
        VStack {
            HStack {
                Text(type.rawValue)
                    .setTextStyle(type: .title2)
                    .foregroundStyle(.brBlack)
                
                Spacer()
            }
            
            checkDuplicateTextField(type: type, secure: secure)
        }
    }
    
    private func makeButton(text: String) -> some View {
        Button {
            print("tap")
        } label: {
            Text(text)
                .asText(type: .title2, foreColor: .brWhite, backColor: .brGreen)
        }
    }
    
    @ViewBuilder
    private func makeTextField(placeHolder: String, secure: Bool) -> some View {
        RoundedRectangle(cornerRadius: 10)
            .foregroundStyle(.baSecondary)
            .frame(height: 44)
            .overlay {
                Group {
                    if !secure {
                        TextField(placeHolder, text: $text)
                    } else {
                        SecureField(placeHolder, text: $text)
                    }
                }
                .foregroundStyle(.brBlack)
                .background(.baSecondary)
                .textFieldStyle(.plain)
                .padding(.horizontal, 10)
            }
    }
    
    @ViewBuilder
    private func checkDuplicateTextField(type: SignUp, secure: Bool) -> some View {
        
        if type != SignUp.email {
            makeTextField(placeHolder: type.placeHolder, secure: secure)
        } else {
            HStack(spacing: 10) {
                makeTextField(placeHolder: type.placeHolder, secure: secure)
                
                makeButton(text: InfoText.duplicate)
                    .frame(width: 100, height: 44)
            }
        }
        
    }
}
