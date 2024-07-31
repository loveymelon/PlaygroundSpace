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
                            HStack {
                                Image(ImageNames.workSpaceDefaultImage)
                                    .resizable()
                                    .frame(width: 32, height: 32)
                                makeText(text: store.viewTextState.title, type: .title1)
                                    
                            }
                        }
                         
                    }
            }
        }
    }
}

extension HomeEmptyView {
    
    func makeHomeEmptyView() -> some View {
        
        VStack {
//            seperatorLine()
                
            makeText(text: store.viewTextState.mainText, type: .title1)
                .padding(.top, 30)
            
            makeText(text: store.viewTextState.detailText, type: .bodyBold)
                .padding(.top, 20)
            makeImage()
            Spacer()
            makeButton()
        }
//        .padding(.top, 1)
        
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
                .padding(.horizontal, 20)
                .padding(.bottom, 10)
        }
    }
    
//    func seperatorLine() -> some View {
//        Divider()
//            .frame(height: 1)
//            .overlay(Color.gray)
//            .opacity(0.2)
//    }
}

//#if DEBUG
//#Preview {
//    HomeEmptyView(store: Store(initialState: HomeEmptyFeature.State(), reducer: {
//        HomeEmptyFeature()
//    }))
//}
//#endif
