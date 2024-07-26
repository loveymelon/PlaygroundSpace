//
//  SignUpType.swift
//  PlaygroundSpace
//
//  Created by 김진수 on 7/26/24.
//

import Foundation

enum SignUp: String, CaseIterable {
    case email = "이메일"
    case nickname = "닉네임"
    case phone = "연락처"
    case password = "비밀번호"
    case checkPassword = "비밀번호 확인"
    
    var number: Bool {
        switch self {
        case .email:
            return false
        case .nickname:
            return false
        case .phone:
            return true
        case .password:
            return false
        case .checkPassword:
            return false
        }
    }
    
    var secure: Bool {
        switch self {
        case .email:
            return false
        case .nickname:
            return false
        case .phone:
            return false
        case .password:
            return true
        case .checkPassword:
            return true
        }
    }
    
    var placeHolder: String {
        switch self {
        case .email, .nickname, .phone, .password:
            return "\(rawValue)를 입력하세요"
        case .checkPassword:
            return "\(rawValue)를 한 번더 입력하세요"
        }
    }
}
