//
//  MessageView.swift
//  PlaygroundSpace
//
//  Created by 김진수 on 8/10/24.
//

import SwiftUI

struct MessageView: View {
    
    var messageData: DMEntity
    @State private var imageCountType: ImageCountType = .none
    @State private var userType: UserType = .me
    
    enum ImageCountType: Int {
        case none = 0
        case one
        case two
        case three
        case four
        case five
    }
    
    enum UserType {
        case me
        case other
    }
    
    var body: some View {
        makeMessageView()
            .task {
                imageCountType = ImageCountType(rawValue: self.messageData.files.count) ?? .none
                userType = (UserDefaultsManager.shared.userId == messageData.user.userId ? .me : .other)
            }
    }
}

extension MessageView {
    
    @ViewBuilder
    private func makeMessageView() -> some View {
        if userType == .me {
            HStack(alignment: .bottom) {
                Spacer()
                makeDateView()
                HStack {
                    checkImageOrContentView()
                }
            }
        } else {
            HStack(alignment: .bottom) {
                HStack(alignment: .top) {
                    makeProfileImageView()
                    VStack(alignment: .leading) {
                        Text(messageData.user.nickname)
                            .setTextStyle(type: .caption)
                        checkImageOrContentView()
                    }
                }
                makeDateView()
                Spacer()
            }
        }
    }
    
    @ViewBuilder
    private func makeProfileImageView() -> some View {
        if let urlString = messageData.user.profileImage {
            DownSamplingImageView(url: URL(string: urlString), size: CGSize(width: 50, height: 50))
                .frame(width: 34, height: 34)
        } else {
            Image(ImageNames.profile)
                .resizable()
                .frame(width: 34, height: 34)
        }
    }
    
    private func makeContentView(content: String) -> some View {
        Text(content)
            .padding(.all, 8)
            .overlay(
                RoundedRectangle(cornerRadius: 10)
                    .stroke(Color.brGray, lineWidth: 2)
            )
    }
    
    // 유저일때 닉네임 보이게 하는지 여부 파악 뷰
//    @ViewBuilder
//    private func makeNickAndContentView(content: String) -> some View {
//        if userType == .me {
//            HStack {
//                Text(content)
//            }
//        } else {
//            HStack {
//                VStack {
//                    Text(messageData.user.nickname)
//                    Text(content)
//                }
//            }
//        }
//    }
    
    // 날짜를 만드는 뷰
    @ViewBuilder
    private func makeDateView() -> some View {
        if let date = messageData.createdAt.toDate {
            Text(DateManager.shared.dateToStringToChat(date, isMe: userType == .me ? true : false))
                .setTextStyle(type: .body)
                .foregroundStyle(Color.viAlpa)
        } else {
            EmptyView()
        }
    }
    
    // 이미지 개수에 따라 달라지는 뷰
    @ViewBuilder
    private func makeImageView() -> some View {
        switch imageCountType {
        case .none:
            EmptyView()
        case .one:
            if let file = messageData.files.first {
                DownSamplingImageView(url: URL(string: file), size: CGSize(width: 80, height: 80))
                    .frame(width: 100, height: 100)
                    .clipShape(RoundedRectangle(cornerRadius: 10))
            }
        case .two:
            HStack {
                if let file1 = messageData.files[safe: 0] {
                    DownSamplingImageView(url: URL(string: file1), size: CGSize(width: 80, height: 80))
                        .frame(width: 80, height: 80)
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                }
                if let file2 = messageData.files[safe: 1] {
                    DownSamplingImageView(url: URL(string: file2), size: CGSize(width: 80, height: 80))
                        .frame(width: 80, height: 80)
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                }
            }
        case .three:
            VStack(alignment: .center) {
                HStack {
                    if let file1 = messageData.files[safe: 0] {
                        DownSamplingImageView(url: URL(string: file1), size: CGSize(width: 80, height: 80))
                            .frame(width: 80, height: 80)
                            .clipShape(RoundedRectangle(cornerRadius: 10))
                    }
                    if let file2 = messageData.files[safe: 1] {
                        DownSamplingImageView(url: URL(string: file2), size: CGSize(width: 80, height: 80))
                            .frame(width: 80, height: 80)
                            .clipShape(RoundedRectangle(cornerRadius: 10))
                    }
                }
                if let file3 = messageData.files[safe: 2] {
                    DownSamplingImageView(url: URL(string: file3), size: CGSize(width: 80, height: 80))
                        .frame(width: 80, height: 80)
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                }
            }
        case .four:
            VStack(alignment: .center) {
                HStack {
                    if let file1 = messageData.files[safe: 0] {
                        DownSamplingImageView(url: URL(string: file1), size: CGSize(width: 80, height: 80))
                            .frame(width: 80, height: 80)
                            .clipShape(RoundedRectangle(cornerRadius: 10))
                    }
                    if let file2 = messageData.files[safe: 1] {
                        DownSamplingImageView(url: URL(string: file2), size: CGSize(width: 80, height: 80))
                            .frame(width: 80, height: 80)
                            .clipShape(RoundedRectangle(cornerRadius: 10))
                    }
                }
                HStack {
                    if let file3 = messageData.files[safe: 2] {
                        DownSamplingImageView(url: URL(string: file3), size: CGSize(width: 80, height: 80))
                            .frame(width: 80, height: 80)
                            .clipShape(RoundedRectangle(cornerRadius: 10))
                    }
                    if let file4 = messageData.files[safe: 3] {
                        DownSamplingImageView(url: URL(string: file4), size: CGSize(width: 80, height: 80))
                            .frame(width: 80, height: 80)
                            .clipShape(RoundedRectangle(cornerRadius: 10))
                    }
                }
            }
        case .five:
            VStack(alignment: .center) {
                HStack {
                    if let file1 = messageData.files[safe: 0] {
                        DownSamplingImageView(url: URL(string: file1), size: CGSize(width: 80, height: 80))
                            .frame(width: 55, height: 55)
                            .clipShape(RoundedRectangle(cornerRadius: 10))
                    }
                    if let file2 = messageData.files[safe: 1] {
                        DownSamplingImageView(url: URL(string: file2), size: CGSize(width: 80, height: 80))
                            .frame(width: 55, height: 55)
                            .clipShape(RoundedRectangle(cornerRadius: 10))
                    }
                    if let file3 = messageData.files[safe: 2] {
                        DownSamplingImageView(url: URL(string: file3), size: CGSize(width: 80, height: 80))
                            .frame(width: 55, height: 55)
                            .clipShape(RoundedRectangle(cornerRadius: 10))
                    }
                }
                HStack {
                    if let file4 = messageData.files[safe: 3] {
                        DownSamplingImageView(url: URL(string: file4), size: CGSize(width: 80, height: 80))
                            .frame(width: 90, height: 70)
                            .clipShape(RoundedRectangle(cornerRadius: 10))
                    }
                    if let file5 = messageData.files[safe: 4] {
                        DownSamplingImageView(url: URL(string: file5), size: CGSize(width: 80, height: 80))
                            .frame(width: 90, height: 70)
                            .clipShape(RoundedRectangle(cornerRadius: 10))
                    }
                }
            }
        }
    }
    
    // 이미지뷰를 만들지 컨텐츠 뷰를 만들지 파악
    @ViewBuilder
    private func checkImageOrContentView() -> some View {
        if messageData.content != nil && !messageData.files.isEmpty {
            makeContentView(content: messageData.content!)
                .setTextStyle(type: .body)
            makeImageView()
        } else if let message = messageData.content {
            makeContentView(content: message)
                .setTextStyle(type: .body)
        } else {
            makeImageView()
        }
    }
}
