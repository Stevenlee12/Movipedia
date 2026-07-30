//
//  GenreUseCase.swift
//  Movipedia
//
//  Created by Steven Lie on 29/07/26.
//

import Combine

protocol GetGenresUseCaseProtocol {
    func executeGetGenres() -> GenresResult
}

final class GetGenresUseCase: GetGenresUseCaseProtocol {
    private let repository: GenreRepositoryProtocol

    init(repository: GenreRepositoryProtocol) {
        self.repository = repository
    }

    func executeGetGenres() -> GenresResult {
        repository.getGenres()
    }
}
