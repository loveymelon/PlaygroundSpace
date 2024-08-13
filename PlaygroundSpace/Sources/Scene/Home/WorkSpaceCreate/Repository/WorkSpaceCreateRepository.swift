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
    
    private let mapper = WorkSpaceCreateMapper()
    
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
    
    func workSpaceEdit(name: String, description: String, imageData: Data) async -> WorkspaceListEntity? {
        
        do {
            let result = try await network.requestNetwork(dto: WorkspaceDTO.self, router: WorkspaceRouter.edit(name, description, imageData))
            
            switch result {
            case .success(let data):
                return mapper.dtoToEntity(data)
            case .failure(let error):
                print(error.localizedDescription)
                return nil
            }
        } catch {
            print(error.localizedDescription)
            return nil
        }
        
    }
}
