//
//  UserName.swift
//  V2exOS
//
//  Created by m on 2022/9/30.
//

import Foundation
import SwiftUI

struct UserName: View {
    var username: String
    var isLink = true

    init(_ username: String, isLink: Bool = true) {
        self.username = username
        self.isLink = isLink
    }

    var label: some View {
        Text(username)
            .foregroundColor(.secondary)
#if os(macOS)
            .onHover { inside in
                if inside {
                    NSCursor.pointingHand.push()
                } else {
                    NSCursor.pop()
                }
            }
#endif
    }

    var body: some View {
#if os(macOS) || os(iOS)
        if isLink {
            Button {
                if let url = URL(string: "https://www.v2ex.com/member/\(username)") {
#if os(iOS)
                    UIApplication.shared.open(url)
#endif
#if os(macOS)
                    NSWorkspace.shared.open(url)
#endif
                }
            } label: {
                label
            }
            .buttonStyle(PlainButtonStyle())
        } else {
            label
        }

#elseif os(tvOS)
        Text(username)
            .foregroundColor(.secondary)
            .fontWeight(.bold)
#else
        EmptyView()
#endif
    }
}

struct UserName_Previews: PreviewProvider {
    static var previews: some View {
        UserName("isaced")
    }
}
