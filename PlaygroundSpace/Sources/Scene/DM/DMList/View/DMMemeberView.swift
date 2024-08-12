//
//  DMMemeberView.swift
//  PlaygroundSpace
//
//  Created by 김진수 on 8/6/24.
//

import SwiftUI
import ComposableArchitecture

struct DMMemeberView: View {
    @Perception.Bindable var store: StoreOf<DMListFeature>
    
    var body: some View {
        WithPerceptionTracking {
            makeDMMemberView()
        }
    }
}

extension DMMemeberView {
    func makeDMMemberView() -> some View {
        ScrollView(.horizontal, showsIndicators: false) {
            LazyHStack(spacing: 10) {
                ForEach(store.state.memberData, id: \.userId) { item in
                    makeMemberProfile(item: item)
                        .onTapGesture {
                            store.send(.viewTouchEvent(.memberTapped(item)))
                        }
                }
            }
            .frame(width: 84)
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
            .frame(width: 40, height: 40)
            
            Text(item.nickname)
                .setTextStyle(type: .body)
        }
    }
}

//#Preview {
//    DMMemeberView()
//}
