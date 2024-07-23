//
//  PSTypography.swift
//  PlaygroundSpace
//
//  Created by 김진수 on 7/23/24.
//

import Foundation
import SwiftUI

enum PSTypography {
    case title1
    case title2
    case bodyBold
    case body
    case caption
    
    var size: CGFloat {
        switch self {
        case .title1:
            return 22
        case .title2:
            return 14
        case .bodyBold, .body:
            return 13
        case .caption:
            return 12
        }
    }
    
    var height: CGFloat {
        switch self {
        case .title1:
            return 30
        case .title2:
            return 20
        case .bodyBold, .body, .caption:
            return 18
        }
    }
    
    var weight: Font.Weight {
        switch self {
        case .title1, .title2, .bodyBold:
            return .bold
        case .body, .caption:
            return .regular
        }
    }
    
}
