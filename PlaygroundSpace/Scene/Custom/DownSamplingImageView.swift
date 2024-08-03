//
//  DownSamplingImageView.swift
//  PlaygroundSpace
//
//  Created by 김진수 on 8/3/24.
//

import SwiftUI
import Kingfisher

struct DownSamplingImageView: View {
    
    let url: URL?
    let size: CGSize
    
    var body: some View {
        KFImage(url)
            .requestModifier(KFImageRequestModifier())
            .setProcessor(
                DownsamplingImageProcessor(
                    size: size
                )
            )
            .cacheOriginalImage()
            .resizable()
            .aspectRatio(1, contentMode: .fill)
    }
}
