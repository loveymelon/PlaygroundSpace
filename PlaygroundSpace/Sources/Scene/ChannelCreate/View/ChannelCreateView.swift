//
//  ChannelCreateView.swift
//  PlaygroundSpace
//
//  Created by 김진수 on 8/11/24.
//

import SwiftUI
import ComposableArchitecture

struct ChannelCreateView: View {
    @Perception.Bindable var store: StoreOf<ChannelCreateFeature>
    
    var body: some View {
        WithPerceptionTracking {
            NavigationStack {
                makeChannelCreateView()
                    .toolbar {
                        ToolbarItem(placement: .topBarLeading) {
                            makeCancleButton()
                        }
                    }
                    .navigationTitle("채널 생성")
                    .navigationBarTitleDisplayMode(.inline)
            }
        }
    }
}

extension ChannelCreateView {
    private func makeChannelCreateView() -> some View {
        ZStack(alignment: .bottom) {
            Color(.baPrimary)
            
            VStack {
                ForEach(store.state.channelTextType, id: \.self) { item in
                    makeLabeledTextField(type: item)
                        .padding(.bottom, 20)
                }
                
                Spacer()
            }
            .padding(.horizontal, 20)
            .padding(.top, 30)
            
            makeButton()
        }
    }
    
    private func makeCancleButton() -> some View {
        Button {
            store.send(.viewEventType(.backButtonTapped))
        } label: {
            Image(ImageNames.backButton)
        }
    }
    
    private func makeLabeledTextField(type: ChannelCreateFeature.ChannelType) -> some View {
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
    
    private func makeTextField(type: ChannelCreateFeature.ChannelType) -> some View {
        RoundedRectangle(cornerRadius: 10)
            .foregroundStyle(.baSecondary)
            .frame(height: 44)
            .overlay {
                Group {
                    switch type {
                    case .channelName:
                        TextField(type.placeholder, text: $store.state.viewTextState.channelNameText)
                    case .channelExplain:
                        TextField(type.placeholder, text: $store.state.viewTextState.channelExplainText)
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
            store.send(.viewEventType(.completeButtonTapped))
        } label: {
            Text("생성")
                .asText(type: .title2, foreColor: .brWhite, backColor: store.requiredIsValid ? .brGreen: .brInactive)
        }
        .disabled(!store.requiredIsValid)
        .padding(.horizontal, 20)
        .padding(.bottom, 10)
    }
}
