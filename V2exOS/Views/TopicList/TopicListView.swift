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
    @State var selectTopic: V2Topic? = nil
    
    func listRowBackgroundColor(_ topic: V2Topic) -> Color {
        if selectTopic == topic {
            return Color("ListRowHighlightBackgroundColor")
        }
        return Color("ContentBackgroundColor")
    }
    
    var body: some View {
        NavigationView {
            List {
                if let topics = topics {
                    ForEach(topics) { topic in
                        #if os(iOS)
                        Button {
                            selectTopic = topic
                        } label: {
                            TopicListCellView(topic: topic)
                        }
                        #else
                        NavigationLink(tag: topic, selection: $selectTopic) {
                            TopicDetailView(topic: topic)
                        } label: {
                            TopicListCellView(topic: topic)
                        }
                        .listRowBackground(listRowBackgroundColor(topic))
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                        #endif
                    }
                    
                    if topics.count > 0 && nodeName != NodeNameAll && nodeName != NodeNameHot {
                        HStack {
                            Spacer()
                            // 已登陆或列表为空时才加载数据（非登陆用户 API 限制只能取第一页）
                            if currentUser.user != nil || topics.isEmpty {
                                ProgressView()
                                    .onAppear {
                                        Task {
                                            await self.loadData(page: self.page + 1)
                                        }
                                    }
                            } else {
                                #if os(macOS)
                                Text("登录后可查看更多内容")
                                    .font(.footnote)
                                    .foregroundColor(.secondary)
                                    .padding(20)
                                #endif
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
            .listStyle(.plain)
            .frame(minWidth: 400, idealWidth: 500)
            .foregroundColor(.black)
//            .removeBackground()
//            .background(Color("ContentBackgroundColor"))
            .onFirstAppear {
                print("onFirstAppear....")
                Task {
                    await loadData()
                }
            }
        }
        #if os(iOS)
        .navigationTitle(_node?.title ?? "")
        .navigationViewStyle(.stack)
        .navigationBarTitleDisplayMode(.inline)
        .sheet(item: $selectTopic) { topic in
            TopicDetailView(topic: topic)
        }
        #endif
        #if os(macOS)
        .navigationTitle(_node?.title ?? "V2exOS")
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
