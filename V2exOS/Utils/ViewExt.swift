//
//  ViewExt.swift
//  V2exOS
//
//  Created by isaced on 2023/2/11.
//

import SwiftUI
import SwiftUIIntrospect

extension View {
    /// Perform an action when the view is first appear
    func onFirstAppear(perform: @escaping () -> Void) -> some View {
        modifier(OnFirstAppear(perform: perform))
    }

    /// Remove the background of the scroll view
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

    /// Hide the background of the scroll view
    func hiddeScrollContentBackground() -> some View {
#if os(macOS)
        if #available(macOS 13.0, *) {
            return self.introspect(.scrollView, on: .macOS(.v12, .v13)) { scrollView in
                scrollView.scrollerStyle = .overlay
            }
        }
#endif
        return self
    }

    /// Change the cursor to pointing hand when hovering over a view
    func hoverPointCursor() -> some View {
#if os(macOS)
        return self.onHover { inside in
            if inside {
                NSCursor.pointingHand.push()
            } else {
                NSCursor.pop()
            }
        }
#else
        return self
#endif
    }

    /// wrap Link if url not empty
    func link(_ url: String?) -> some View {
        if let url = url {
            return AnyView(Link(destination: URL(string: url)!) {
                self
            })
        } else {
            return AnyView(self)
        }
    }
}

/// Perform an action when the view is first appear
private struct OnFirstAppear: ViewModifier {
    let perform: () -> Void

    @State private var firstTime = true

    func body(content: Content) -> some View {
        content.onAppear {
            if self.firstTime {
                self.firstTime = false
                self.perform()
            }
        }
    }
}
