//
//  ViewExt.swift
//  V2exOS
//
//  Created by isaced on 2023/2/11.
//

import SwiftUI
import SwiftUIIntrospect

// === .onFirstAppear() ===

extension View {
    func onFirstAppear(perform: @escaping () -> Void) -> some View {
        modifier(OnFirstAppear(perform: perform))
    }
    
    func removeBackground() -> some View {
#if os(macOS)
        return self.introspect(.list, on: .macOS(.v12, .v13, .v14)) { tableView in
            tableView.backgroundColor = .clear
            tableView.enclosingScrollView!.drawsBackground = false
        }
#else
        return self
#endif
    }
    
    func hiddeScrollContentBackground() -> some View{
#if os(macOS)
        if #available(macOS 13.0, *) {
            return self.introspect(.scrollView, on: .macOS(.v12, .v13)) { scrollView in
                scrollView.scrollerStyle = .overlay
            }
        }
#endif
        return self
    }
}

private struct OnFirstAppear: ViewModifier {
    let perform: () -> Void

    @State private var firstTime = true

    func body(content: Content) -> some View {
        content.onAppear {
            if firstTime {
                firstTime = false
                perform()
            }
        }
    }
}
