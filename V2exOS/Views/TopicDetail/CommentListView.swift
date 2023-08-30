//
//  CommentListView.swift
//  V2exOS
//
//  Created by isaced on 2022/7/31.
//

import Kingfisher
import MarkdownUI
import SwiftUI
import V2exAPI

struct CommentListView: View {
    @EnvironmentObject private var settingsConfig: SettingsConfig
    
    var commentCount: Int?
    var commentList: [V2Comment]?
    var topic: V2Topic
    
    var body: some View {
        VStack(alignment: .leading) {
            Spacer()
            
            Label("\(commentCount ?? 0) 条回复", systemImage: "bubble.middle.bottom.fill")
                .foregroundColor(.secondary)
#if os(iOS)
                .listRowSeparator(.hidden)
#endif
#if os(tvOS)
.focusable()
#endif
            
            if let commentList {
                LazyVStack(alignment: .leading) {
                    ForEach(0 ..< commentList.count, id: \.self) { index in
                        let comment = commentList[index]
                        
                        Divider()
                            .overlay(Color("DividerColor"))
                        
                        HStack(alignment: .top) {
                            if let avatarUrl = comment.member.avatarLarge {
                                KFImage.url(URL(string: avatarUrl))
                                    .resizable()
                                    .fade(duration: 0.25)
                                    .scaledToFit()
#if os(tvOS)
                                    .frame(width: 80, height: 80)
#else
                                    .frame(width: 40, height: 40)
#endif
                                    .mask(RoundedRectangle(cornerRadius: 4))
                            }
                            
                            VStack(alignment: .leading, spacing: 6) {
                                HStack {
                                    if let username = comment.member.username {
                                        UserName(username)
                                    }

                                    if comment.member.id == 1 {
                                        CommentUserTagView(.mod)
                                    }
                                    
                                    if comment.member.id == topic.member?.id {
                                        CommentUserTagView(.op)
                                    }
                                    
                                    Text(Date(timeIntervalSince1970: TimeInterval(comment.created)).fromNow())
                                    
                                    Spacer()
                                    
                                    Text("#\(index + 1)")
                                }
                                .foregroundColor(.secondary)
                                
                                Text(LocalizedStringKey(comment.content))
                                    .foregroundColor(.label)
#if os(macOS)
                                    .font(.system(size: settingsConfig.fontSize - 1))
#endif
                            }
                        }
#if os(tvOS)
                        .focusable()
#endif
                    }
                }
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}

struct CommentListView_Previews: PreviewProvider {
    static var previews: some View {
        let commentList = [
            PreviewData.comment,
            PreviewData.comment,
            PreviewData.comment
        ]
        CommentListView(commentList: commentList, topic: V2Topic(id: 1))
            .previewLayout(.fixed(width: 400, height: 200))
    }
}
