//
//  TopicListView.swift
//  V2exOSTV
//
//  Created by isaced on 2023/1/30.
//

import SwiftUI
import V2exAPI

struct TopicListView: View {
    public var nodeName: String
    @Binding public var selectedTopic: V2Topic?
    
    @State private var isLoading = true
    @State private var topics: [V2Topic]?
    @State private var page = 1
    @State var error: Error?
    
    var body: some View {
        List {
            if let topics = topics {
                ForEach(topics) { topic in
                    TopicListCellView(topic: topic) { selTopic in
                        selectedTopic = selTopic
                    }
                }
            }
        }
        .overlay {
            if isLoading {
                ProgressView()
            }
        }
        .onFirstAppear {
            Task {
                await loadData()
            }
        }
        .onPlayPauseCommand {
            Task {
                topics = nil
                page = 1
                selectedTopic = nil
                await loadData()
            }
        }
    }
    
    func loadData(page: Int = 1) async {
        if error != nil {
            return
        }
        
        if page == 1 {
            isLoading = true
        }
        
        do {
            print("load Data...")
            var topics: [V2Topic]?
            
            if nodeName == NodeNameAll {
                topics = try await v2ex.latestTopics()
            } else if nodeName == NodeNameHot {
                topics = try await v2ex.hotTopics()
                
            } else {
                topics = try await v2ex.topics(nodeName: nodeName, page: page)?.result
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

struct TopicListView_Previews: PreviewProvider {
    static var previews: some View {
        TopicListView(nodeName: NodeNameHot, selectedTopic: .constant(PreviewData.topic))
    }
}
