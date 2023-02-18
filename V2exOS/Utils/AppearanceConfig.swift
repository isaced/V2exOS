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
    
    @Published public var fontSize: CGFloat {
        didSet {
            UserDefaults.standard.set(fontSize, forKey: SettingsConfig.FontSizeKey)
        }
    }
    
    public init() {
        fontSize = CGFloat(UserDefaults.standard.float(forKey: SettingsConfig.FontSizeKey))
        if fontSize < 10 {
            fontSize = SettingsConfig.DefaultFontSize
        }
    }
}
