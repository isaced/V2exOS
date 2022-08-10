//
//  ProfileView.swift
//  V2exOS
//
//  Created by isaced on 2022/8/10.
//

import SwiftUI

struct ProfileView: View {
  
  @EnvironmentObject private var currentUser: CurrentUserStore
  
  @State var accessToken: String = ""
  
  var body: some View {
    Text("profile")
    Form {
      TextField("Personal Access Token", text: $accessToken)
      
      Button {

        currentUser.saveToken(token: accessToken)
      } label: {
        Text("保存")
      }
    }
    .frame(maxWidth:300)
    .onAppear {
      accessToken = currentUser.accessToken ?? ""
    }
  }
  
}


struct ProfileView_Previews: PreviewProvider {
  static var previews: some View {
    ProfileView()
  }
}
