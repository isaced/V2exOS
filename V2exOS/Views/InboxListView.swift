//
//  InboxListView.swift
//  V2exOS
//
//  Created by isaced on 2022/8/11.
//

import SwiftUI
import V2exAPI

struct InboxListView: View {
    @EnvironmentObject private var currentUser: CurrentUserStore
    
    @State var notificationList: [V2Notification] = []
    
    var body: some View {
        VStack {
            if let _ = currentUser.accessToken {
                List {
                    ForEach(notificationList) { noti in
                        VStack(alignment: .leading) {
                            HStack {
                                Text(noti.text?.htmlToString() ?? "")
                                    .font(.body)
                                
                                Text(noti.member?.username ?? "")
                                    .font(.body)
                                
                                if let created = noti.created {
                                    Text(Date(timeIntervalSince1970: TimeInterval(created)).fromNow())
                                }
                            }
                            
                            if let payload = noti.payloadRendered?.htmlToString(), payload.count > 0 {
                                Text(payload)
                                    .font(.body)
                                    .padding(EdgeInsets(top: 4, leading: 10, bottom: 4, trailing: 10))
                            }
                        }
                        
                        Divider()
                    }
                }.listRowInsets(EdgeInsets(top: 10, leading: 10, bottom: 10, trailing: 10))
                
            } else {
                Text("请先登录")
            }
        }.onAppear {
            Task {
                do {
                    if let res = try await v2ex.notifications(page: 1) {
                        if let list = res.result {
                            notificationList.append(contentsOf: list)
                        }
                    }
                } catch {
                    print(error)
                }
            }
        }
    }
}

struct InboxListView_Previews: PreviewProvider {
    static var previews: some View {
        InboxListView()
    }
}
