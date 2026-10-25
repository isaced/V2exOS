//
//  TopicDetailView.swift
//  V2exOS
//
//  Created by isaced on 2022/7/24.
//
import SwiftUI
import V2exAPI
#if os(tvOS)
import MarkdownUI
#else
import RichText
#endif


struct TopicDetailView: View {
    @EnvironmentObject private var settingsConfig: SettingsConfig
    @Environment(\.openURL) private var openURL

    var topic: V2Topic
    
    @State var commentList: [V2Comment]?
    @State var isCommentLoading = true
    
    var body: some View {
        ScrollView {
            VStack {
                VStack(alignment: .leading, spacing: 5) {
                    Text(topic.title ?? "")
                        .font(.largeTitle)
                        .lineLimit(3)
                        .multilineTextAlignment(.leading)
                        .foregroundColor(.label)
#if os(tvOS)
                        .focusable()
#else
                        .link("https://www.v2ex.com/t/\(topic.id)")
#endif
                        .hoverPointCursor()
                    
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
                    }
                    .foregroundColor(.secondary)
                    
                    Spacer()
                    
                    Divider()
                        .overlay(Color("DividerColor"))
                    
                    Spacer()
                    
#if os(tvOS)
                    Markdown(topic.content ?? "")
                        .lineSpacing(6)
                        .focusable()
                        .fixedSize(horizontal: false, vertical: true)
#else
                    RichText(html: topic.contentRendered ?? "",
                             configuration: Configuration(
                                 customCSS: richTextCSS
                             ))
                        .fixedSize(horizontal: false, vertical: true)
#endif
                }
#if os(iOS)
                .listRowSeparator(.hidden)
#endif
                Spacer()
                
                CommentListView(commentCount: topic.replies, commentList: commentList, topic: topic)
                    .font(.system(size: settingsConfig.fontSize - 2))
                
                if isCommentLoading {
                    HStack {
                        Spacer()
                        ProgressView()
                        Spacer()
                    }
#if os(iOS)
                    .listRowSeparator(.hidden)
#endif
                }
            }
            .hiddeScrollContentBackground()
#if os(iOS)
                .padding(EdgeInsets(top: 20, leading: 10, bottom: 20, trailing: 10))
#else
                .padding(30)
#endif
        }
#if os(iOS)
        .listStyle(.plain)
        .navigationBarTitleDisplayMode(.inline)
#endif
#if !os(tvOS)
        .toolbar {
            ToolbarItem {
                Button {
                    openURL(URL(string: "https://www.v2ex.com/t/\(topic.id)")!)
                } label: {
                    Image(systemName: "safari")
                }
                .help("在浏览器中打开")
            }
        }
#endif
        .onFirstAppear {
            loadComments(page: 1)
        }
#if os(macOS)
        .hiddeScrollContentBackground()
#endif
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

    // flow-root 使容器成为 BFC，阻止首尾子元素 margin 塌陷到容器外，否则 offsetHeight 偏小导致内容被裁切
    private var richTextCSS: String {
        var css = """
        #NuPlay_RichText { display: flow-root; }
        """
#if os(macOS)
        css += """
        #NuPlay_RichText { font-size: \(settingsConfig.fontSize)px; }
        """
#endif
        return css
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
                        .environmentObject(SettingsConfig.shared)
                        .previewLayout(.fixed(width: 300, height: .infinity))
    }
}
