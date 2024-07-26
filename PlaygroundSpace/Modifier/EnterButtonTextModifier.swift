//
//  EnterButtonTextModifier.swift
//  PlaygroundSpace
//
//  Created by 김진수 on 7/26/24.
//

import SwiftUI

private struct EnterButtonTextModifier: ViewModifier {
    let type: PSTypography
    let foreColor: Color
    let backColor: Color
    
    func body(content: Content) -> some View {
        content
            .frame(height: 44)
            .frame(maxWidth: .infinity)
            .foregroundStyle(foreColor)
            .background(backColor)
            .setTextStyle(type: type)
            .clipShape(RoundedRectangle(cornerRadius: 15))
    }
}

extension View {
    func asText(type: PSTypography, foreColor: Color, backColor: Color) -> some View {
        modifier(EnterButtonTextModifier(type: type, foreColor: foreColor, backColor: backColor))
    }
}
