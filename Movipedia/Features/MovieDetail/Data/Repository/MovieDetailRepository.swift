//
//  MovieDetailRepository.swift
//  Movipedia
//
//  Created by Steven Lie on 29/07/26.
//

import Combine

protocol MovieDetailRepositoryProtocol {
    func getMovieDetail(movieId: Int) -> MovieDetailResult
    func getMovieReviews(movieId: Int, page: Int) -> MovieReviewsResult
    func getMovieVideos(movieId: Int) -> MovieVideosResult
}

final class MovieDetailRepository: MovieDetailRepositoryProtocol {
    private let networkManager: NetworkManagerProtocol

    init(networkManager: NetworkManagerProtocol = NetworkManager.shared) {
        self.networkManager = networkManager
    }

    func getMovieDetail(movieId: Int) -> MovieDetailResult {
        networkManager
            .performGetRequest(endpoint: Endpoints.movieDetail(movieId: movieId))
            .eraseToAnyPublisher()
    }

    func getMovieReviews(movieId: Int, page: Int) -> MovieReviewsResult {
        networkManager
            .performGetRequest(endpoint: Endpoints.movieReviews(movieId: movieId, page: page))
            .map { (response: PaginatedResponse<ReviewModel>) in
                (reviews: response.results, totalPages: response.totalPages)
            }
            .eraseToAnyPublisher()
    }

    func getMovieVideos(movieId: Int) -> MovieVideosResult {
        networkManager
            .performGetRequest(endpoint: Endpoints.movieVideos(movieId: movieId))
            .map { (response: VideoListResponse) in response.results }
            .eraseToAnyPublisher()
    }
}
