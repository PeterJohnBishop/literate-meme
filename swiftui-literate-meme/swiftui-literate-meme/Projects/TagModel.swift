//
//  TagModel.swift
//  swiftui-literate-meme
//
//  Created by m1_air on 12/4/24.
//

import Foundation

struct TagModel: Codable, Equatable {
    var uid: String
    var icon: String
    var tag: String
    
    init(uid: String = "", icon: String = "", tag: String = "") {
        self.uid = uid
        self.icon = icon
        self.tag = tag
    }
}
