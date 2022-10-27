//
//  SidebarView.swift
//  V2exOS
//
//  Created by isaced on 2022/7/24.
//

import SwiftUI
import V2exAPI

struct SidebarView: View {
  
  
  @EnvironmentObject private var currentUser: CurrentUserStore
  
  @State var nodeList : [V2Node]?
  @State var isLoading = true
  
  var body: some View {
    List() {
      
      Section(header: Text("Home")) {
        NavigationLink(destination: TopicListView(nodeName: "HOT")) {
          Label("最热", systemImage: "flame")
        }
        NavigationLink(destination: TopicListView(nodeName: "ALL")) {
          Label("最新", systemImage: "chart.bar")
        }
      }
      
      Section(header: Text("账户")) {
        NavigationLink(destination: ProfileView()) {
          Label((currentUser.accessToken != nil) ? "个人信息" : "登录", systemImage: "person.crop.circle")
        }.tag("profile")
        NavigationLink(destination: InboxListView()) {
          Label("消息", systemImage: "envelope")
        }
        .tag("inbox")
        .disabled(currentUser.accessToken == nil)
      }
      
      Section(header: Text("所有节点")) {
             if isLoading {
                 HStack {
                     Spacer()
                     ProgressView()
                     Spacer()
                 }
             } else {
                 if let nodeList = nodeList {
                   ForEach(nodeList) { node in
                     NavigationLink(node.title ?? "") {
                       TopicListView(nodeName: node.name)
                     }
                   }
                 }
             }
      }
    }
    .listStyle(.sidebar)
    .toolbar {
      ToolbarItemGroup {
        Button(action:{
          NSApp.keyWindow?.initialFirstResponder?.tryToPerform(
                     #selector(NSSplitViewController.toggleSidebar(_:)), with: nil)
        }, label: {
          Image(systemName: "sidebar.left")
        })
      }
    }
    .onAppear {
      Task {
        self.nodeList = try await v2ex.nodesList()
        self.isLoading = false
      }
    }
  }
}

struct Sidebar_Previews: PreviewProvider {
  static var previews: some View {
    SidebarView()
  }
}
