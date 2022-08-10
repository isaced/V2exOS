//
//  CurrentUserStore.swift
//  V2exOS
//
//  Created by isaced on 2022/8/11.
//

import Foundation
import SwiftUI
import V2exAPI
import KeychainAccess

public class CurrentUserStore: ObservableObject {
  
  public static let shared = CurrentUserStore()
  
  @Published public private(set) var user: V2Member?
  @Published public private(set) var accessToken: String? {
    didSet {
      v2ex.accessToken = accessToken
    }
  }
  
  let keychain = Keychain(service: "com.isaced.v2exos")
  let KeychainTokenKey = "AccessToken"
  
  
  
  public init() {
    if let token = readToken(){
      accessToken = token
    }
  }
  
  public func readToken() -> String? {
    return keychain[KeychainTokenKey]
  }
  
  public func saveToken(token: String) {
    accessToken = token
    keychain[KeychainTokenKey] = token
  }
}
