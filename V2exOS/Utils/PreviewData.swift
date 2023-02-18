//
//  PreviewData.swift
//  V2exOS
//
//  Created by isaced on 2022/7/31.
//

import Foundation
import V2exAPI

struct PreviewData {
    static let member = V2Member(id: 79764,
                                 username: "ljsh093",
                                 url: "https://www.v2ex.com/u/ljsh093",
                                 avatarMini: "https://cdn.v2ex.com/avatar/ff10/6e6c/79764_mini.png?m=1657684598",
                                 avatarNormal: "https://cdn.v2ex.com/avatar/ff10/6e6c/79764_normal.png?m=1657684598",
                                 avatarLarge: "https://cdn.v2ex.com/avatar/ff10/6e6c/79764_large.png?m=1657684598",
                                 created: 1414903742,
                                 lastModified: 1657684598)

    static let topic = V2Topic(id: 1,
                               node: nil,
                               member: PreviewData.member,
                               lastReplyBy: "ljsh093",
                               lastTouched: 1658649862,
                               title: "万行原生 Javascript 该如何维护？",
                               url: "https://www.v2ex.com/t/868366",
                               created: 1658649797,
                               deleted: 0,
                               content: "想拆成 Typescript 模块化，有没有什么指路手册？",
                               contentRendered: "<p>想拆成 Typescript 模块化，有没有什么指路手册？</p>\n",
                               lastModified: 1658649797,
                               replies: 1111)

    static let comment = V2Comment(id: 1,
                                   content: "Testtt",
                                   contentRendered: "Testtt",
                                   created: 1272220126,
                                   member: member)
}
