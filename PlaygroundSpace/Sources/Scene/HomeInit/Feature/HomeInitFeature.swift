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
        var channelAddButtonBool: Bool = false
        
        @Presents var channelCreateState: ChannelCreateFeature.State?
    }
    enum Action: BindableAction {
        case binding(BindingAction<State>)
        
        case catchWorkSpaceData(WorkspaceListEntity)
        case onAppear
        case fetchChannel
        case fetchDMList
        case channelCreateButtonTapped
        case channelCreate
        case searchChannel
        
        case channelCreateAction(PresentationAction<ChannelCreateFeature.Action>)
        
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
        BindingReducer()
        
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
            
            case .channelCreateButtonTapped:
                state.channelAddButtonBool.toggle()
                
            case .channelCreate:
                state.channelCreateState = ChannelCreateFeature.State()
                
            case let .showModel(.showChannel(channelListEntity)):
                state.channelListDatas = channelListEntity.channelList
                
            case let .showModel(.showDM(dmRoomlistEntity)):
                state.dmsListDatas = dmRoomlistEntity.dmlist
                
            case .channelCreateAction(.presented(.delegate(.backButtonTapped))):
                return .run { send in
                    await send(.channelCreateAction(.dismiss))
                }
                
            case .channelCreateAction(.presented(.delegate(.complete))):
                return .run { send in
                    await send(.fetchChannel)
                    await send(.channelCreateAction(.dismiss))
                }
                
            default:
                break
            }
            return .none
        }
        .ifLet(\.$channelCreateState, action: \.channelCreateAction) {
            ChannelCreateFeature()
        }
    }
}
