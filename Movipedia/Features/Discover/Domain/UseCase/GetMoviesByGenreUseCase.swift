//
//  GetMoviesByGenreUseCase.swift
//  Movipedia
//
//  Created by Steven Lie on 29/07/26.
//

import Combine

protocol GetMoviesByGenreUseCaseProtocol {
    func execute(genreId: Int, page: Int) -> DiscoverMoviesResult
}

final class GetMoviesByGenreUseCase: GetMoviesByGenreUseCaseProtocol {
    private let repository: DiscoverRepositoryProtocol

    init(repository: DiscoverRepositoryProtocol) {
        self.repository = repository
    }

    func execute(genreId: Int, page: Int) -> DiscoverMoviesResult {
        repository.getMoviesByGenre(genreId: genreId, page: page)
    }
}
