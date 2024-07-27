//
//  InfoText.swift
//  PlaygroundSpace
//
//  Created by 김진수 on 7/24/24.
//

import Foundation

enum InfoText {
    static let splash = "새싹톡을 사용하면 어디서나\n팀을 모을 수 있습니다."
    static let start = "시작하기"
    static let or = "또는"
    static let signUp = "또는 새롭게 회원가입 하기"
    static let already = "출시 준비 완료!"
    static let startDetail = "님의 조직을 위해 새로운 새싸톡 워크스페이스를 시작할 준비가 완료되었어요!"
    static let workspaceCre = "워크스페이스 생성"
    static let signUpTitle = "회원가입"
    
    enum SignUpButtonType: String {
        case duplicate = "중복 확인"
        case signUpEnter = "가입하기"
    }
}
