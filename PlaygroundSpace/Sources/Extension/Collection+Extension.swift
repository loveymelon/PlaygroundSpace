//
//  Collection+Extension.swift
//  PlaygroundSpace
//
//  Created by 김진수 on 8/10/24.
//

import Foundation

extension Collection {
    subscript(safe index: Index) -> Element? {
        return indices.contains(index) ? self[index] : nil
    }
}
