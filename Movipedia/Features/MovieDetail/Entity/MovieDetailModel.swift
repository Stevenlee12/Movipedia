//
//  MovieDetailModel.swift
//  Movipedia
//
//  Created by Steven Lie on 29/07/26.
//

import Foundation

public struct MovieDetailModel: Codable {
    let id: Int
    let title: String
    let posterPath: String?
    let backdropPath: String?
    let overview: String?
    let releaseDate: String?
    let runtime: Int?
    let voteAverage: Double
    let voteCount: Int
    let tagline: String?
    let status: String?
    let budget: Int?
    let revenue: Int?
    let genres: [GenreModel]?
    let productionCompanies: [ProductionCompany]?
    let spokenLanguages: [SpokenLanguage]?

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

    var rating: String { String(format: "%.1f", voteAverage) }

    var runtimeFormatted: String {
        guard let runtime = runtime else { return "-" }
        let hours = runtime / 60
        let minutes = runtime % 60
        if hours > 0 {
            return "\(hours)h \(minutes)m"
        }
        return "\(minutes)m"
    }

    var genreNames: String {
        let names = genres?.compactMap { $0.name }.filter { !$0.isEmpty } ?? []
        return names.isEmpty ? "-" : names.joined(separator: ", ")
    }

    var budgetFormatted: String {
        guard let budget = budget, budget > 0 else { return "-" }
        return "$\(formatNumber(budget))"
    }

    var revenueFormatted: String {
        guard let revenue = revenue, revenue > 0 else { return "-" }
        return "$\(formatNumber(revenue))"
    }

    private func formatNumber(_ number: Int) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        return formatter.string(from: NSNumber(value: number)) ?? "\(number)"
    }
}

struct ProductionCompany: Codable, Identifiable {
    let id: Int
    let name: String
    let logoPath: String?
}

struct SpokenLanguage: Codable {
    let englishName: String
    let name: String
}
