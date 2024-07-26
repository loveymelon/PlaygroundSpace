//
//  ColoredSubstringModifier.swift
//  PlaygroundSpace
//
//  Created by 김진수 on 7/26/24.
//

import SwiftUI

private struct ColoredSubstringModifier: ViewModifier {
    let originalText: String
    let coloredSubstring: String
    let color: Color
    
    func body(content: Content) -> some View {
        if let coloredRange = originalText.range(of: coloredSubstring) {
            let beforeRange = originalText[..<coloredRange.lowerBound]
            let coloredText = originalText[coloredRange]
            let afterRange = originalText[coloredRange.upperBound...]
            
            return Text(beforeRange)
                .foregroundColor(.brGreen)
            + Text(coloredText)
                .foregroundColor(color)
            + Text(afterRange)
                .foregroundColor(.brGreen)
        } else {
            return Text(originalText)
                .foregroundColor(.brGreen)
        }
    }
}

extension View {
    func TextWithColoredSubstring(originalText: String, coloredSubstring: String, color: Color) -> some View {
        modifier(ColoredSubstringModifier(originalText: originalText, coloredSubstring: coloredSubstring, color: color))
    }
}
