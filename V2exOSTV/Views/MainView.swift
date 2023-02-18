//
//  MainView.swift
//  V2exOSTV
//
//  Created by isaced on 2023/1/30.
//

import SwiftUI
import V2exAPI

struct MainView: View {
    var nodeName: String
    @State private var selectedTopic: V2Topic? = nil
    
    var body: some View {
        GeometryReader { proxy in
            let halfWidth = proxy.size.width / 2.0 - 80
            
            HStack(alignment: .top) {
                TopicListView(nodeName: nodeName, selectedTopic: $selectedTopic)
                    .frame(width: halfWidth)
                
                Divider()
                
                Group {
                    if let selectedTopic {
                        TopicDetailView(topic: selectedTopic)
                    }
                }
                .frame(width: halfWidth)
            }
        }
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView(nodeName: NodeNameHot)
    }
}
