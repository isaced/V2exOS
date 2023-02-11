//
//  V2exOSiOSApp.swift
//  V2exOSiOS
//
//  Created by isaced on 2023/2/10.
//

import SwiftUI
import V2exAPI

var v2ex = V2exAPI()

@main
struct V2exOSiOSApp: App {
    var body: some Scene {
        WindowGroup {
            HomeView()
            //            TabView {
            //                    .tabItem {
            //                        Label("社区", systemImage: "house")
            //                    }
            //                EmptyView()
            //                    .tabItem {
            //                        Label("设置", systemImage: "gearshape")
            //                    }
            //            }
                .environmentObject(SettingsConfig.shared)
                .environmentObject(CurrentUserStore.shared)
            
        }
    }
}
