//
//  TopicDetailView.swift
//  V2exOS
//
//  Created by isaced on 2022/7/24.
//

import SwiftUI
import V2exAPI
import MarkdownUI

struct TopicDetailView: View {
  
  var topic: V2Topic
  @State var commentList: [V2Comment]?
  
  var body: some View {
    List {
      VStack(alignment: .leading, spacing: 5) {
        Text(topic.title ?? "" )
          .font(.title)
          .lineLimit(3)
        
        HStack(alignment: .bottom, spacing: 20) {
          
          HStack(alignment: .bottom, spacing: 5) {
            Image(systemName: "person.circle")
            Text(topic.member?.username ?? "")
          }
          
          HStack(alignment: .bottom, spacing: 5) {
            Image(systemName: "clock")
            if let created = topic.created {
              Text(Date(timeIntervalSince1970: TimeInterval(created)).fromNow())
            }
          }
          
        }.foregroundColor(Color(NSColor.secondaryLabelColor))
        
        Spacer()
        
        Markdown(topic.content ?? "")
          .font(.body)
          .fixedSize(horizontal: false, vertical: true)
      }
      
      if let commentList = commentList{
        Spacer()
        CommentListView(commentList: commentList)
      }
    }
    .foregroundColor(Color(NSColor.labelColor))
    .onAppear(perform: loadComments)
  }
  
  func loadComments(){
    Task {
      let res = try await v2ex.replies(topicId: topic.id)
      commentList = res?.result
    }
  }
}

struct TopicDetailView_Previews: PreviewProvider {
  static var previews: some View {
    TopicDetailView(topic: PreviewData.topic,
                    commentList: [
                      PreviewData.comment,
                      PreviewData.comment,
                      PreviewData.comment
                    ])
    .previewLayout(.fixed(width: 300, height: .infinity))
  }
}

