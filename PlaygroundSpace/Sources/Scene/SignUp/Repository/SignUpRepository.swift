//
//  SignUpRepository.swift
//  PlaygroundSpace
//
//  Created by 김진수 on 7/29/24.
//

import Foundation

final class SignUpRepository {
    
    let mapper = SignUpMapper()
    
    func duplicatedEmail(email: String) async -> Void? {
        let requestDTO = mapper.emailEntityToDTO(email: email)
        
        print("here?")
        
        do {
            let result = try await NetworkManager.shared.requestNetwork(router: UserRouter.duplicate(requestDTO))
            
            switch result {
            case .success():
                return ()
            case .failure(let failure):
                print(failure)
                return nil
            }
            
        } catch {
            print(error)
            return nil
        }
        
    }
    
    func signUpEnter(email: String, nick: String, number: String, password: String) async -> UserEntity? {
        let requestDTO = mapper.signUpInfoEntityToDTO(email: email, nick: nick, number: number, password: password)
        do {
            let result = try await NetworkManager.shared.requestNetwork(dto: UserDTOModel.self, router: UserRouter.signUpEnter(requestDTO))
            
            switch result {
            case .success(let data):
                return mapper.dtotoEntity(dto: data)
            case .failure(let failure):
                print(failure)
                return nil
            }
        } catch {
            print(error)
            return nil
        }
    }
}
