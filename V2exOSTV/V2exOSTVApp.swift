//
//  V2exOSTVApp.swift
//  V2exOSTV
//
//  Created by isaced on 2023/1/30.
//

import SwiftUI
import V2exAPI

var v2ex = V2exAPI()

@main
struct V2exOSTVApp: App {
    var body: some Scene {
        WindowGroup {
            TabView {
                MainView(nodeName: NodeNameHot)
                    .environmentObject(SettingsConfig.shared)
                    .tabItem {
                        Label("最热", systemImage: "flame")
                    }
                MainView(nodeName: NodeNameAll)
                    .environmentObject(SettingsConfig.shared)
                    .tabItem {
                        Label("最新", systemImage: "chart.bar")
                    }
            }
        }
    }
}
