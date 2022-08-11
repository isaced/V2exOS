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
  @State var isAccessTokenChecked: Bool? = nil
  
  var body: some View {
    Text("profile")
    Form {
      HStack {
        TextField("Personal Access Token", text: $accessToken)
        
        if let isAccessTokenChecked = isAccessTokenChecked {
          if isAccessTokenChecked {
            Image(systemName: "checkmark.circle.fill")
              .foregroundColor(.green)
          }else{
            Image(systemName: "exclamationmark.circle.fill")
              .foregroundColor(.red)
          }
        }
      }
      
      Button {
        saveToken()
      } label: {
        Text("保存")
      }
    }
    .frame(maxWidth:300)
    .onAppear {
      accessToken = currentUser.accessToken ?? ""
    }
  }
  
  func saveToken() {
    Task {
      isAccessTokenChecked =  await currentUser.checkToken(token: accessToken)
      if isAccessTokenChecked != nil {
        currentUser.saveToken(token: accessToken)
      }
    }
  }
}


struct ProfileView_Previews: PreviewProvider {
  static var previews: some View {
    ProfileView()
  }
}
