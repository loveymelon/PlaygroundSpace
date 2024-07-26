//
//  EnterButtonModifier.swift
//  PlaygroundSpace
//
//  Created by 김진수 on 7/26/24.
//

import SwiftUI

private struct EnterButtonModifier: ViewModifier {
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
    }
}

extension View {
    func asButton(type: PSTypography, foreColor: Color, backColor: Color) -> some View {
        modifier(EnterButtonModifier(type: type, foreColor: foreColor, backColor: backColor))
    }
}
