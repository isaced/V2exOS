//
//  CommentListView.swift
//  V2exOS
//
//  Created by isaced on 2022/7/31.
//

import SwiftUI
import V2exAPI
import MarkdownUI
import Kingfisher

struct CommentListView: View {
  
  var commentList: [V2Comment]
  
  var body: some View {
    Label("\(commentList.count) 条回复", systemImage: "bubble.middle.bottom.fill")
    
    ForEach(commentList) { comment in
      
      Divider()
      
      HStack {
        if let avatarUrl = comment.member.avatarLarge {
          KFImage.url(URL(string: avatarUrl))
            .fade(duration: 0.25)
            .frame(width: 40, height: 40)
            .mask(RoundedRectangle(cornerRadius: 8))
        }
        
        VStack(alignment: .leading, spacing: 6) {
          HStack {
            if let username = comment.member.username {
              Text(username)
                .fontWeight(.bold)
            }
            
            if let created = comment.created {
              Text(Date(timeIntervalSince1970: TimeInterval(created)).fromNow())
            }
          }
          .foregroundColor(.gray)
          
          Markdown(comment.content)
            .font(.body)
          
        }
      }
    }
    
  }
}

struct CommentListView_Previews: PreviewProvider {
  static var previews: some View {
    let commentList = [
      PreviewData.comment,
      PreviewData.comment,
      PreviewData.comment
    ]
    CommentListView(commentList: commentList)
      .previewLayout(.fixed(width: 400, height: 200))
  }
}

