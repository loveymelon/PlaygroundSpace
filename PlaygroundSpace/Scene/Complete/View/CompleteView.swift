//
//  CompleteView.swift
//  PlaygroundSpace
//
//  Created by 김진수 on 7/29/24.
//

import SwiftUI

struct CompleteView: View {
    var buttonAction: 
    
    var body: some View {
        makeTopBar()
    }
}

extension CompleteView {
    private func makeTopBar() -> some View {
        VStack {
            Color(.clear)
                .frame(height: 2)
            HStack(alignment: .center) {
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
}
