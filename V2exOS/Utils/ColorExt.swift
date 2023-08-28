//
//  ColorExt.swift
//  V2exOS
//
//  Created by isaced on 2023/2/19.
//

import SwiftUI

extension Color {
    static var label: Color {
#if os(macOS)
        return Color(.labelColor)
#endif
        return Color(.label)
    }
}
