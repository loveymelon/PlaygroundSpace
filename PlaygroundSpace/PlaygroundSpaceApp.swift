//
//  PlaygroundSpaceApp.swift
//  PlaygroundSpace
//
//  Created by 김진수 on 7/23/24.
//

import SwiftUI
import KakaoSDKCommon
import KakaoSDKAuth

@main
struct PlaygroundSpaceApp: App {
    init() {
        KakaoSDK.initSDK(appKey: APIKey.kakaoKey)
    }
    
    var body: some Scene {
        WindowGroup {
            //            OnboardingView()
//            AuthView()
//                .onOpenURL { url in
//                    if (AuthApi.isKakaoTalkLoginUrl(url)) {
//                        _ = AuthController.handleOpenUrl(url: url)
//                    }
//                }
            SignUpView()
        }
    }
}
