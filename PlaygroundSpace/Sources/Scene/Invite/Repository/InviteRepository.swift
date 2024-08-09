//
//  InviteRepository.swift
//  PlaygroundSpace
//
//  Created by 김진수 on 8/8/24.
//

import Foundation
import ComposableArchitecture

struct InviteRepository {
    private let mapper = InviteMapper()
    
    @Dependency(\.networkManager) var network
    
    func inviteUser(email: String) async -> MemberInfoEntity? {
        let requestData = mapper.emailToRequestDTO(email: email)
        
        do {
            let result = try await network.requestNetwork(dto: MemberInfoDTO.self, router: WorkspaceRouter.invite(requestData))
            
            switch result {
            case .success(let data):
                return mapper.dtoToEntity(dto: data)
            case .failure(let error):
                print(error)
                return nil
            }
        } catch {
            print(error)
            return nil
        }
    }
}
