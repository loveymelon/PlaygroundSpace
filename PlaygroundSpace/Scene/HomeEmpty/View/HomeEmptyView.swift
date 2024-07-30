//
//  HomeEmptyView.swift
//  PlaygroundSpace
//
//  Created by 김진수 on 7/30/24.
//

import SwiftUI
import ComposableArchitecture

struct HomeEmptyView: View {
    @Perception.Bindable var store: StoreOf<HomeEmptyFeature>
    
    var body: some View {
        WithPerceptionTracking {
            NavigationStack {
                makeHomeEmptyView()
                    .toolbar {
                        ToolbarItem(placement: .topBarLeading) {
                            Image(ImageNames.workSpaceDefaultImage)
                            makeText(text: store.viewTextState.title, type: .title1)
                        }
                    }
            }
        }
    }
}

extension HomeEmptyView {
    func makeHomeEmptyView() -> some View {
        VStack {
            makeText(text: store.viewTextState.mainText, type: .title1)
            Spacer()
            makeText(text: store.viewTextState.detailText, type: .bodyBold)
            makeImage()
            Spacer()
            makeButton()
        }
    }
    
    func makeText(text: String, type: PSTypography) -> some View {
        Text(text)
            .setTextStyle(type: type)
            .multilineTextAlignment(.center)
    }
    
    func makeImage() -> some View {
        Image(ImageNames.homeEmptyImage)
            .resizable()
            .aspectRatio(1, contentMode: .fit)
            .padding(.horizontal, 10)
            .clipped()
    }
    
    func makeButton() -> some View {
        Button {
            print("create")
        } label: {
            Text(store.viewTextState.createText)
                .asText(type: .title2, foreColor: .brWhite, backColor: .brGreen)
        }
    }
}
