//
//  ProjectModel.swift
//  swiftui-literate-meme
//
//  Created by m1_air on 12/4/24.
//

import Foundation

struct ProjectModel: Codable, Equatable {
    var uid: String
    var photos: [String]
    var title: String
    var description: String
    var tags: [String]
    
    init(uid: String = "", photos: [String] = [], title: String = "", description: String = "", tags: [String] = []) {
        self.uid = uid
        self.photos = photos
        self.title = title
        self.description = description
        self.tags = tags
    }
}
