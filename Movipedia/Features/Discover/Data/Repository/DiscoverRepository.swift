//
//  DiscoverRepository.swift
//  Movipedia
//
//  Created by Steven Lie on 29/07/26.
//

import Combine

public typealias DiscoverMoviesResult = AnyPublisher<(movies: [MovieListItem], totalPages: Int), Error>

protocol DiscoverRepositoryProtocol {
    func getMoviesByGenre(genreId: Int, page: Int) -> DiscoverMoviesResult
}

final class DiscoverRepository: DiscoverRepositoryProtocol {
    private let networkManager: NetworkManagerProtocol

    init(networkManager: NetworkManagerProtocol = NetworkManager.shared) {
        self.networkManager = networkManager
    }

    func getMoviesByGenre(genreId: Int, page: Int) -> DiscoverMoviesResult {
        networkManager
            .performGetRequest(endpoint: Endpoints.discoverMovies(genreId: genreId, page: page))
            .map { (response: PaginatedResponse<MovieListItem>) in
                (movies: response.results, totalPages: response.totalPages)
            }
            .eraseToAnyPublisher()
    }
}
