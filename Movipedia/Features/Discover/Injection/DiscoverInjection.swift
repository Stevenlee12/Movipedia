//
//  DiscoverInjection.swift
//  Movipedia
//
//  Created by Steven Lie on 29/07/26.
//

import Foundation

final class DiscoverInjection {
    @MainActor static func provideDiscoverViewModel(genre: GenreModel) -> DiscoverViewModel {
        let repository = DiscoverRepository(networkManager: NetworkManager.shared)
        let useCase = GetMoviesByGenreUseCase(repository: repository)
        return DiscoverViewModel(genre: genre, getMoviesByGenreUseCase: useCase)
    }
}
