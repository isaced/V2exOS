//
//  StringExt.swift
//  V2exOS
//
//  Created by isaced on 2022/8/12.
//

import Foundation

extension String {
    func htmlToString() -> String? {
        do {
            let text = try NSAttributedString(data: self.data(using: .unicode)!,
                                              options: [.documentType: NSAttributedString.DocumentType.html],
                                              documentAttributes: nil).string
            return text
        } catch {
            print("htmlToString fail: ", self)
        }
        return nil
    }
}
