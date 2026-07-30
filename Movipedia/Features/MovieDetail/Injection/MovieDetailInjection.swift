//
//  MovieDetailInjection.swift
//  Movipedia
//
//  Created by Steven Lie on 29/07/26.
//

import Foundation

final class MovieDetailInjection {
    @MainActor static func provideMovieDetailViewModel(movieId: Int) -> MovieDetailViewModel {
        let repository = MovieDetailRepository(networkManager: NetworkManager.shared)
        let detailUseCase = GetMovieDetailUseCase(repository: repository)
        let reviewsUseCase = GetMovieReviewsUseCase(repository: repository)
        return MovieDetailViewModel(
            movieId: movieId,
            getMovieDetailUseCase: detailUseCase,
            getMovieReviewsUseCase: reviewsUseCase,
            repository: repository
        )
    }
}
