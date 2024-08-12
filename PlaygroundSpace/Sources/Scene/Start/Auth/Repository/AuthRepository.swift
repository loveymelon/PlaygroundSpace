//
//  AuthRepository.swift
//  PlaygroundSpace
//
//  Created by 김진수 on 8/7/24.
//

import Foundation
import ComposableArchitecture

struct AuthRepository {
    
    @Dependency(\.networkManager) var network
    
    private let mapper = EmailLoginMapper()
    
    func kakaoLogin(oauthToken: String) async -> UserEntity? {
        do {
            let result = try await network.requestNetwork(dto: UserDTOModel.self, router: UserRouter.kakaoLogin(KakaoLoginRequestDTO(oauthToken: oauthToken)))
            
            switch result {
            case let .success(data):
                return mapper.dtoToEntity(dto: data)
            case .failure(_):
                return nil
            }
        } catch {
            print(error.localizedDescription)
            return nil
        }
    }
    
    func appleLogin(token: String, nickname: String) async -> UserEntity? {
        do {
            let result = try await network.requestNetwork(dto: UserDTOModel.self, router: UserRouter.appleLogin(AppleLoginRequestDTO(idToken: token, nickname: nickname)))
            
            switch result {
            case .success(let data):
                return mapper.dtoToEntity(dto: data)
            case .failure(_):
                return nil
            }
        } catch {
            print(error.localizedDescription)
            return nil
        }
    }
}
