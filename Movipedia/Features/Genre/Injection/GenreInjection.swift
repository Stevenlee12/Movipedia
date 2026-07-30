//
//  GenreInjection.swift
//  Movipedia
//
//  Created by Steven Lie on 29/07/26.
//

import Foundation

final class GenreInjection {
    @MainActor static func provideGenreViewModel() -> GenreViewModel {
        let repository = GenreRepository(networkManager: NetworkManager.shared)
        let useCase = GetGenresUseCase(repository: repository)
        return GenreViewModel(getGenresUseCase: useCase)
    }
}
