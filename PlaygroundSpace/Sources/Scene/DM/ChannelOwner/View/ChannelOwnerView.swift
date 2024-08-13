//
//  ChannelOwnerView.swift
//  PlaygroundSpace
//
//  Created by 김진수 on 8/13/24.
//

import SwiftUI
import ComposableArchitecture

struct ChannelOwnerView: View {
    @Perception.Bindable var store: StoreOf<ChannelOwnerFeature>
    
    var body: some View {
        WithPerceptionTracking {
            NavigationStack {
                makeChannelOwnerView()
                    .navigationBarTitleDisplayMode(.inline)
                    .navigationTitle("채널 관리자 변경")
                    .toolbar {
                        ToolbarItem(placement: .topBarLeading) {
                            makeCancleButton()
                        }
                    }
            }
            .onAppear {
                store.send(.viewEventType(.onAppear))
            }
        }
    }
}

extension ChannelOwnerView {
    private func makeChannelOwnerView() -> some View {
        List {
            ForEach(store.memberInfo, id: \.userId) { item in
                HStack {
                    makeImageView(imageUrl: item.profileImage)
                    
                    makeNicknameAndmessageView(item: item)
                    Spacer()
                }
                .onTapGesture {
                    store.send(.viewEventType(.memberTapped(item.userId)))
                }
            }
        }
        .listStyle(.plain)
    }
    
    private func makeNicknameAndmessageView(item: MemberInfoEntity) -> some View {
        VStack(spacing: 4) {
            HStack {
                Text(item.nickname)
                    .setTextStyle(type: .bodyBold)
                Spacer()
            }
            
            HStack {
                Text(item.email)
                    .setTextStyle(type: .body)
                Spacer()
            }
        }
    }
    
    private func makeImageView(imageUrl: String?) -> some View {
        HStack {
            if let urlString = imageUrl {
                DownSamplingImageView(url: URL(string: urlString), size: CGSize(width: 44, height: 44))
            } else {
                Image(ImageNames.profile)
                    .resizable()
            }
        }
        .frame(width: 44, height: 44)
        .clipShape(RoundedRectangle(cornerRadius: 8))
    }
    
    private func makeCancleButton() -> some View {
        Button {
            store.send(.viewEventType(.backButtonTapped))
        } label: {
            Image(ImageNames.backButton)
        }
    }
}
