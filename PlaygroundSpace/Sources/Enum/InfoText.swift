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
    static let signUpTitle = "회원가입"
    static let login = "로그인"
    
    enum SignUpButtonType: String {
        case duplicate = "중복 확인"
        case signUpEnter = "가입하기"
    }
    
    enum EmailLoginType: String, CaseIterable {
        case email = "이메일"
        case password = "비밀번호"
        
        var placeHolder: String {
            switch self {
            case .email, .password:
                return "\(rawValue)를 입력하세요"
            }
        }
    }
    
    enum HomeEmptyTextType {
        static let title = "No Workspace"
        static let mainText = "워크스페이스를 찾을 수 없어요."
        static let detailText = "관리자에게 초대를 요청하거나, 다른 이메일로 시도하거나\n 새로운 워크스페이스를 생성해주세요."
        static let create = "워크스페이스 생성"
    }
    
    enum WorkSpaceCreateType: String, CaseIterable {
        case workSpaceName = "워크스페이스 이름"
        case workSpaceExplain = "워크스페이스 설명"
        
        var placeHolder: String {
            switch self {
            case .workSpaceName:
                return "워크스페이스 이름을 입력하세요 (필수)"
            case .workSpaceExplain:
                return "워크스페이스를 설명하세요 (옵션)"
            }
        }
    }
}
