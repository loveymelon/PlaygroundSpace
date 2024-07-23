//
//  DynamicTextModifier.swift
//  PlaygroundSpace
//
//  Created by 김진수 on 7/23/24.
//

import SwiftUI

private struct DynamicTextModifier: ViewModifier {
    let type: PSTypography
    let font: UIFont
    
    func body(content: Content) -> some View {
        content
            .font(Font(font))
            .fontWeight(type.weight)
            .lineSpacing(type.height - font.lineHeight)
            .padding((type.height - font.lineHeight) / 2)
    }
    
    static func uiFontGuide(_ fontType: PSTypography) -> UIFont {
        UIFont.systemFont(ofSize: fontType.size)
    }
}

extension View {
    func setTextStyle(type: PSTypography) -> some View {
        modifier(DynamicTextModifier(type: type, font: DynamicTextModifier.uiFontGuide(type)))
    }
}
