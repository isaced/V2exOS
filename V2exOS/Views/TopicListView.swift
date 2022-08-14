//
//  TopicList.swift
//  V2exOS
//
//  Created by isaced on 2022/7/24.
//

import SwiftUI
import V2exAPI

struct TopicListView: View {
  
  var nodeName: String
  
  @State var isLoading = true
  @State var topics: [V2Topic]?
  @State var page = 1
  @State var error: Error?
  
  var body: some View {
    NavigationView{
      if isLoading {
        ProgressView()
          .frame(minWidth: 400)
      }else{
        List {
          if let topics = topics {
            ForEach(topics) { topic in
              TopicListCellView(topic: topic)
            }
            
            if topics.count > 0 && nodeName != "ALL" {
              ProgressView()
                .onAppear {
                  Task {
                    await self.loadData(page: self.page + 1)
                  }
                }
            }
          }
          
        }
        .listStyle(.inset)
        .frame(minWidth: 400, idealWidth: 500, maxWidth: 700)
        .foregroundColor(.black)
      }
    }
    .task {
      await loadData()
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
      var topics : [V2Topic]? = nil
      
      if nodeName == "ALL" {
        topics = try await v2ex.latestTopics()
      }else{
        topics = try await v2ex.topics(nodeName: nodeName, page: page)?.result
      }
      
      if page == 1 {
        self.topics = topics
      }else{
        self.page = page
        if let topics = topics {
          self.topics?.append(contentsOf: topics)
        }
      }
      
    } catch {
      self.error = error;
      print(error)
    }
    
    isLoading = false
  }
}
