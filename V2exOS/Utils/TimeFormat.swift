//
//  TimeFormat.swift
//  V2exOS
//
//  Created by isaced on 2022/7/24.
//

import Foundation

extension Date {
  
  func fromNow() -> String {
    // ask for the full relative date
    let formatter = RelativeDateTimeFormatter()
    formatter.unitsStyle = .full

    // get exampleDate relative to the current date
    let relativeDate = formatter.localizedString(for: self, relativeTo: Date.now)

    return relativeDate
  }
  
}
