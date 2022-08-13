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
  
  @State var isLoading = false
  @State var topics: [V2Topic]?
  @State var page = 1
  
  var body: some View {
    NavigationView{
      List {
        if isLoading {
          VStack(alignment: .center) {
            ProgressView()
          }
        }else{
          if let topics = topics {
            ForEach(topics) { topic in
              TopicListCellView(topic: topic)
            }
          }
          
          if topics != nil && nodeName != "ALL" {
            ProgressView()
              .task {
                await self.onNextPage()
              }
          }
        }
      }
      .listStyle(.inset)
      .frame(minWidth: 400, idealWidth: 500, maxWidth: 700)
      .foregroundColor(.black)
      .task {
        await loadData()
      }
    }
  }
  
  func loadData() async {
    isLoading = true
    
    do {
      var topics : [V2Topic]? = nil
      
      if nodeName == "ALL" {
        topics = try await v2ex.latestTopics()
      }else{
        topics = try await v2ex.topics(nodeName: nodeName)?.result
      }
      self.topics = topics
      
    } catch {
      print(error)
    }
    
    isLoading = false
  }
  
  func onNextPage() async {
    isLoading = true
    
    do {
      if nodeName != "ALL" {
        if let topics = try await v2ex.topics(nodeName: nodeName, page: page + 1)?.result {
          page = page + 1
          self.topics?.append(contentsOf: topics)
        }
      }
    } catch {}
    
    isLoading = false
  }
}
