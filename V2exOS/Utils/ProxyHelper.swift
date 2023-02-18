//
//  ProxyHelper.swift
//  V2exOS
//
//  Created by isaced on 2022/9/30.
//

import Foundation
import Kingfisher

enum ProxyType: Int, Codable {
    case http
    case socks
}

struct ProxyInfo: Codable {
    var enabled: Bool
    var type: ProxyType = .http
    var host: String?
    var port: Int?
    var username: String?
    var password: String?
}

enum ProxyHelper {
    static let ProxyCacheKey = "ProxyInfo"
    
    /**
     Load proxy
     */
    static func loadProxy() {
        guard let proxyInfo = loadProxyInfo(), proxyInfo.enabled else {
            clearProxy()
            return
        }
        
        let sessionConfiguration = URLSessionConfiguration.default
        
        if proxyInfo.type == .http {
            sessionConfiguration.connectionProxyDictionary = [
                kCFNetworkProxiesHTTPEnable: true,
                kCFNetworkProxiesHTTPProxy: proxyInfo.host ?? "",
                kCFNetworkProxiesHTTPPort: proxyInfo.port ?? 0,
                kCFNetworkProxiesHTTPSEnable: true,
                kCFNetworkProxiesHTTPSProxy: proxyInfo.host ?? "",
                kCFNetworkProxiesHTTPSPort: proxyInfo.port ?? 0,
            ]
        } else if proxyInfo.type == .socks {
            sessionConfiguration.connectionProxyDictionary = [
                kCFNetworkProxiesSOCKSEnable: true,
                kCFNetworkProxiesSOCKSProxy: proxyInfo.host ?? "",
                kCFNetworkProxiesSOCKSPort: proxyInfo.port ?? 0,
            ]
        }
        
        if let username = proxyInfo.username, username.count > 0 {
            sessionConfiguration.connectionProxyDictionary?[kCFProxyUsernameKey] = username
        }
        if let password = proxyInfo.password, password.count > 0 {
            sessionConfiguration.connectionProxyDictionary?[kCFProxyPasswordKey] = password
        }
        
        v2ex.session = URLSession(configuration: sessionConfiguration)
        ImageDownloader.default.sessionConfiguration = sessionConfiguration
    }
    
    static func clearProxy() {
        v2ex.session = URLSession.shared
        ImageDownloader.default.sessionConfiguration = URLSessionConfiguration.ephemeral
    }
    
    /**
     Load proxy info from UserDefaults
     */
    static func loadProxyInfo() -> ProxyInfo? {
        if let data = UserDefaults.standard.object(forKey: ProxyCacheKey) as? Data {
            let decoder = JSONDecoder()
            return try? decoder.decode(ProxyInfo.self, from: data)
        }
        return nil
    }
    
    /**
     Save proxy info to UserDefaults
     */
    static func saveProxyInfo(proxyInfo: ProxyInfo) {
        let encoder = JSONEncoder()
        if let encoded = try? encoder.encode(proxyInfo) {
            UserDefaults.standard.set(encoded, forKey: ProxyCacheKey)
        }
    }
}
