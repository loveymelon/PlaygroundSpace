//
//  HomeCoordinator.swift
//  PlaygroundSpace
//
//  Created by 김진수 on 8/5/24.
//

import TCACoordinators
import ComposableArchitecture

@Reducer(state: .equatable)
enum HomeScreen {
    case homeInitView(HomeInitFeature)
    case channelCoordinatorView(ChannelCoordinator)
    case chatView(ChatFeature)
    case channelSettingView(ChannelSettingFeature)
}

@Reducer
struct HomeCoordinator {
    
    @ObservableState
    struct State: Equatable {
        
        static let initial = Self(routes: [.root(.homeInitView(HomeInitFeature.State()), embedInNavigationView: true)])
        
        var routes: IdentifiedArrayOf<Route<HomeScreen.State>>
    }
    
    enum Action {
        case router(IdentifiedRouterActionOf<HomeScreen>)
        
        case workspaceResultScene(WorkspaceListEntity)
        case goBackToRoot
        case nextChannelChatView(ChannelEntity)
        case nextDMChatView(DMSEntity)
        
        case delegate(Delegate)
        enum Delegate {
            case sideMenuTrigger
        }
    }
    
    // TabCoordinator에서 워크스페이스 리스트 통신후 HomeCoordinator에 값을 전달만 해주면 repository가 필요없지 않나?
    var body: some ReducerOf<Self> {
        
        Reduce { state, action in
            switch action {
            case let .workspaceResultScene(entity):
                return .run { send in
                    await send(.router(.routeAction(id: .root, action: .homeInitView(.catchWorkSpaceData(entity)))))
                }
            case .router(.routeAction(id: _, action: .homeInitView(.delegate(.showSideMenu)))):
                return .send(.delegate(.sideMenuTrigger))
                
            case .router(.routeAction(id: _, action: .homeInitView(.delegate(.fetchAllChannelTapped)))):
                state.routes.presentCover(.channelCoordinatorView(.initial))
                
            case .router(.routeAction(id: _, action: .channelCoordinatorView(.delegate(.dismissPresent)))):
                return .run { send in
                    await send(.goBackToRoot)
                }
            case let .router(.routeAction(id: _, action: .homeInitView(.delegate(.channelTapped(entity))))):
                return .run { send in
                    await send(.nextChannelChatView(entity))
                }
                
            case let .router(.routeAction(id: _, action: .homeInitView(.delegate(.dmTapped(entity))))):
                return .run { send in
                    await send(.nextDMChatView(entity))
                }
                
            case let .router(.routeAction(id: _, action: .channelCoordinatorView(.delegate(.channelTouch(entity))))):
                return .run { send in
                    await send(.goBackToRoot)
                    try await Task.sleep(for: .seconds(1))
                    await send(.nextChannelChatView(entity))
                }
                
            case let .router(.routeAction(id: _, action: .channelSettingView(.delegate(.channelEditComplete(title))))):
                return .run { send in
                    await send(.router(.routeAction(id: .chat, action: .chatView(.catchTitle(title)))))
                    await send(.router(.routeAction(id: .root, action: .homeInitView(.fetchChannel))))
                }
                
            case let .router(.routeAction(id: _, action: .chatView(.delegate(.channelSettingTapped(channelId))))):
                state.routes.push(.channelSettingView(.init(channelId: channelId)))
                
            case .router(.routeAction(id: _, action: .channelSettingView(.delegate(.channelDelete)))):
                return .run { send in
                    await send(.goBackToRoot)
                }
                
            case .router(.routeAction(id: _, action: .channelSettingView(.delegate(.channelOut)))):
                return .run { send in
                    await send(.goBackToRoot)
                }
                
            case let .nextChannelChatView(entity):
                state.routes.push(.chatView(.init(chatRoomData: DMSEntity(), channelId: entity.channelId, channelTitle: entity.name, beforeView: .allChannel)))
                
            case let .nextDMChatView(entity):
                state.routes.push(.chatView(.init(chatRoomData: entity, beforeView: .dmList)))
                
            case .goBackToRoot:
                // 네비게이션이 내려가는 것을 기다리지말고 다 내려
                return .routeWithDelaysIfUnsupported(state.routes, action: \.router, scheduler: .main) { $0.goBackToRoot() }
                
            default:
                break
            }
            return .none
        }
        .forEachRoute(\.routes, action: \.router)
    }
}
