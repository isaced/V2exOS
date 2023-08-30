//
//  CommentUserTagView.swift
//  V2exOS
//
//  Created by isaced on 2023/8/30.
//

import SwiftUI

enum CommentUserTagType {
    case op
    case mod
}

struct CommentUserTagView: View {
    var type: CommentUserTagType
    
    init(_ type: CommentUserTagType) {
        self.type = type
    }
    
    let CornerRadius = 4.0
    
    var body: some View {
        Text(type == .mod ? "MOD" : "OP")
            .padding(.vertical, 1)
            .padding(.horizontal, 6)
            .if(type == .op) { v in
                v.background(Color("UserTagModBackgroundColor").opacity(0.2))
                    .foregroundColor(Color("UserTagModBackgroundColor"))
                    .overlay( /// apply a rounded border
                        RoundedRectangle(cornerRadius: CornerRadius)
                            .stroke(.blue, lineWidth: 1)
                    )
            
            }
            .if(type == .mod) { v in
                v.background(Color("UserTagModBackgroundColor"))
                    .foregroundColor(.white)
            }
            .cornerRadius(CornerRadius)
    }
}

struct CommentUserTagView_Previews: PreviewProvider {
    static var previews: some View {
        CommentUserTagView(.mod)
    }
}
