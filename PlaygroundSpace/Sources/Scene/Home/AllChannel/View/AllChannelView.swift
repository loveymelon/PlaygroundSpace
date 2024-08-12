//
//  AllChannelView.swift
//  PlaygroundSpace
//
//  Created by 김진수 on 8/11/24.
//

import SwiftUI
import ComposableArchitecture

struct AllChannelView: View {
    @Perception.Bindable var store: StoreOf<AllChannelFeature>
    
    var body: some View {
        WithPerceptionTracking {
            makeAllChannelView()
                .listStyle(.plain)
                
                .navigationTitle("채널 탐색")
                .navigationBarTitleDisplayMode(.inline)
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

extension AllChannelView {
    private func makeAllChannelView() -> some View {
        List {
            ForEach(store.state.channelList, id: \.channelId) { channel in
                HStack(spacing: 12) {
                    Text("#")
                    Text(channel.name)
                }
                .listRowSeparator(.hidden)
                .onTapGesture {
                    store.send(.viewEventType(.channelTapped(channel)))
                }
            }
        }
    }
    
    private func makeCancleButton() -> some View {
        Button {
            store.send(.viewEventType(.backButtonTapped))
        } label: {
            Image(ImageNames.backButton)
        }
    }
}
