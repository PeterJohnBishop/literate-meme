//
//  Item.swift
//  swiftui-literate-meme
//
//  Created by m1_air on 11/17/24.
//

import Foundation
import SwiftData

@Model
final class Item {
    var timestamp: Date
    
    init(timestamp: Date) {
        self.timestamp = timestamp
    }
}
