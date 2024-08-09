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
    @State var messageText: String = ""
    
    var body: some View {
        WithPerceptionTracking {
            makeChatView()
                .toolbar(.hidden, for: .tabBar)
                .onAppear {
                    store.send(.onAppear)
                }
        }
    }
}

extension ChatView {
    private func makeChatView() -> some View {
        ZStack(alignment: .bottom) {
            VStack {
                List {
                    ForEach(store.dmList ,id: \.dmId) { item in
                        MessageView(messageData: item)
                            
                    }
                }
                .listStyle(.plain)
                .listRowSeparator(.hidden)
                
                Spacer()
            }
            
            makeTextField()
        }
    }
    
    private func makeTextField() -> some View {
        HStack {
            Image(ImageNames.plus)
                .padding(.leading, 10)
            
            TextField("메세지를 입력하세요", text: $messageText, axis: .vertical)
                .textFieldStyle(.plain)
                .frame(minHeight: 40)
                .lineLimit(3)
            
            
            Image(ImageNames.messageSelect)
                .onTapGesture {
                    store.send(.pushChat(messageText))
                }
                .padding(.trailing, 10)
        }
        .background(.baPrimary)
        .clipShape(RoundedRectangle(cornerRadius: 10))
        .padding(.all, 14)
    }
    
}
