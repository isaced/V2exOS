//
//  SettingsView.swift
//  V2exOS
//
//  Created by isaced on 2022/9/30.
//

import SwiftUI

struct SettingsView: View {
    var body: some View {
        TabView {
            AppearanceSettingsView()
                .tabItem {
                    Label("外观", systemImage: "paintpalette")
                }
            ProxySettingsView()
                .tabItem {
                    Label("代理配置", systemImage: "globe.badge.chevron.backward")
                }
        }
        .frame(width: 450, height: 250)
    }
}

struct AppearanceSettingsView: View {
    @EnvironmentObject private var SettingsConfig: SettingsConfig
    
    var body: some View {
        Form {
            Slider(value: $SettingsConfig.fontSize, in: 10.0 ... 30.0) {
                Text("字体大小")
            }
        }
        .frame(maxWidth: 200)
    }
}

struct ProxySettingsView: View {
    @State var proxyEnable = false
    @State var proxyType: ProxyType = .http
    @State var proxyHost: String = ""
    @State var proxyPort: String = ""
    
    @State var proxyNeedPassword = false
    @State var proxyUsername: String = ""
    @State var proxyPassword: String = ""
    
    var body: some View {
        Form {
            Toggle("启用代理", isOn: $proxyEnable)
            
            Picker("类型：", selection: $proxyType) {
                Text("HTTP(S)").tag(ProxyType.http)
                Text("SOCKS").tag(ProxyType.socks)
            }
            //      .pickerStyle(.inline)
            .pickerStyle(.segmented)
            
            TextField("地址：", text: $proxyHost, prompt: Text("127.0.0.1"))
            TextField("端口：", text: $proxyPort, prompt: Text("1087"))
                .frame(width: 100)
            
            Toggle("代理服务器密码", isOn: $proxyNeedPassword)
            
            Group {
                TextField("用户名：", text: $proxyUsername)
                TextField("密码：", text: $proxyPassword)
            }
            .disabled(!proxyNeedPassword)
        }
        .frame(maxWidth: 300)
        .onChange(of: proxyEnable, perform: { _ in save() })
        .onChange(of: proxyHost, perform: { _ in save() })
        .onChange(of: proxyPort, perform: { _ in save() })
        .onChange(of: proxyNeedPassword, perform: { v in
            if !v {
                proxyUsername = ""
                proxyPassword = ""
            }
            
            save()
        })
        .onAppear {
            load()
        }
    }
    
    func load() {
        if let proxyInfo = ProxyHelper.loadProxyInfo() {
            proxyEnable = proxyInfo.enabled
            proxyType = proxyInfo.type
            proxyHost = proxyInfo.host ?? ""
            
            if let port = proxyInfo.port {
                proxyPort = String(port)
            }
            
            if let username = proxyInfo.username, let password = proxyInfo.password, username.count > 0, password.count > 0 {
                proxyUsername = username
                proxyPassword = password
                proxyNeedPassword = true
            }
        }
    }
    
    func save() {
        let proxyInfo = ProxyInfo(enabled: proxyEnable,
                                  type: proxyType,
                                  host: proxyHost,
                                  port: proxyPort.count > 0 ? Int(proxyPort) : nil,
                                  username: proxyUsername.count > 0 ? proxyUsername : nil,
                                  password: proxyPassword.count > 0 ? proxyPassword : nil)
        ProxyHelper.saveProxyInfo(proxyInfo: proxyInfo)
        ProxyHelper.loadProxy()
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}
