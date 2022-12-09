//
//  V2exOSApp.swift
//  V2exOS
//
//  Created by isaced on 2022/7/24.
//

import SwiftUI
import V2exAPI

var v2ex = V2exAPI()

@main
struct V2exOSApp: App {
    var body: some Scene {
        WindowGroup {
            NavigationView {
                SidebarView()
            }
            .frame(minWidth: 1000, minHeight: 600)
            .environmentObject(CurrentUserStore.shared)
            .environmentObject(SettingsConfig.shared)
            .task {
                ProxyHelper.loadProxy()
            }
        }
        .commands {
            CommandGroup(replacing: .help) {
                Button("GitHub") {
                    if let url = URL(string: "https://github.com/isaced/V2exOS") {
                        NSWorkspace.shared.open(url)
                    }
                }
            }
        }
        
        Settings{
            SettingsView()
                .environmentObject(SettingsConfig.shared)
        }
    }
}
