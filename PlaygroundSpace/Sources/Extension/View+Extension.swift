//
//  ExtensionView.swift
//  PlaygroundSpace
//
//  Created by 김진수 on 8/5/24.
//

import SwiftUI

extension View {
    func asButton(action: @escaping () -> Void ) -> some View {
        modifier(ButtonWrapper(action: action))
    }
}

struct ButtonWrapper: ViewModifier {
    
    let action: () -> Void
    
    func body(content: Content) -> some View {
        Button(
            action:action,
            label: { content }
        )
    }
}
