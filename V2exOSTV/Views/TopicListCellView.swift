//
//  TopicListCellView.swift
//  V2exOSTV
//
//  Created by isaced on 2023/1/30.
//

import Kingfisher
import SwiftUI
import V2exAPI

struct TopicListCellView: View {
    var topic: V2Topic
    var action: ((V2Topic) -> Void)? = nil
    
    @State private var member: V2Member? = nil
    
    var body: some View {
        Button {
            action?(topic)
        } label: {
            HStack {
                let avatarUrl = (topic.member ?? member)?.avatarLarge
                
                KFImage.url(URL(string: avatarUrl ?? ""))
                    .resizable()
                    .fade(duration: 0.25)
                    .scaledToFit()
                    .background(.gray)
                    .frame(width: 100, height: 100)
                    .mask(RoundedRectangle(cornerRadius: 8))
                
                VStack(alignment: .leading, spacing: 6) {
                    Text(topic.title ?? "")
                        .lineLimit(2)
                    
                    HStack(spacing: 20) {
                        if let username = topic.member?.username ?? topic.lastReplyBy {
                            Text(username)
                            Text("•")
                        }
                        
                        if let lastModified = topic.lastModified {
                            Text(Date(timeIntervalSince1970: TimeInterval(lastModified)).fromNow())
                        }
                    }
                    .foregroundColor(.gray)
                }
                
                if let replies = topic.replies {
                    Spacer()
                    Text(String(replies))
                        .foregroundColor(.white)
                        .padding(EdgeInsets(top: 0, leading: 10, bottom: 0, trailing: 10))
                        .background(RoundedRectangle(cornerRadius: 4).fill(.gray))
                }
            }
            .foregroundColor(Color(.label))
            .task {
                if let name = topic.lastReplyBy {
                    member = try? await v2ex.memberShow(username: name)
                }
            }
        }
    }
}

struct TopicListCellView_Previews: PreviewProvider {
    static var previews: some View {
        let member = V2Member(id: 79764,
                              username: "ljsh093",
                              url: "https://www.v2ex.com/u/ljsh093",
                              website: nil,
                              twitter: nil,
                              psn: nil,
                              github: nil,
                              btc: nil,
                              location: nil,
                              tagline: nil,
                              bio: nil,
                              avatarMini: "https://cdn.v2ex.com/avatar/ff10/6e6c/79764_mini.png?m=1657684598",
                              avatarNormal: "https://cdn.v2ex.com/avatar/ff10/6e6c/79764_normal.png?m=1657684598",
                              avatarLarge: "https://cdn.v2ex.com/avatar/ff10/6e6c/79764_large.png?m=1657684598",
                              created: 1414903742,
                              lastModified: 1657684598)
        let topic = V2Topic(id: 1,
                            node: nil,
                            member: member,
                            lastReplyBy: "ljsh093",
                            lastTouched: 1658649862,
                            title: "万行原生 Javascript 该如何维护？",
                            url: "https://www.v2ex.com/t/868366",
                            created: 1658649797,
                            deleted: 0,
                            content: "想拆成 Typescript 模块化，有没有什么指路手册？",
                            contentRendered: "<p>想拆成 Typescript 模块化，有没有什么指路手册？</p>\n",
                            lastModified: 1658649797,
                            replies: 1111)
        TopicListCellView(topic: topic)
            .previewLayout(.fixed(width: 320, height: 200))
    }
}
