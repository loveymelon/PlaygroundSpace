//
//  UserSignUpRequestDTO.swift
//  PlaygroundSpace
//
//  Created by 김진수 on 7/29/24.
//

import Foundation

struct UserSignUpRequestDTO: RequestDTO {
    let email: String
    let password: String
    let nickname: String
    let phone: String
}
