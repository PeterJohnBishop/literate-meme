//
//  TagModel.swift
//  swiftui-literate-meme
//
//  Created by m1_air on 12/4/24.
//

import Foundation

struct TagModel: Codable, Equatable {
    var uid: String
    var tag: String
    
    init(uid: String = "", tag: String = "") {
        self.uid = uid
        self.tag = tag
    }
}
