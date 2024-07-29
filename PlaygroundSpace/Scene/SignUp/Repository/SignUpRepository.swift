//
//  SignUpRepository.swift
//  PlaygroundSpace
//
//  Created by 김진수 on 7/29/24.
//

import Foundation

final class SignUpRepository {
    
    let mapper = SignUpMapper()
    
    func duplicatedEmail(email: String) {
        let requestDTO = mapper.emailEntityToDTO(email: email)
        
        print("here?")
        NetworkManager.shared.duplicateEmail(userEmailDTO: requestDTO)
    }
    
    func signUpEnter(email: String, nick: String, number: String, password: String) {
        let requestDTO = mapper.signUpInfoEntityToDTO(email: email, nick: nick, number: number, password: password)
        
        NetworkManager.shared.signUpFinish(userInfo: requestDTO)
    }
}
