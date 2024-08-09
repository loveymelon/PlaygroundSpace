//
//  DMListFeature.swift
//  PlaygroundSpace
//
//  Created by 김진수 on 8/5/24.
//

import Foundation
import ComposableArchitecture

@Reducer
struct DMListFeature {
    @ObservableState
    struct State: Equatable {
        var workSpaceData: WorkspaceListEntity?
        var isEmpty: Bool = true
        var memberData: [MemberInfoEntity] = []
        var dmRoomListData: [DMSEntity] = []
        var dmListData: [String: DMEntity] = [:]
        
        @Presents var inviteState: InviteFeature.State?
    }
    
    enum Action {
        case onAppear
        
        case viewTouchEvent(ViewTouchType)
        case catchWorkSpaceData(WorkspaceListEntity)
        case network(FetchDMListDataType)
        case dataTrans(DataTransType)
        
        case inviteAction(PresentationAction<InviteFeature.Action>)
        
        case delegate(Delegate)
        enum Delegate {
            case dmRoomTapped
            case memberTapped(DMSEntity)
        }
    }
    
    enum ViewTouchType {
        case inviteButtonTapped
        case memberTapped(MemberInfoEntity)
    }
    
    enum FetchDMListDataType {
        case memberList
        case dmRoomList
        case dmList
    }
    
    enum DataTransType {
        case memberList([MemberInfoEntity])
        case dmRoomEntity([DMSEntity])
        case dmEntity([String: DMEntity])
    }
    
    private let repository = DMListRepository()
    
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .onAppear:
                return .run { send in
                    await send(.network(.memberList))
                    await send(.network(.dmRoomList))
                }
                
            case let .catchWorkSpaceData(entity):
                state.workSpaceData = entity
                
            case .network(.memberList):
                return .run { send in
                    let result = await repository.fetchMember()
                    
                    guard let memberData = result else { return }
                    
                    await send(.dataTrans(.memberList(memberData)))
                }
                
            case .network(.dmRoomList):
                return .run { send in
                    let result = await repository.fetchDMRoomList()
                    
                    guard let dmRoomData = result else { return }

                    await send(.dataTrans(.dmRoomEntity(dmRoomData)))
                }
                
            case .network(.dmList):
                return .run { [state = state] send in
                    var dmList: [String: DMEntity] = [:]
                    
                    for room in state.dmRoomListData {
                        
                        let temp = await repository.fetchDMList(roomId: room.roomId)
                        
                        guard let dmEntity = temp else { return }
                        
                        
                        dmList[room.roomId] = dmEntity.last
                    }
                    
                    await send(.dataTrans(.dmEntity(dmList)))
                    
                }
                
            case let .dataTrans(.memberList(memberData)):
                
                var tempData = memberData
                
                for (index, item) in tempData.enumerated() {
                    if item.userId == UserDefaultsManager.shared.userId {
                        tempData.remove(at: index)
                    }
                }
                
                state.memberData = tempData
                
            case let .dataTrans(.dmRoomEntity(roomEntity)):
                
                state.dmRoomListData = roomEntity
                
                return .run { send in
                    await send(.network(.dmList))
                }
                
            case let .dataTrans(.dmEntity(dms)):
                
                state.dmListData = dms
                
            case let .viewTouchEvent(.memberTapped(entity)):
                return .run { send in
                    let result = await repository.createDMRoom(opponentId: entity.userId)
                    
                    guard let data = result else { return }
                    
                    await send(.delegate(.memberTapped(data)))
                }
                
                
            case .viewTouchEvent(.inviteButtonTapped):
                state.inviteState = InviteFeature.State()
                
            case .inviteAction(.presented(.delegate(.backButtonTapped))):
                return .run { send in
                    await send(.inviteAction(.dismiss))
                }
            case let .inviteAction(.presented(.delegate(.inviteComplete(entity)))):
                state.memberData.append(entity)
                
                return .run { send in
                    await send(.inviteAction(.dismiss))
                }
                
            default:
                break
            }
            return .none
        }
        .ifLet(\.$inviteState, action: \.inviteAction) {
            InviteFeature()
        }
    }
}
