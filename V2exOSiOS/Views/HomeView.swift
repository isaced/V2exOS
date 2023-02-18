//
//  HomeView.swift
//  V2exOSiOS
//
//  Created by isaced on 2023/2/10.
//

import PagerTabStripView
import SwiftUI

struct HomeView: View {
    let nodes = [
        ["最热", NodeNameHot],
        ["全部", NodeNameAll],
        ["分享创造", "create"],
        ["分享发现", "share"],
        ["酷工作", "jobs"],
        ["问与答", "qna"],
    ]

    var body: some View {
        NavigationStack {
            PagerTabStripView {
                ForEach(0 ..< nodes.count, id: \.self) { index in
                    let item = nodes[index]
                    let title = item[0]
                    let nodeName = item[1]

                    TopicListView(nodeName: nodeName)
                        .pagerTabItem(tag: index) {
                            TitleNavBarItem(title: title)
                        }
                }

                NodeListView()
                    .pagerTabItem(tag: 9999) {
                        TitleNavBarItem(title: "其他版块")
                    }
            }
            .pagerTabStripViewStyle(.scrollableBarButton(tabItemSpacing: 20))
            .toolbar(.hidden, for: .automatic)
        }
    }
}

struct TitleNavBarItem: View {
    let title: String

    var body: some View {
        VStack {
            Text(title)
                .font(.subheadline)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
