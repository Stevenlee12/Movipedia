//
//  ReviewModel.swift
//  Movipedia
//
//  Created by Steven Lie on 29/07/26.
//

import Foundation

public struct ReviewModel: Codable, Identifiable {
    public let id: String
    let author: String
    let authorDetails: AuthorDetails?
    let content: String
    let createdAt: String?

    var avatarURL: URL? {
        guard let path = authorDetails?.avatarPath else { return nil }
        if path.hasPrefix("/") {
            return URL(string: "\(APIConfig.imageBaseURL)/w200\(path)")
        }
        return URL(string: path)
    }

    var rating: Double? {
        authorDetails?.rating
    }

    var formattedDate: String {
        guard let date = createdAt, date.count >= 10 else { return "-" }
        return String(date.prefix(10))
    }
}

struct AuthorDetails: Codable {
    let name: String?
    let username: String?
    let avatarPath: String?
    let rating: Double?
}
