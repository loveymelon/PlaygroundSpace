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
    
    var body: some View {
        WithPerceptionTracking {
            makeChannelSettingView()
                .navigationTitle("채널 설정")
                .toolbar(.hidden, for: .tabBar)
                .toolbar {
                    ToolbarItem(placement: .topBarLeading) {
                        makeCancleButton()
                    }
                }
                .onAppear {
                    store.send(.viewEventType(.onAppear))
                }
        }
    }
}

extension ChannelSettingView {
    private func makeChannelSettingView() -> some View {
        VStack {
            makeChannelTitleAndExplainView()
        }
    }
    
    private func makeChannelTitleAndExplainView() -> some View {
        VStack {
            Text("#\(store.channelData.name)")
                .setTextStyle(type: .title2)
            Text(store.channelData.description ?? "")
                .setTextStyle(type: .body)
        }
    }
    
    private func makeCancleButton() -> some View {
        Button {
            store.send(.viewEventType(.backButtonTapped))
        } label: {
            Image(ImageNames.backButton)
        }
    }
    
    private func makeMemberView() -> some View {
        DisclosureGroup("멤버(\(store.channelData.channelMembers.count))") {
            ForEach(store.channelData.channelMembers, id: \.userId) { item in
                memberProfileView(item.nickname, imageUrl: item.profileImage)
            }
            
        }
    }
    
    @ViewBuilder
    private func memberProfileView(_ nick: String, imageUrl: String?) -> some View {
        if let url = imageUrl {
            DownSamplingImageView(url: URL(string: url), size: CGSize(width: 44, height: 44))
                .frame(width: 50, height: 50)
                
        } else {
            Image(ImageNames.profile)
                .resizable()
                .frame(width: 44, height: 44)
        }
    }
}
