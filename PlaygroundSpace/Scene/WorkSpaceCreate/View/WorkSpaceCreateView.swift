//
//  WorkSpaceCreateView.swift
//  PlaygroundSpace
//
//  Created by 김진수 on 7/31/24.
//

import SwiftUI
import ComposableArchitecture

struct WorkSpaceCreateView: View {
    
    @Perception.Bindable var store: StoreOf<WorkSpaceCreateFeature>
    
    var body: some View {
        WithPerceptionTracking {
            NavigationStack {
                makeWorkSpaceCreateView()
                    .toolbar {
                        ToolbarItem(placement: .topBarLeading) {
                            makeCancleButton()
                        }
                    }
                    .navigationTitle(store.workSpaceType.workSpaceCreate)
                    .navigationBarTitleDisplayMode(.inline)
            }
        }
    }
}

extension WorkSpaceCreateView {
    private func makeWorkSpaceCreateView() -> some View {
        ZStack(alignment: .bottom) {
            Color(.baPrimary)
            
            VStack {
                makeWorkSpaceImage()
                
                ForEach(store.state.workSpaceType.workSpaceType, id: \.self) { item in
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
    
    private func makeWorkSpaceImage() -> some View {
        ZStack(alignment: .bottomTrailing) {
            Image(store.workSpaceImage.workSpaceImage)
                .resizable()
                .frame(width: 70, height: 70)
            
            Image(store.workSpaceImage.camerImage)
                .resizable()
                .frame(width: 24, height: 24)
                .offset(x: 8.0, y: 8.0)
        }
    }
    
    private func makeCancleButton() -> some View {
        Button {
            store.send(.backButtonTapped)
        } label: {
            Image(store.workSpaceImage.backButton)
        }
    }
    
    private func makeText() -> some View {
        Text(InfoText.HomeEmptyTextType.create)
    }
    
    private func makeLabeledTextField(type: InfoText.WorkSpaceCreateType) -> some View {
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
    
    private func makeTextField(type: InfoText.WorkSpaceCreateType) -> some View {
        RoundedRectangle(cornerRadius: 10)
            .foregroundStyle(.baSecondary)
            .frame(height: 44)
            .overlay {
                Group {
                    switch type {
                    case .workSpaceName:
                        TextField(type.placeHolder, text: $store.workSpaceNameText)
                    case .workSpaceExplain:
                        TextField(type.placeHolder, text: $store.workSpaceExplain)
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
            store.send(.completeButtonTapped)
        } label: {
            Text(store.workSpaceType.workSpaceCreate)
                .asText(type: .title2, foreColor: .brWhite, backColor: store.requiredIsValid ? .brGreen: .brInactive)
        }
        .disabled(!store.requiredIsValid)
        .padding(.horizontal, 20)
        .padding(.bottom, 10)
    }
}

//#if DEBUG
//#Preview {
//    WorkSpaceCreateView(store: Store(initialState: WorkSpaceCreateFeature.State(), reducer: {
//        WorkSpaceCreateFeature()
//    }))
//}
//#endif
