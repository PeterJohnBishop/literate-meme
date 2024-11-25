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
    var connections: [String]
    var media: [String]
    var locationLat: Double
    var locationLong: Double
    
    init(uid: String = "", userPhotoURL: String = "", username: String = "", connections: [String] = [], media: [String] = [], locationLat: Double = 0.0, locationLong: Double = 0.0) {
        self.uid = uid
        self.userPhotoURL = userPhotoURL
        self.username = username
        self.connections = connections
        self.media = media
        self.locationLat = locationLat
        self.locationLong = locationLong
    }
}
