//
//  DMListView.swift
//  PlaygroundSpace
//
//  Created by 김진수 on 8/5/24.
//

import SwiftUI
import ComposableArchitecture

struct DMListView: View {
    @Perception.Bindable var store: StoreOf<DMListFeature>
    
    var body: some View {
        WithPerceptionTracking {
            makeDMListView()
                .toolbar {
                    ToolbarItem(placement: .topBarLeading) {
                        HStack {
                            HStack {
                                makeImageView(imageUrl: store.state.workSpaceData?.coverImage)
                                
                            }
                            
                            Text("Direct Message")
                        }
                    }
                    
                }
                .onAppear {
                    store.send(.onAppear)
                }
                .sheet(item: $store.scope(state: \.inviteState, action: \.inviteAction)) { store in
                    InviteView(store: store)
                }
        }
    }
}

extension DMListView {
    func makeDMListView() -> some View {
        VStack {
            makeCheckEmpty()
        }
    }
    
    @ViewBuilder
    func makeCheckEmpty() -> some View {
        if store.state.memberData.isEmpty {
            DMEmptyView(store: store)
        } else {
            DMMemeberView(store: store)
                .frame(maxHeight: 80)
            makeDMSView()
            Spacer()
        }
    }
    
    func makeDMSView() -> some View {
        List {
            ForEach(store.state.dmRoomListData, id: \.roomId) { item in
                HStack {
                    makeImageView(imageUrl: item.user.profileImage)
                    
                    makeNicknameAndmessageView(item: item)
                    Spacer()
                }
                .onTapGesture {
                    store.send(.viewTouchEvent(.memberTapped(item.user)))
                }
            }
        }
        .listStyle(.plain)
    }
    
    func makeNicknameAndmessageView(item: DMSEntity) -> some View {
        VStack(spacing: 4) {
            HStack {
                Text(item.user.nickname)
                Spacer()
                if let date = store.dmListData[item.roomId]?.createdAt.toDate {
                    Text(DateManager.shared.dateToStringToRoomList(date))
                        .setTextStyle(type: .caption)
                }
            }
            
            HStack {
                Text(store.dmListData[item.roomId]?.content ?? "사진")
                    .setTextStyle(type: .body)
                Spacer()
            }
        }
    }
    
    func makeImageView(imageUrl: String?) -> some View {
        HStack {
            if let urlString = imageUrl {
                DownSamplingImageView(url: URL(string: urlString), size: CGSize(width: 40, height: 40))
            } else {
                Image(ImageNames.profile)
                    .resizable()
            }
        }
        .frame(width: 40, height: 40)
        .clipShape(RoundedRectangle(cornerRadius: 8))
    }
    
    func makeTextStack(title: String, detail: String) -> some View {
        VStack {
            Text(title)
                .setTextStyle(type: .bodyBold)
            Text(detail)
                .setTextStyle(type: .body)
        }
    }
}
