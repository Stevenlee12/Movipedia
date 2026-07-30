//
//  DiscoverInteractor.swift
//  Movipedia
//
//  Created by Steven Lie on 29/07/26.
//

import Foundation

struct DiscoverMoviesResult {
    let movies: [MovieListItem]
    let totalPages: Int
}

protocol DiscoverInteractorProtocol {
    func fetchMoviesByGenre(genreId: Int, page: Int) async throws -> DiscoverMoviesResult
}

final class DiscoverInteractor: DiscoverInteractorProtocol {
    private let networkManager: NetworkManagerProtocol

    init(networkManager: NetworkManagerProtocol = NetworkManager.shared) {
        self.networkManager = networkManager
    }

    func fetchMoviesByGenre(genreId: Int, page: Int) async throws -> DiscoverMoviesResult {
        let response: PaginatedResponse<MovieListItem> = try await networkManager.performGetRequest(
            endpoint: Endpoints.discoverMovies(genreId: genreId, page: page)
        )
        return DiscoverMoviesResult(
            movies: response.results,
            totalPages: response.totalPages
        )
    }
}
