//
//  WorkSpaceCreateRepository.swift
//  PlaygroundSpace
//
//  Created by 김진수 on 8/2/24.
//

import Foundation
import ComposableArchitecture

struct WorkSpaceCreateRepository {
    
    @Dependency(\.networkManager) var network
    
    func workSpaceCreateFinish(name: String, description: String, imageData: Data) async -> Void? {
        
        do {
            let result = try await network.requestNetwork(dto: WorkSpaceInfoDTO.self, router: WorkspaceRouter.create(name, description, imageData))
            
            switch result {
            case .success(let data):
                print(data)
                return ()
            case .failure(let error):
                print(error)
                return nil
            }
        } catch {
            print(error.localizedDescription)
            return nil
        }
    }
}
