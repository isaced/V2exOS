//
//  HomeView.swift
//  V2exOSiOS
//
//  Created by isaced on 2023/2/10.
//

import SwiftUI
import PagerTabStripView

struct HomeView: View {
    
    let nodes = [
        ["最热", NodeNameHot],
        ["全部", NodeNameAll],
        ["技术", "tech"],
        ["创意", "creative"],
        ["好玩", "play"],
        ["Apple", "apple"],
        ["酷工作", "jobs"],
        ["交易", "deals"],
        ["城市", "city"],
        ["问与答", "qna"],
        ["R2", "r2"],
    ]
    
    var body: some View {
        NavigationStack {
            PagerTabStripView() {
                ForEach(0..<nodes.count, id: \.self) { index in
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
                .foregroundColor(Color.gray)
                .font(.subheadline)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.white)
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
