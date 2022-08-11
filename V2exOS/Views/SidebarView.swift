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
  
  var body: some View {
    List() {
      
      Section(header: Text("Home")) {
        NavigationLink(destination: TopicListView(nodeName: "ALL")) {
          Label("全部", systemImage: "chart.bar")
        }
      }
      
      Section(header: Text("账户")) {
        NavigationLink(destination: ProfileView()) {
          Label("登录", systemImage: "person.crop.circle")
        }.tag("profile")
        NavigationLink(destination: InboxListView()) {
          Label("消息", systemImage: "envelope")
        }
        .tag("inbox")
        .disabled(currentUser.accessToken == nil)
      }
      
      Section(header: Text("所有节点")) {
        if let nodeList = nodeList {
          ForEach(nodeList) { node in
            NavigationLink(node.title ?? "") {
              TopicListView(nodeName: node.name)
            }
          }
        }
      }
    }
    .listStyle(.sidebar)
    .toolbar {
      ToolbarItemGroup {
        Button(action:{}, label: {
          Image(systemName: "sidebar.left")
        })
      }
    }
    .onAppear {
      Task {
        self.nodeList = try await v2ex.nodesList()
      }
    }
  }
}

struct Sidebar_Previews: PreviewProvider {
  static var previews: some View {
    SidebarView()
  }
}
