//
//  HomeInitView.swift
//  PlaygroundSpace
//
//  Created by 김진수 on 8/2/24.
//

import SwiftUI
import ComposableArchitecture

struct HomeInitView: View {
    
    @Perception.Bindable var store: StoreOf<HomeInitFeature>
    
    var body: some View {
        WithPerceptionTracking {
            makeHomeInitView()
            .navigationBarTitleDisplayMode(.inline)
            .listStyle(.plain)
            .tint(.brBlack)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    HStack {
                        HStack {
                            if let urlString = store.state.workSpaceData?.coverImage {
                                DownSamplingImageView(url: URL(string: urlString), size: CGSize(width: 32, height: 32))
                            } else {
                                Image(ImageNames.workSpaceDefaultImage)
                                    .resizable()
                            }
                        }
                        .frame(width: 32, height: 32)
                        .clipShape(RoundedRectangle(cornerRadius: 8))
                        .onTapGesture {
                            store.send(.delegate(.showSideMenu))
                        }
                        
                        Text(store.state.workSpaceData?.name ?? "empty")
                    }
                }
            }
            .onAppear {
                store.send(.onAppear)
            }
        }
    }
}

extension HomeInitView {
    private func makeHomeInitView() -> some View {
        List {
            makeChannelListView()
            makeDMListView()
        }
    }
    
    private func makeListView(text: String) -> some View {
        HStack(spacing: 4) {
            Text("#")
            Text(text)
        }
    }
    
    private func makeChannelListView() -> some View {
        DisclosureGroup("채널") {
            
            ForEach(store.state.channelListDatas, id: \.channelId) { item in
                makeListView(text: item.name)
                    .listRowInsets(EdgeInsets())
                    .listRowSeparator(.hidden)
                    .onTapGesture {
                        print("item")
                    }
            }
            HStack(spacing: 12) {
                Text("+")
                Text("채널 추가")
            }
            .listRowInsets(EdgeInsets())
            .alignmentGuide(.listRowSeparatorLeading, computeValue: { dimension in
                return -dimension.width
            })
            .onTapGesture {
                print("tap")
            }
            
        }
    }
    
    private func makeDMListView() -> some View {
        DisclosureGroup("다이렉트 메시지") {
            
            ForEach(store.state.dmsListDatas, id: \.roomId) { item in
                makeListView(text: item.user.nickname)
                    .listRowInsets(EdgeInsets())
                    .listRowSeparator(.hidden)
                    .onTapGesture {
                        print("item")
                    }
            }
            HStack(spacing: 12) {
                Text("+")
                Text("팀원 추가")
            }
            .listRowInsets(EdgeInsets())
            .alignmentGuide(.listRowSeparatorLeading, computeValue: { dimension in
                return -dimension.width
            })
            .onTapGesture {
                print("tap")
            }
            
        }
    }
    
}

//#if DEBUG
//#Preview {
//    HomeInitView(store: Store(initialState: HomeInitFeature.State(), reducer: {
//        HomeInitFeature()
//    }))
//}
//#endif
