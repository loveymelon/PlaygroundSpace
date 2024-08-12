//
//  AuthView.swift
//  PlaygroundSpace
//
//  Created by 김진수 on 7/26/24.
//

import SwiftUI
import AuthenticationServices
import KakaoSDKCommon
import KakaoSDKAuth
import KakaoSDKUser
import ComposableArchitecture

struct AuthView: View {
    
    @Perception.Bindable var store: StoreOf<AuthFeature>
    
    var body: some View {
        WithPerceptionTracking {
            VStack(spacing: 8) {
                makeAppleButton()
                makeKakaoButton()
                makeEmailButton()
                makeSignUpButton()
            }
            .padding(.horizontal, 20)
        }
    }
}

extension AuthView {
    func makeAppleButton() -> some View {
        Image(ImageNames.appleLogin)
            .resizable()
            .frame(height: 44)
            .frame(maxWidth: .infinity)
            .overlay {
                SignInWithAppleButton(
                    onRequest: { request in
                        request.requestedScopes = [.fullName, .email]
                    },
                    onCompletion: { result in
                        switch result {
                        case .success(let authResults):
                            print("Apple Login Successful")
                            switch authResults.credential{
                            case let appleIDCredential as ASAuthorizationAppleIDCredential:
                                // 계정 정보 가져오기
                                
                                let fullName = appleIDCredential.fullName
                                var name = (fullName?.familyName ?? "") + (fullName?.givenName ?? "")
                                let email = appleIDCredential.email
                                let identityToken = String(data: appleIDCredential.identityToken!, encoding: .utf8)
                                
                                if let email {
                                    store.send(.appleLoginTapped(identityToken ?? "empty", name))
                                } else {
                                    store.send(.appleLoginTapped(identityToken ?? "empty", ""))
                                }
                                
                            default:
                                break
                            }
                        case .failure(let error):
                            print(error.localizedDescription)
                            print("error")
                        }
                    }
                )
                .blendMode(.overlay)
            }
        
    }
    
    func makeKakaoButton() -> some View {
        Button {
            if (UserApi.isKakaoTalkLoginAvailable()) {
                UserApi.shared.loginWithKakaoTalk {(oauthToken, error) in
                    if let error = error {
                        print(error)
                    }
                    if let oauthToken = oauthToken {
                        //                        ## 소셜 로그인(회원가입 API CALL)
                        store.send(.kakaoLoginTapped(oauthToken.accessToken))
                    }
                }
            } else {
                UserApi.shared.loginWithKakaoAccount {(oauthToken, error) in
                    if let error = error {
                        print(error)
                    }
                    if let oauthToken = oauthToken{
                        print("kakao success")
                        //                        ## 소셜 로그인(회원가입 API CALL)
                        store.send(.kakaoLoginTapped(oauthToken.accessToken))
                    }
                }
            }
        } label : {
            Image(ImageNames.kakaoLogin)
                .resizable()
                .frame(height: 44)
                .frame(maxWidth: .infinity)
        }
    }
    
    func makeEmailButton() -> some View {
        Button {
            store.send(.emailLoginTapped)
        } label: {
            Image(ImageNames.emailLogin)
                .resizable()
                .frame(height: 44)
                .frame(maxWidth: .infinity)
        }
    }
    
    func makeSignUpButton() -> some View {
        Button {
            store.send(.signUpButtonTapped)
        } label: {
            Text(InfoText.signUp)
                .TextWithColoredSubstring(originalText: InfoText.signUp, coloredSubstring: InfoText.or, color: .tePrimary)
                .setTextStyle(type: .title2)
        }
    }
    
}
