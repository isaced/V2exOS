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
    
    @EnvironmentObject private var settingsConfig: SettingsConfig
    
    var topic: V2Topic
    
    @State var commentList: [V2Comment]?
    @State var isCommentLoading = true
    
    var body: some View {
        List {
            VStack(alignment: .leading, spacing: 5) {
                Text(topic.title ?? "" )
                    .font(.title)
                    .lineLimit(3)
#if os(tvOS)
                    .focusable()
#endif
                
                HStack(alignment: .bottom, spacing: 20) {
                    
                    if let authorName = topic.member?.username {
                        HStack(alignment: .bottom, spacing: 5) {
                            Image(systemName: "person.circle")
                            UserName(authorName)
                        }
                    }
                    
                    HStack(alignment: .bottom, spacing: 5) {
                        Image(systemName: "clock")
                        if let created = topic.created {
                            Text(Date(timeIntervalSince1970: TimeInterval(created)).fromNow())
                        }
                    }
#if !os(tvOS)
                    Link(destination: URL(string: "https://www.v2ex.com/t/\(topic.id)")!) {
                        Image(systemName: "safari")
                        Text("在网页中打开")
                    }
#endif
                    
                }
                .foregroundColor(.secondary)
                
                Spacer()
                
                Markdown(topic.content ?? "")
#if !os(tvOS)
                    .markdownStyle(MarkdownStyle(font: .system(size: settingsConfig.fontSize)))
#endif
#if os(tvOS)
                    .focusable()
#endif
                    .fixedSize(horizontal: false, vertical: true)
                
            }
            
            Spacer()
            
            CommentListView(commentCount: topic.replies, commentList: commentList)
            
            if isCommentLoading {
                Spacer()
                HStack {
                    Spacer()
                    ProgressView()
                    Spacer()
                }
            }
        }
        .task {
            loadComments(page: 1)
        }
    }
    
    func loadComments(page: Int) {
        Task {
            do {
                let res = try await v2ex.repliesAll(topicId: topic.id)
                commentList = res
            } catch {
                print(error)
            }
            
            isCommentLoading = false
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

