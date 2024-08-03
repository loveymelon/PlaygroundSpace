//
//  CoordinatorRepository.swift
//  PlaygroundSpace
//
//  Created by 김진수 on 7/30/24.
//

import Foundation
import ComposableArchitecture

final class CoordinatorRepository {
    private let mapper = CoordinatorMapper()
    
    @Dependency(\.networkManager) var network
    
    func fetchWorkspaceList() async -> [WorkspaceListEntity] {
        do {
            let result = try await network.requestNetwork(dto: WorkSpaceListDTO.self, router: WorkspaceRouter.fetch)
            
            switch result {
            case .success(let data):
                print(data)
                return mapper.dtoToEntity(dto: data)
            case .failure(let error):
                print(error)
                return []
            }
        } catch {
            print(error)
            return []
        }
    }
}
