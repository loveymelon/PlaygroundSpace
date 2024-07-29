//
//  CompleteView.swift
//  PlaygroundSpace
//
//  Created by 김진수 on 7/29/24.
//

import SwiftUI
import ComposableArchitecture

struct CompleteView: View {
    var store: StoreOf<CompleteFeature>
    
    var body: some View {
        makeCompleteView()
    }
}

extension CompleteView {
    private func makeCompleteView() -> some View {
        VStack {
            makeTopBar()
            ZStack {
                Color(.baPrimary)
                
                makeText(text: InfoText.already, type: .title1)
                makeText(text: InfoText.startDetail, type: .body)
                makeImage(image: ImageNames.complete)
                makeButton()
            }
        }
    }
    
    private func makeTopBar() -> some View {
        VStack {
            Color(.clear)
                .frame(height: 2)
            HStack(alignment: .center) {
                Button {
                    print("back")
                } label: {
                    Image(ImageNames.backButton)
                }
                .padding(.leading, 8)
                
                Spacer()
                
                Text(InfoText.start)
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
            print("next")
        } label: {
            Text(InfoText.workspaceCre)
                .asText(type: .title2, foreColor: .brWhite, backColor: .brGreen)
        }
        .padding(.horizontal, 20)
        .padding(.bottom, 30)
 
    }
}
