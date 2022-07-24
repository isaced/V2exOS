//
//  V2exOSApp.swift
//  V2exOS
//
//  Created by isaced on 2022/7/24.
//

import SwiftUI
import V2exAPI

let v2ex = V2exAPI(accessToken: "")

@main
struct V2exOSApp: App {
    var body: some Scene {
        WindowGroup {
          NavigationView {
            SidebarView()
          }
          .frame(minWidth: 1000, minHeight: 600)
        }
    }
}
