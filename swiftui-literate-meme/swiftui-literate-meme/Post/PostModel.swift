//
//  PostModel.swift
//  swiftui-literate-meme
//
//  Created by m1_air on 12/10/24.
//

import Foundation

struct PostModel: Codable, Equatable {
    var documentId: String
    var photos: [String]
    var title: String
    var content: String
    var comments: [String]
    var createdAt: Date?
    var updatedAt: Date?

    private enum CodingKeys: String, CodingKey {
        case documentId = "_id" // Map to MongoDB's _id field
        case photos
        case title
        case content
        case comments
        case createdAt
        case updatedAt
    }

    static var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        return formatter
    }

    // Decode date that could be in either Unix timestamp or ISO 8601 format
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        documentId = try container.decode(String.self, forKey: .documentId)
        photos = try container.decode([String].self, forKey: .photos)
        title = try container.decode(String.self, forKey: .title)
        content = try container.decode(String.self, forKey: .content)
        comments = try container.decode([String].self, forKey: .comments)

        // Try decoding createdAt from multiple formats
        if let createdAtTimestamp = try? container.decode(Double.self, forKey: .createdAt) {
            createdAt = Date(timeIntervalSince1970: createdAtTimestamp)
        } else if let createdAtString = try? container.decode(String.self, forKey: .createdAt),
                  let date = PostModel.dateFormatter.date(from: createdAtString) {
            createdAt = date
        }

        // Try decoding updatedAt from multiple formats
        if let updatedAtTimestamp = try? container.decode(Double.self, forKey: .updatedAt) {
            updatedAt = Date(timeIntervalSince1970: updatedAtTimestamp)
        } else if let updatedAtString = try? container.decode(String.self, forKey: .updatedAt),
                  let date = PostModel.dateFormatter.date(from: updatedAtString) {
            updatedAt = date
        }
    }

    // Encode Date as Unix timestamp if present, or leave as ISO 8601 string
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(documentId, forKey: .documentId)
        try container.encode(photos, forKey: .photos)
        try container.encode(title, forKey: .title)
        try container.encode(content, forKey: .content)
        try container.encode(comments, forKey: .comments)

        // Encode dates as ISO 8601 strings
        if let createdAt = createdAt {
            try container.encode(PostModel.dateFormatter.string(from: createdAt), forKey: .createdAt)
        }
        if let updatedAt = updatedAt {
            try container.encode(PostModel.dateFormatter.string(from: updatedAt), forKey: .updatedAt)
        }
    }

    init(
        documentId: String = UUID().uuidString,
        photos: [String] = [],
        title: String = "",
        content: String = "",
        comments: [String] = [],
        createdAt: Date? = nil,
        updatedAt: Date? = nil
    ) {
        self.documentId = documentId
        self.photos = photos
        self.title = title
        self.content = content
        self.comments = comments
        self.createdAt = createdAt
        self.updatedAt = updatedAt
    }
}
