//
//  ChatView.swift
//  PlaygroundSpace
//
//  Created by 김진수 on 8/8/24.
//

import SwiftUI
import ComposableArchitecture

struct ChatView: View {
    @Perception.Bindable var store: StoreOf<ChatFeature>
    
    
    var body: some View {
        WithPerceptionTracking {
            makeChatView()
                .toolbar(.hidden, for: .tabBar)
                .onAppear {
                    store.send(.onAppear)
                }
                .navigationTitle(store.state.chatRoomData.user.nickname)
        }
    }
}

extension ChatView {
    private func makeChatView() -> some View {
        VStack {
            ScrollViewReader { proxy in
                WithPerceptionTracking {
                    
                    ScrollView {
                        ForEach(store.dmList, id: \.dmId) { item in
                            LazyVStack {
                                MessageView(messageData: item)
                                //                                .id(item.dmId)
                            }
                            //                        .listRowSeparator(.hidden)
                        }
                        Color.clear
                            .id("bottom")
                    }
                    
                }
                .onChange(of: store.dmList) { newValue in
                    // 데이터가 변경될 때 마지막 항목으로 스크롤합니다.
                    if let lastItem = newValue.last {
                        DispatchQueue.main.async {
                            proxy.scrollTo("bottom", anchor: .bottom)
                        }
                    }
                }
                .listStyle(.plain)
                
            }
            Spacer()
            makeTextField()
        }
        
    }
    
    private func makeTextField() -> some View {
        HStack {
            Image(ImageNames.plus)
                .padding(.leading, 10)
            
            TextField("메세지를 입력하세요", text: $store.state.messageText, axis: .vertical)
                .textFieldStyle(.plain)
                .frame(minHeight: 40)
                .lineLimit(3)
            
            
            Image(ImageNames.messageSelect)
                .onTapGesture {
                    store.send(.pushChat)
                }
                .padding(.trailing, 10)
        }
        .background(.baPrimary)
        .clipShape(RoundedRectangle(cornerRadius: 10))
        .padding(.all, 14)
    }
    
}
