//
//  MovieListItem.swift
//  Movipedia
//
//  Created by Steven Lie on 29/07/26.
//

import Foundation

public struct MovieListItem: Codable, Identifiable, Hashable {
    public let id: Int
    let title: String
    let posterPath: String?
    let backdropPath: String?
    let overview: String
    let releaseDate: String?
    let voteAverage: Double
    let genreIds: [Int]

    var posterURL: URL? {
        guard let path = posterPath else { return nil }
        return URL(string: "\(APIConfig.imageBaseURL)/\(APIConfig.ImageSize.poster)\(path)")
    }

    var backdropURL: URL? {
        guard let path = backdropPath else { return nil }
        return URL(string: "\(APIConfig.imageBaseURL)/\(APIConfig.ImageSize.backdrop)\(path)")
    }

    var year: String {
        guard let date = releaseDate, date.count >= 4 else { return "-" }
        return String(date.prefix(4))
    }

    var rating: String {
        String(format: "%.1f", voteAverage)
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }

    public static func == (lhs: MovieListItem, rhs: MovieListItem) -> Bool {
        lhs.id == rhs.id
    }
}
