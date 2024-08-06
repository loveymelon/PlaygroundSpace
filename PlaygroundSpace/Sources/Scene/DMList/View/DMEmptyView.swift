//
//  DMEmptyView.swift
//  PlaygroundSpace
//
//  Created by 김진수 on 8/6/24.
//

import SwiftUI

struct DMEmptyView: View {
    var body: some View {
        makeDMEmptyView()
    }
}

extension DMEmptyView {
    func makeDMEmptyView() -> some View {
        VStack {
            Text("워크스페이스에\n멤버가 없어요.")
                .setTextStyle(type: .title1)
                .multilineTextAlignment(.center)
            Text("새로운 팀원을 초대해보세요.")
                .setTextStyle(type: .body)
            Text("팀원 초대하기")
                .asButton {
                    print("tap")
                }
                .asText(type: .title2, foreColor: .brWhite, backColor: .brGreen)
                .padding(.horizontal, 50)
        }
    }
    
    
}

#Preview {
    DMEmptyView()
}
