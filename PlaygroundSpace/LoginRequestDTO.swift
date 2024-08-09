//
//  LoginRequestDTO.swift
//  PlaygroundSpace
//
//  Created by 김진수 on 8/7/24.
//

import Foundation

struct KakaoLoginRequestDTO: RequestDTO {
    let oauthToken: String
}

struct AppleLoginRequestDTO: RequestDTO {
    let idToken: String
    let nickname: String
}
