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
        var workSpaceData: WorkspaceListEntity?
        var channelListDatas: [ChannelEntity] = []
        var dmsListDatas: [DMSEntity] = []
    }
    enum Action {
        case catchWorkSpaceData(WorkspaceListEntity)
        case onAppear
        case fetchChannel
        case fetchDMList
        
        case showModel(ShowModel)
        case delegate(Delegate)
        enum Delegate {
            case showSideMenu
        }
    }
    
    enum ShowModel {
        case showChannel(ChannelListEntity)
        case showDM(DMRoomListEntity)
    }
    
    let repository = HomeInitRepository()
    
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .onAppear:
                return .run { send in
                    await send(.fetchChannel)
                    await send(.fetchDMList)
                }
                
            case let .catchWorkSpaceData(data):
                state.workSpaceData = data
                return .run { send in
                    await send(.fetchChannel)
                    await send(.fetchDMList)
                }
                
            case .fetchChannel:
                return .run { [state = state] send in
                    guard let result = await repository.fetchData(workSpaceId: state.workSpaceData?.workspaceID ?? "") else { return }
                    await send(.showModel(.showChannel(result)))
                }
            case .fetchDMList:
                return .run { send in
                    guard let result = await repository.fetchData() else { return }
                    await send(.showModel(.showDM(result)))
                }
                
            case let .showModel(.showChannel(channelListEntity)):
                state.channelListDatas = channelListEntity.channelList
                
            case let .showModel(.showDM(dmRoomlistEntity)):
                state.dmsListDatas = dmRoomlistEntity.dmlist
            default:
                break
            }
            return .none
        }
    }
}
