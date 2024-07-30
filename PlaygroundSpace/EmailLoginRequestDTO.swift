//
//  EmailLoginRequestDTO.swift
//  PlaygroundSpace
//
//  Created by 김진수 on 7/30/24.
//

import Foundation

struct EmailLoginRequestDTO: RequestDTO {
    let email: String
    let password: String
}
