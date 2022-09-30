//
//  UserName.swift
//  V2exOS
//
//  Created by m on 2022/9/30.
//

import Foundation
import SwiftUI

struct UserName: ViewModifier {
  var username: String
  func body(content: Content) -> some View {
    Text(username)
      .foregroundColor(.secondary)
      .fontWeight(.bold)
      .onTapGesture {
        if let url = URL(string: "https://www.v2ex.com/member/\(username)") {
          NSWorkspace.shared.open(url)
        }
      }
  }
}


extension Text {
  func linkName(_ text: String) -> some View {
    modifier(UserName(username: text))
  }
}
