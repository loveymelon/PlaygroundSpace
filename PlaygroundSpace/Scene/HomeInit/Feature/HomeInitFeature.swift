//
//  HomeInitFeature.swift
//  PlaygroundSpace
//
//  Created by 김진수 on 8/2/24.
//

import Foundation
import ComposableArchitecture

@Reducer
struct HomeInitFeature {
    @ObservableState
    struct State: Equatable {
        var workSpaceDatas: WorkspaceListEntity?
        var channelListDatas: [ChannelEntity] = []
    }
    enum Action {
        case catchData([WorkspaceListEntity])
        case onAppear
        case fetchChannel
        case showModel(ChannelListEntity)
    }
    
    let repository = HomeInitRepository()
    
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case let .catchData(datas):
                state.workSpaceDatas = datas.first
                return .run { send in
                    await send(.fetchChannel)
                }
            case .onAppear:
                return .run { send in
                    await send(.fetchChannel)
                }
            case .fetchChannel:
                return .run { [state = state] send in
                    guard let workSpaceId = state.workSpaceDatas?.workspaceID else { return }
                    guard let result = await repository.fetchChannel(workSpaceId: workSpaceId) else { return }
                    await send(.showModel(result))
                }
            case let .showModel(channelListEntity):
                print("show", channelListEntity)
                state.channelListDatas = channelListEntity.channelList
            default:
                break
            }
            return .none
        }
    }
}
