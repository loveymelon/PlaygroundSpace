//
//  ChannelCreateFeature.swift
//  PlaygroundSpace
//
//  Created by 김진수 on 8/11/24.
//

import Foundation
import ComposableArchitecture

@Reducer
struct ChannelCreateFeature {
    @ObservableState
    struct State: Equatable {
        var channelTextType = ChannelType.allCases
        var viewTextState: ViewTextState = ViewTextState()
        var requiredIsValid: Bool = false
    }
    
    enum ChannelType: String, CaseIterable {
        case channelName = "채널 이름"
        case channelExplain = "채널 설명"
        
        var placeholder: String {
            return switch self {
            case .channelName:
                "채널 이름을 입력하세요 (필수)"
            case .channelExplain:
                "채널을 설명하세요 (옵션)"
            }
        }
    }
    
    struct ViewTextState: Equatable {
        var channelNameText: String = ""
        var channelExplainText: String = ""
    }
    
    enum Action: BindableAction {
        case binding(BindingAction<State>)
        
        case viewEventType(ViewEventType)
        case networkType(NetworkType)
        
        case delegate(Delegate)
        enum Delegate {
            case backButtonTapped
            case complete
        }
    }
    
    enum ViewEventType {
        case backButtonTapped
        case completeButtonTapped
    }
    
    enum NetworkType {
        case complete
    }
    
    private let repository = ChannelCreateRepository()
    
    var body: some ReducerOf<Self> {
        BindingReducer()
        
        Reduce { state, action in
            switch action {
            case .binding:
                let requiredValid = (!state.viewTextState.channelNameText.isEmpty && !state.viewTextState.channelExplainText.isEmpty)
                
                state.requiredIsValid = requiredValid
                
            case .viewEventType(.backButtonTapped):
                return .run { send in
                    await send(.delegate(.backButtonTapped))
                }
                
            case .viewEventType(.completeButtonTapped):
                return .run { send in
                    await send(.networkType(.complete))
                }
                
            case .networkType(.complete):
                return .run { [state = state] send in
                    let result = await repository.createChannel(name: state.viewTextState.channelNameText, explain: state.viewTextState.channelExplainText)
                    
                    guard let data = result else { return }
                    
                    await send(.delegate(.complete))
                }
                
            default:
                break
            }
            return .none
        }
    }
}
