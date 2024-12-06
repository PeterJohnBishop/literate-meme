//
//  UserModel.swift
//  swiftui-literate-meme
//
//  Created by m1_air on 11/25/24.
//

import Foundation

struct UserModel: Codable, Equatable {
    var uid: String
    var userPhotoURL: String
    var username: String
    
    init(uid: String = "", userPhotoURL: String = "", username: String = "") {
        self.uid = uid
        self.userPhotoURL = userPhotoURL
        self.username = username
    }
}
