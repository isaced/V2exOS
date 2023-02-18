//
//  TopicList.swift
//  V2exOS
//
//  Created by isaced on 2022/7/24.
//

import Kingfisher
import SwiftUI
import V2exAPI

struct TopicListView: View {
    @EnvironmentObject private var currentUser: CurrentUserStore
    
    var nodeName: String
    
    @State var isLoading = true
    @State var topics: [V2Topic]?
    @State var page = 1
    @State var error: Error?
    @State var _node: V2Node?
    
    var body: some View {
        NavigationView {
            List {
                if let topics = topics {
                    ForEach(topics) { topic in
                        TopicListCellView(topic: topic)
                    }
                    
                    if topics.count > 0 && nodeName != NodeNameAll && nodeName != NodeNameHot {
                        HStack {
                            Spacer()
                            ProgressView()
                                .onAppear {
                                    Task {
                                        await self.loadData(page: self.page + 1)
                                    }
                                }
                            Spacer()
                        }
                    }
                }
            }
            .overlay {
                if isLoading {
                    ProgressView()
                }
            }
            .listStyle(.inset)
            .frame(minWidth: 400, idealWidth: 500)
            .foregroundColor(.black)
            .onFirstAppear {
                print("onFirstAppear....")
                Task {
                    await loadData()
                }
            }
        }
        .navigationTitle(_node?.title ?? "V2exOS")
#if os(iOS)
            .navigationViewStyle(.stack)
#endif
#if os(macOS)
.navigationSubtitle(_node?.header ?? "")
#endif
.toolbar {
    KFImage.url(URL(string: _node?.avatarNormal ?? ""))
        .resizable()
        .fade(duration: 0.25)
        .frame(width: 20, height: 20)
        .mask(RoundedRectangle(cornerRadius: 8))
}
    }
    
    func loadData(page: Int = 1) async {
        print("TopcListView loadData... \(nodeName)")
        
        if error != nil {
            return
        }
        
        if page == 1 {
            isLoading = true
        }
        
        do {
            var topics: [V2Topic]?
            
            if nodeName == NodeNameAll {
                topics = try await v2ex.latestTopics()
            } else if nodeName == NodeNameHot {
                topics = try await v2ex.hotTopics()
            } else {
                if currentUser.user == nil && (self.topics?.isEmpty ?? true) {
                    topics = try await v2ex.topics(nodeName: nodeName)
                } else {
                    topics = try await v2ex.topics(nodeName: nodeName, page: page)?.result
                }
                _node = try await v2ex.nodesShow(name: nodeName)
            }
            
            if page == 1 {
                self.topics = topics
            } else {
                self.page = page
                if let topics = topics {
                    self.topics?.append(contentsOf: topics)
                }
            }
            
        } catch {
            self.error = error
            print(error)
        }
        
        isLoading = false
    }
}
