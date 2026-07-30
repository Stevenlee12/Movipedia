//
//  Font+Extension.swift
//  Movipedia
//
//  Created by Steven Lie on 29/07/26.
//

import SwiftUI

extension Font {
    static func poppins(_ weight: Font.Weight = .regular, size: CGFloat) -> Font {
        switch weight {
        case .bold:
            return .system(size: size, weight: .bold)
        case .semibold:
            return .system(size: size, weight: .semibold)
        case .medium:
            return .system(size: size, weight: .medium)
        default:
            return .system(size: size, weight: .regular)
        }
    }
}
