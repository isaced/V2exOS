//
//  AppearanceConfig.swift
//  V2exOS
//
//  Created by isaced on 2022/12/9.
//

import Foundation

class SettingsConfig: ObservableObject {
    public static let shared = SettingsConfig()
    
    static let FontSizeKey = "settings.font.size"
    static let DefaultFontSize = 14.0

    static let AutoRefreshOnActiveKey = "settings.auto.refresh.onActive"

    @Published public var fontSize: CGFloat {
        didSet {
            UserDefaults.standard.set(fontSize, forKey: SettingsConfig.FontSizeKey)
        }
    }

    /// 切回 App 时超过间隔自动刷新列表
    @Published public var autoRefreshOnActive: Bool {
        didSet {
            UserDefaults.standard.set(autoRefreshOnActive, forKey: SettingsConfig.AutoRefreshOnActiveKey)
        }
    }

    public init() {
        let storedFontSize = CGFloat(UserDefaults.standard.float(forKey: SettingsConfig.FontSizeKey))
        fontSize = storedFontSize < 10 ? SettingsConfig.DefaultFontSize : storedFontSize

        autoRefreshOnActive = (UserDefaults.standard.object(forKey: SettingsConfig.AutoRefreshOnActiveKey) as? Bool) ?? true
    }
}
