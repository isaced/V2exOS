//
//  TopicList.swift
//  V2exOS
//
//  Created by isaced on 2022/7/24.
//

import SwiftUI
import V2exAPI

struct TopicListView: View {
    @EnvironmentObject private var currentUser: CurrentUserStore
    @EnvironmentObject private var settingsConfig: SettingsConfig
    @Environment(\.scenePhase) private var scenePhase

    var nodeName: String

    @State var isLoading = true
    @State var topics: [V2Topic]?
    @State var page = 1
    @State var error: Error?
    @State var _node: V2Node?
    @State var selectTopic: V2Topic? = nil
    @State var lastRefreshDate: Date?
    
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
            #if os(macOS)
            .toolbar {
                ToolbarItem {
                    Button {
                        Task {
                            await refresh()
                        }
                    } label: {
                        Image(systemName: "arrow.clockwise")
                    }
                    .keyboardShortcut("r", modifiers: .command)
                    .help("刷新列表 (Command + R)")
                }
            }
            #endif
            .onChange(of: scenePhase) { phase in
                if phase == .active {
                    autoRefreshIfNeeded()
                }
            }
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
    }
    
    /// 切回 App 时，距上次刷新超过间隔则自动刷新
    private func autoRefreshIfNeeded() {
        guard settingsConfig.autoRefreshOnActive, !isLoading else { return }
        if let lastRefreshDate, Date().timeIntervalSince(lastRefreshDate) < TopicListAutoRefreshInterval {
            return
        }
        Task {
            await refresh()
        }
    }

    /// 手动刷新，回到第一页并重新加载
    func refresh() async {
        error = nil
        page = 1
        await loadData()
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
                lastRefreshDate = Date()
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
