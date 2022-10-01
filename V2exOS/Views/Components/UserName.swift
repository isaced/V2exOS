//
//  UserName.swift
//  V2exOS
//
//  Created by m on 2022/9/30.
//

import Foundation
import SwiftUI

struct UserName: View {
  
  var username: String
  
  init(_ username: String) {
    self.username = username
  }
  
  var body: some View {
    Button {
      if let url = URL(string: "https://www.v2ex.com/member/\(username)") {
        NSWorkspace.shared.open(url)
      }
    } label: {
      Text(username)
        .foregroundColor(.secondary)
        .fontWeight(.bold)
        .onHover { inside in
          if inside {
            NSCursor.pointingHand.push()
          } else {
            NSCursor.pop()
          }
        }
    }
    .buttonStyle(PlainButtonStyle())
  }
}

struct UserName_Previews: PreviewProvider {
  static var previews: some View {
    UserName("isaced")
  }
}
