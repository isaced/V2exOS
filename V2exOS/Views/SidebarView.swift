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
    @Environment(\.openURL) private var openURL
    
    @State var nodeList: [V2Node]?
    @State var isLoading = true
    
    @State var searchText: String = ""
    @State private var selectionNodeName: String? = nil
    
    var nodeListFilter: [V2Node]? {
        print(searchText.lowercased())
        if let filtred = nodeList?.filter({ $0.title!.lowercased().contains(searchText.lowercased()) }) {
            return (filtred.count > 6) ? filtred.prefix(upTo: 6).shuffled() : filtred
        }
        return nil
    }
    
    var body: some View {
        ScrollViewReader { scrollViewReader in
            List {
                Section(header: Text("Home")) {
                    NavigationLink(destination: TopicListView(nodeName: NodeNameHot)) {
                        Label("最热", systemImage: "flame")
                    }
                    NavigationLink(destination: TopicListView(nodeName: NodeNameAll)) {
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
                                NavigationLink(destination: TopicListView(nodeName: node.name),
                                               tag: node.name,
                                               selection: $selectionNodeName) {
                                    Text(node.title ?? "")
                                }
                            }
                        }
                    }
                }
            }
            .listStyle(.sidebar)
            .toolbar {
                ToolbarItemGroup {
                    Button(action: {
                        NSApp.keyWindow?.initialFirstResponder?.tryToPerform(
                            #selector(NSSplitViewController.toggleSidebar(_:)), with: nil)
                    }, label: {
                        Image(systemName: "sidebar.left")
                    })
                }
            }
            .searchable(text: $searchText, placement: .toolbar, prompt: Text("Google Search")) {
                if let nodeListFilter, nodeListFilter.count > 0 {
                    Text("节点")
                    
                    Divider()
                    
                    ForEach(nodeListFilter) { node in
                        Button("    \(node.title!)") {
                            selectionNodeName = node.name
                            searchText = ""
                            scrollViewReader.scrollTo(node.id)
                        }
                    }
                    
                    Divider()
                }
                
                Button("Google \(searchText)") {
                    let query = searchText.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
                    openURL(URL(string: "https://www.google.com/search?q=site:v2ex.com/t%20\(query!)")!)
                    searchText = ""
                }
            }
            .onFirstAppear {
                Task {
                    self.nodeList = try await v2ex.nodesList()
                    self.isLoading = false
                }
            }
        }
    }
}

struct Sidebar_Previews: PreviewProvider {
    static var previews: some View {
        SidebarView()
    }
}
