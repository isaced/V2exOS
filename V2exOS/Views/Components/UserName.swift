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

    init(_ username: String) {
        self.username = username
    }

    var body: some View {
#if os(macOS) || os(iOS)
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
            Text(username)
                .foregroundColor(.secondary)
//                .fontWeight(.bold)
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
        .buttonStyle(PlainButtonStyle())
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
