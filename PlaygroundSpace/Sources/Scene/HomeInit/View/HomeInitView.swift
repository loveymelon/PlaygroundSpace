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
            List {
                DisclosureGroup("채널") {
                    
                    ForEach(store.state.channelListDatas, id: \.channelId) { item in
                        makeListView(text: item.name)
                            .listRowInsets(EdgeInsets())
                            .listRowSeparator(.hidden)
                            .onTapGesture {
                                print("item")
                            }
                    }
                    HStack(spacing: 4) {
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
            .navigationBarTitleDisplayMode(.inline)
            .listStyle(.plain)
            .tint(.brBlack)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    HStack {
                        HStack {
                            if let urlString = store.state.workSpaceDatas?.coverImage {
                                DownSamplingImageView(url: URL(string: urlString), size: CGSize(width: 32, height: 32))
                            } else {
                                Image(ImageNames.workSpaceDefaultImage)
                                    .resizable()
                            }
                        }
                        .frame(width: 32, height: 32)
                        .clipShape(RoundedRectangle(cornerRadius: 8))
                        
                        Text(store.state.workSpaceDatas?.name ?? "empty")
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
    private func makeListView(text: String) -> some View {
        HStack(spacing: 4) {
            Text("#")
            Text(text)
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
