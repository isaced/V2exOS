//
//  ProfileView.swift
//  V2exOS
//
//  Created by isaced on 2022/8/10.
//

import Kingfisher
import SwiftUI

struct ProfileView: View {
    @EnvironmentObject private var currentUser: CurrentUserStore
    
    @State var accessToken: String = ""
    @State var isAccessTokenChecked: Bool? = nil
    @State var isSaveTokenLoading = false
    
    @State private var showingPopover = false
    
    var body: some View {
        VStack {
            Spacer()
            
            if let _ = currentUser.accessToken {
                profile
            } else {
                loginView
            }
            
            Spacer()
            
            Link(destination: URL(string: "https://github.com/isaced/V2exOS")!) {
                Text("github.com/isaced/V2exOS")
                    .underline()
                    .padding(20)
            }
        }
        .navigationTitle("用户")
        .toolbar {
            if let _ = currentUser.accessToken {
                Button {
                    currentUser.logout()
                } label: {
                    Text("登出")
                }
            }
        }
    }
    
    var profile: some View {
        VStack {
            KFImage.url(URL(string: currentUser.user?.avatarLarge ?? ""))
                .resizable()
                .fade(duration: 0.25)
                .frame(width: 48, height: 48)
                .mask(RoundedRectangle(cornerRadius: 8))
            
            Text(currentUser.user?.username ?? "")
        }
    }
    
    var loginView: some View {
        Form {
            HStack {
                TextField("Personal Access Token", text: $accessToken, prompt: Text("00000000-0000-0000-0000-000000000000"))
                    .frame(width: 450)
                
                Button {
                    showingPopover.toggle()
                } label: {
                    Image(systemName: "questionmark.circle")
                }
                .buttonStyle(PlainButtonStyle())
                .popover(isPresented: $showingPopover) {
                    Link(destination: URL(string: "https://v2ex.com/settings/tokens")!) {
                        Text("请前往 v2ex.com/settings/tokens 生成")
                    }
                    .padding()
                    .hoverPointCursor()
                }
                
                if isSaveTokenLoading {
                    ProgressView()
                        .scaleEffect(0.4)
                } else {
                    if let isAccessTokenChecked = isAccessTokenChecked {
                        if isAccessTokenChecked {
                            Image(systemName: "checkmark.circle.fill")
                                .foregroundColor(.green)
                        } else {
                            Image(systemName: "exclamationmark.circle.fill")
                                .foregroundColor(.red)
                        }
                    }
                }
            }
            
            Button {
                saveToken()
            } label: {
                Text("保存")
            }
            .disabled(isSaveTokenLoading)
        }
        .onAppear {
            accessToken = currentUser.accessToken ?? ""
        }
    }
    
    func saveToken() {
        if accessToken.count == 0 {
            return
        }
        
        isSaveTokenLoading = true
        Task {
            let checked = await currentUser.checkToken(token: accessToken)
            if checked {
                currentUser.saveToken(token: accessToken)
            }
            isSaveTokenLoading = false
        }
    }
}

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView()
        
            .environmentObject(CurrentUserStore())
    }
}
