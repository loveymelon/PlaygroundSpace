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
                .sheet(isPresented: $store.state.showImage) {
                    
                    ImagePicker(isPresented: $store.state.showImage, imageData: { imageData in
                        store.send(.selectedFinish(imageData))
                    }, selectedCount: store.imageLimit)

                }
        }
    }
}

extension ChatView {
    private func makeChatView() -> some View {
        VStack {
            ScrollViewReader { proxy in
                WithPerceptionTracking {
                    
                    ScrollView {
                        checkMessage()
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
        VStack {
            HStack {
                Image(ImageNames.plus)
                    .padding(.leading, 10)
                    .onTapGesture {
                        store.send(.plusTapped)
                    }
                
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
            HStack {
                ForEach(Array(store.state.imageData.enumerated()), id: \.element.self) { index, data in
                    selectedImageView(data, index)
                }
            }
        }
        .background(.baPrimary)
        .clipShape(RoundedRectangle(cornerRadius: 10))
        .padding(.all, 14)
    }
    
    private func selectedImageView(_ imageData: Data, _ index: Int) -> some View {
        ZStack(alignment: .topTrailing) {
            Image(uiImage: UIImage(data: imageData)!)
                .resizable()
                .aspectRatio(1, contentMode: .fit)
                .frame(width: 44, height: 44)
                .clipShape(RoundedRectangle(cornerRadius: 10))
            
            Button {
                store.send(.deleteImage(index))
            } label: {
                Image(ImageNames.camera)
                    .resizable()
                    .frame(width: 20, height: 20)
            }
            .offset(x: 10, y: -10)
        }
    }
    
    @ViewBuilder
    private func checkMessage() -> some View {
        if store.chatList.isEmpty {
            ForEach(store.dmList, id: \.dmId) { item in
                LazyVStack {
                    MessageView(messageData: item, chatData: ChatEntity(), messageIsValid: true)
                }
            }
        } else {
            ForEach(store.chatList, id: \.chatId) { item in
                LazyVStack {
                    MessageView(messageData: DMEntity(), chatData: item, messageIsValid: false)
                }
            }
        }
    }
    
}
