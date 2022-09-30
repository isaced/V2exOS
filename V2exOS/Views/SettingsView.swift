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
            ProxySettingsView()
                .tabItem {
                    Label("代理配置", systemImage: "person.crop.circle")
                }
        }
        .frame(width: 450, height: 250)
    }
}


struct ProxySettingsView: View {
    
    @State var proxyEnable = false
    @State var proxyHost: String = ""
    @State var proxyPort: String = ""
    
    var body: some View {
        VStack {
            Toggle("启用代理", isOn: $proxyEnable)
            TextField("代理地址", text: $proxyHost, prompt: Text("127.0.0.1"))
            TextField("端口", text: $proxyPort, prompt: Text("1087"))
        }
        .onChange(of: proxyEnable, perform: { v in save() })
        .onChange(of: proxyHost, perform: { v in save() })
        .onChange(of: proxyPort, perform: { v in save() })
        .frame(maxWidth: 250)
        .onAppear {
            if let proxyInfo = ProxyHelper.loadProxyInfo() {
                proxyEnable = proxyInfo.enabled
                proxyHost = proxyInfo.host
                proxyPort = String(proxyInfo.port)
            }
        }
        .onDisappear {
            save()
        }
    }
    
    func save() {
        let proxyInfo = ProxyInfo(enabled: proxyEnable, type: .http, host: proxyHost, port: Int(proxyPort) ?? 0)
        ProxyHelper.saveProxyInfo(proxyInfo: proxyInfo)
        ProxyHelper.loadProxy()
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}
