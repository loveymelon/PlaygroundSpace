//
//  DMMemeberView.swift
//  PlaygroundSpace
//
//  Created by 김진수 on 8/6/24.
//

import SwiftUI

struct DMMemeberView: View {
    var memberInfo: MemberInfoListEntity
    
    var body: some View {
        VStack {
            makeDMMemberView()
            Spacer()
        }
    }
}

extension DMMemeberView {
    func makeDMMemberView() -> some View {
        ScrollView(.horizontal, showsIndicators: false) {
            LazyHStack(spacing: 10) {
                ForEach(memberInfo.memberInfoList, id: \.userId) { item in
                    makeMemberProfile(item: item)
                }
            }
        }
    }
    
    func makeMemberProfile(item: MemberInfoEntity) -> some View {
        VStack {
            Group {
                if let imageUrl = item.profileImage, let url = URL(string: imageUrl) {
                    DownSamplingImageView(url: url, size: CGSize(width: 44, height: 44))
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                } else {
                    Image(ImageNames.profile)
                        .resizable()
                        .frame(width: 44, height: 44)
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                }
            }
            .frame(width: 44, height: 44)
            
            Text(item.nickname)
                .setTextStyle(type: .body)
        }
    }
}

//#Preview {
//    DMMemeberView()
//}
