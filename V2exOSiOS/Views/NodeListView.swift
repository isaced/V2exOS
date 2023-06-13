//
//  NodeListView.swift
//  V2exOSiOS
//
//  Created by isaced on 2023/2/11.
//

import SwiftUI
import V2exAPI

struct NodeListView: View {
    @State var nodeList: [V2Node] = []
    @State var isLoading = true

    var body: some View {
        List(nodeList) { node in
            NavigationLink(destination: TopicListView(nodeName: node.name)) {
                Text(node.title ?? "")
            }
        }
        .overlay {
            if isLoading {
                ProgressView()
            }
        }
        .onFirstAppear {
            Task {
                self.isLoading = true
                do {
                    self.nodeList = try await v2ex.nodesList() ?? []
                } catch {
                    print(error)
                }
                self.isLoading = false
            }
        }
    }
}

struct NodeListView_Previews: PreviewProvider {
    static var previews: some View {
        NodeListView()
    }
}
