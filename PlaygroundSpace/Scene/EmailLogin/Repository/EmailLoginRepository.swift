//
//  EmailLoginRepository.swift
//  PlaygroundSpace
//
//  Created by 김진수 on 7/30/24.
//

import Foundation
import ComposableArchitecture

final class EmailLoginRepository {
    
    let mapper = EmailLoginMapper()
    
    @Dependency(\.networkManager) var network
    
    func login(email: String, password: String) async -> UserEntity? {
        let request = mapper.entityToRequestDTO(email: email, password: password)
        
        do {
            let result = try await network.requestNetwork(dto: UserDTOModel.self, router: UserRouter.emailLogin(EmailLoginRequestDTO(email: request.email, password: request.password)))
            
            switch result {
            case .success(let data):
                let entity = mapper.dtoToEntity(dto: data)
                return entity
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
