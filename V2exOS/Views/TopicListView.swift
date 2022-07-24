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
  
  var body: some View {
    NavigationView{
      List {
        if isLoading {
          VStack {
            ProgressView()
          }
        }
        
        if let topics = topics {
          ForEach(topics) { topic in
            TopicListCellView(topic: topic)
          }
        }
      }
      .listStyle(.inset)
      .frame(minWidth: 400, idealWidth: 500, maxWidth: 700)
      .foregroundColor(.black)
      .onAppear {
        Task {
          isLoading = true
          
          var topics : [V2Topic]? = nil
          
          if nodeName == "ALL" {
            topics = try await v2ex.latestTopics()
          }else{
            topics = try await v2ex.topics(nodeName: nodeName)?.result
          }
          self.topics = topics
          
          isLoading = false
        }
      }
    }}
}
