//
//  SidebarView.swift
//  V2exOS
//
//  Created by isaced on 2022/7/24.
//

import SwiftUI
import V2exAPI

struct SidebarView: View {
  
  @State var nodeList : [V2Node]?
  
  var body: some View {
    List() {
      Section(header: Text("Home")) {
        NavigationLink("全部") {
          TopicListView(nodeName: "ALL")
        }
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
