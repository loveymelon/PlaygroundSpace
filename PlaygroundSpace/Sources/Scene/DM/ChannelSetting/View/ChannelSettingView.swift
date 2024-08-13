//
//  ChannelSettingView.swift
//  PlaygroundSpace
//
//  Created by 김진수 on 8/12/24.
//

import SwiftUI
import ComposableArchitecture

struct ChannelSettingView: View {
    @Perception.Bindable var store: StoreOf<ChannelSettingFeature>
    var rows: [GridItem] = Array(repeating: GridItem(.flexible()), count: 5)
    
    var body: some View {
        WithPerceptionTracking {
            makeChannelSettingView()
                .navigationTitle("채널 설정")
                .toolbar(.hidden, for: .tabBar)
                .onAppear {
                    store.send(.viewEventType(.onAppear))
                }
                .sheet(item: $store.scope(state: \.channelEditState, action: \.channelEditAction)) { store in
                    ChannelCreateView(store: store)
                }
                .sheet(item: $store.scope(state: \.channelOwnerState, action: \.channelOwnerAction)) { store in
                    ChannelOwnerView(store: store)
                }
        }
    }
}

extension ChannelSettingView {
    private func makeChannelSettingView() -> some View {
        ScrollView {
            VStack {
                makeChannelTitleAndExplainView()
                makeMemberView()
                checkOwner()
            }
            .padding(.top, 20)
            .padding(.horizontal, 10)
        }
    }
    
    private func makeChannelTitleAndExplainView() -> some View {
        VStack(alignment: .leading) {
            HStack {
                Text("#\(store.channelData.name)")
                    .setTextStyle(type: .title1)
                Spacer()
            }
            HStack {
                Text(store.channelData.description ?? "")
                    .setTextStyle(type: .body)
                Spacer()
            }
        }
        .padding(.bottom, 10)
    }
    
    private func makeMemberView() -> some View {
        DisclosureGroup("멤버(\(store.channelData.channelMembers.count))") {
            
            LazyVGrid(columns: rows) {
                ForEach(Array(store.channelData.channelMembers.enumerated()), id: \.element.userId) { index, user in
                    memberProfileView(user.nickname, imageUrl: user.profileImage)
                }
            }

        }
    }
    
    private func memberProfileView(_ nick: String, imageUrl: String?) -> some View {
        VStack {
            HStack {
                if let url = imageUrl {
                    DownSamplingImageView(url: URL(string: url), size: CGSize(width: 44, height: 44))
                        .frame(width: 50, height: 50)
                } else {
                    Image(ImageNames.profile)
                        .resizable()
                        .frame(width: 44, height: 44)
                }
            }
            .clipShape(RoundedRectangle(cornerRadius: 10))
            Text(nick)
                .setTextStyle(type: .body)
            
        }
    }
    
    @ViewBuilder
    private func checkOwner() -> some View {
        VStack {
            if store.ownerIsValid {
                makeButton(title: "채널 편집", action: .viewEventType(.channelButtonType(.channelEdit)))
                makeButton(title: "채널에서 나가기", action: .viewEventType(.channelButtonType(.channelOut)))
                makeButton(title: "채널 관리자 변경", action: .viewEventType(.channelButtonType(.channelOwnerChange)))
                makeButton(title: "채널 삭제", action: .viewEventType(.channelButtonType(.channelDelete)), color: .red)
            } else {
                makeButton(title: "채널에서 나가기", action: .viewEventType(.channelButtonType(.channelOut)))
            }
        }
        .padding(.bottom, 10)
    }
    
    private func makeButton(title: String, action: ChannelSettingFeature.Action, color: Color = .black) -> some View {
        Button {
            store.send(action)
        } label: {
            Text(title)
                .tint(color)
                .setTextStyle(type: .title2)
                .frame(height: 44)
                .frame(maxWidth: .infinity)
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(color, lineWidth: 1)
                )
//                .padding(.horizontal, 20)
//                .padding(.bottom, 10)
        }
        
    }
}
