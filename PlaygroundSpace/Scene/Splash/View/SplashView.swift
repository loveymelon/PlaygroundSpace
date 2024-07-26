//
//  SplashView.swift
//  PlaygroundSpace
//
//  Created by 김진수 on 7/23/24.
//

import SwiftUI

struct SplashView: View {
    
    var body: some View {
        VStack {
            Text(InfoText.splash)
                .multilineTextAlignment(.center)
                .setTextStyle(type: .title1)
                .foregroundStyle(.brBlack)
                .padding(.top, 60)
            
            Spacer()
            
            Image(ImageNames.splash)
                .resizable()
                .aspectRatio(1, contentMode: .fit)
                .padding(.horizontal, 10)
                .clipped()
            
            Spacer()
        }
    }
}
