//
//  GetMovieReviewsUseCase.swift
//  Movipedia
//
//  Created by Steven Lie on 29/07/26.
//

import Combine

public typealias MovieReviewsResult = AnyPublisher<(reviews: [ReviewModel], totalPages: Int), Error>

protocol GetMovieReviewsUseCaseProtocol {
    func execute(movieId: Int, page: Int) -> MovieReviewsResult
}

final class GetMovieReviewsUseCase: GetMovieReviewsUseCaseProtocol {
    private let repository: MovieDetailRepositoryProtocol

    init(repository: MovieDetailRepositoryProtocol) {
        self.repository = repository
    }

    func execute(movieId: Int, page: Int) -> MovieReviewsResult {
        repository.getMovieReviews(movieId: movieId, page: page)
    }
}

