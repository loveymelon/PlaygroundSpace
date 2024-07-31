//
//  CompleteView.swift
//  PlaygroundSpace
//
//  Created by 김진수 on 7/29/24.
//

import SwiftUI
import ComposableArchitecture

struct CompleteView: View {
    @Perception.Bindable var store: StoreOf<CompleteFeature>
    
    var body: some View {
        WithPerceptionTracking {
            NavigationStack {
                makeCompleteView()
                    .onAppear {
                        store.send(.onAppear)
                    }
                    .navigationTitle(store.textState.start)
                    .navigationBarTitleDisplayMode(.inline)
                    .toolbar {
                        ToolbarItem(placement: .topBarLeading) {
                            Button {
                                store.send(.backButtonTapped)
                            } label: {
                                Image(store.textState.backImgae)
                            }
                        }
                    }
                    .sheet(item: $store.scope(state: \.workSpaceCreateState, action: \.workSpaceCreateAction)) { store in
                        WorkSpaceCreateView(store: store)
                    }
            }
        }
    }
}

extension CompleteView {
    private func makeCompleteView() -> some View {
        ZStack {
            Color(.baPrimary)
            
            VStack {
                makeText(text: store.textState.title, type: .title1)
                    .padding(.top, 40)
                makeText(text: store.textState.nickname + store.textState.detail, type: .body)
                makeImage(image: ImageNames.complete)
                Spacer()
                makeButton()
            }
        }
    }
    
    private func makeText(text: String, type: PSTypography) -> some View {
        Text(text)
            .setTextStyle(type: type)
    }
    
    private func makeImage(image: String) -> some View {
        Image(image)
            .resizable()
            .aspectRatio(1, contentMode: .fit)
            .padding(.horizontal, 10)
            .clipped()
    }
    
    private func makeButton() -> some View {
        
        Button {
            store.send(.workSpaceCreateButtonTapped)
        } label: {
            Text(InfoText.HomeEmptyTextType.create)
                .asText(type: .title2, foreColor: .brWhite, backColor: .brGreen)
        }
        .padding(.horizontal, 20)
        .padding(.bottom, 30)
 
    }
}
