//
//  MovieDetailInteractor.swift
//  Movipedia
//
//  Created by Steven Lie on 29/07/26.
//

import Foundation

struct MovieReviewsResult {
    let reviews: [ReviewModel]
    let totalPages: Int
}

protocol MovieDetailInteractorProtocol {
    func fetchMovieDetail(movieId: Int) async throws -> MovieDetailModel
    func fetchMovieReviews(movieId: Int, page: Int) async throws -> MovieReviewsResult
    func fetchMovieVideos(movieId: Int) async throws -> [VideoModel]
}

final class MovieDetailInteractor: MovieDetailInteractorProtocol {
    private let networkManager: NetworkManagerProtocol

    init(networkManager: NetworkManagerProtocol = NetworkManager.shared) {
        self.networkManager = networkManager
    }

    func fetchMovieDetail(movieId: Int) async throws -> MovieDetailModel {
        try await networkManager.performGetRequest(endpoint: Endpoints.movieDetail(movieId: movieId))
    }

    func fetchMovieReviews(movieId: Int, page: Int) async throws -> MovieReviewsResult {
        let response: PaginatedResponse<ReviewModel> = try await networkManager.performGetRequest(
            endpoint: Endpoints.movieReviews(movieId: movieId, page: page)
        )
        return MovieReviewsResult(
            reviews: response.results,
            totalPages: response.totalPages
        )
    }

    func fetchMovieVideos(movieId: Int) async throws -> [VideoModel] {
        let response: VideoListResponse = try await networkManager.performGetRequest(
            endpoint: Endpoints.movieVideos(movieId: movieId)
        )
        return response.results
    }
}
