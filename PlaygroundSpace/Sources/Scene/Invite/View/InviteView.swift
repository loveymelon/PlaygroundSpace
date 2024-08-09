//
//  InviteView.swift
//  PlaygroundSpace
//
//  Created by 김진수 on 8/8/24.
//

import SwiftUI
import ComposableArchitecture

struct InviteView: View {
    @Perception.Bindable var store: StoreOf<InviteFeature>
    
    var body: some View {
        WithPerceptionTracking {
            NavigationStack {
                ZStack(alignment: .bottom) {
                    Color(.baPrimary)
                    
                    makeLabeledTextField()
                        .navigationTitle("팀원 초대")
                        .navigationBarTitleDisplayMode(.inline)
                        .toolbar {
                            ToolbarItem(placement: .topBarLeading) {
                                makeCancleButton()
                            }
                        }
                    
                    makeButton()
                }
            }
        }
        
    }
}

extension InviteView {
    private func makeLabeledTextField() -> some View {
        VStack {
            HStack {
                Text("이메일")
                    .setTextStyle(type: .title2)
                    .foregroundStyle(.brBlack)
                
                Spacer()
            }
            
            makeTextField()
            Spacer()
                
        }
        .padding(.horizontal, 20)
        .padding(.top, 30)
    }
    
    private func makeTextField() -> some View {
        RoundedRectangle(cornerRadius: 10)
            .foregroundStyle(.baSecondary)
            .frame(height: 44)
            .overlay {
                TextField("초대하려는 팀원의 이메일을 입력하세요.", text: $store.emailText)
                    .foregroundStyle(.brBlack)
                    .background(.baSecondary)
                    .textFieldStyle(.plain)
                    .padding(.horizontal, 20)
            }
    }
    
    private func makeCancleButton() -> some View {
        Button {
            store.send(.viewTouchType(.backButtonTapped))
        } label: {
            Image(ImageNames.backButton)
        }
    }
    
    private func makeButton() -> some View {
        Button {
            store.send(.viewTouchType(.inviteButtonTapped))
        } label: {
            Text("초대 보내기")
                .asText(type: .title2, foreColor: .brWhite, backColor: store.requiredIsValid ? .brGreen: .brInactive)
        }
        .disabled(!store.requiredIsValid)
        .frame(height: 68)
        .padding(.horizontal, 25)
    }
}
//
//#Preview {
//    InviteView()
//}
