//
//  CommentModel.swift
//  swiftui-literate-meme
//
//  Created by m1_air on 12/10/24.
//

import Foundation
import SwiftUI

enum UserRole: String, Codable, Equatable, CaseIterable {
    case admin = "Admin"
    case user = "User"
    case guest = "Guest"
}

struct CommentModel: Codable, Equatable {
    var documentId: String
    var text: String
    var sender: String
    var role: UserRole
    var createdAt: Date?
    var updatedAt: Date?

    private enum CodingKeys: String, CodingKey {
        case documentId = "_id" // Map to MongoDB's _id field
        case text
        case sender
        case role
        case createdAt
        case updatedAt
    }

    // Custom date decoder for Unix timestamps and ISO 8601 strings
    static var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        return formatter
    }

    // Decode date that could be in either Unix timestamp or ISO 8601 format
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        documentId = try container.decode(String.self, forKey: .documentId)
        text = try container.decode(String.self, forKey: .text)
        sender = try container.decode(String.self, forKey: .sender)
        role = try container.decode(UserRole.self, forKey: .role)

        // Try decoding createdAt from multiple formats
        if let createdAtTimestamp = try? container.decode(Double.self, forKey: .createdAt) {
            createdAt = Date(timeIntervalSince1970: createdAtTimestamp)
        } else if let createdAtString = try? container.decode(String.self, forKey: .createdAt),
                  let date = CommentModel.dateFormatter.date(from: createdAtString) {
            createdAt = date
        }

        // Try decoding updatedAt from multiple formats
        if let updatedAtTimestamp = try? container.decode(Double.self, forKey: .updatedAt) {
            updatedAt = Date(timeIntervalSince1970: updatedAtTimestamp)
        } else if let updatedAtString = try? container.decode(String.self, forKey: .updatedAt),
                  let date = CommentModel.dateFormatter.date(from: updatedAtString) {
            updatedAt = date
        }
    }

    // Encode Date as Unix timestamp if present, or leave as ISO 8601 string
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(documentId, forKey: .documentId)
        try container.encode(text, forKey: .text)
        try container.encode(sender, forKey: .sender)
        try container.encode(role, forKey: .role)

        // Encode dates as ISO 8601 strings
        if let createdAt = createdAt {
            try container.encode(CommentModel.dateFormatter.string(from: createdAt), forKey: .createdAt)
        }
        if let updatedAt = updatedAt {
            try container.encode(CommentModel.dateFormatter.string(from: updatedAt), forKey: .updatedAt)
        }
    }

    // Init method with default values
    init(
        documentId: String = UUID().uuidString,
        text: String = "",
        sender: String = "",
        role: UserRole = .guest, // Default role
        createdAt: Date? = nil,
        updatedAt: Date? = nil
    ) {
        self.documentId = documentId
        self.text = text
        self.sender = sender
        self.role = role
        self.createdAt = createdAt
        self.updatedAt = updatedAt
    }
}

