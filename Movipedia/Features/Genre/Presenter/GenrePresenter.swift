//
//  GenrePresenter.swift
//  Movipedia
//
//  Created by Steven Lie on 29/07/26.
//

import Combine
import Foundation

@MainActor
final class GenrePresenter: ObservableObject {
    @Published var genres: [GenreModel] = []
    @Published var isLoading = false
    @Published var errorMessage: String?

    private let interactor: GenreInteractorProtocol
    private let router: Router

    init(interactor: GenreInteractorProtocol, router: Router) {
        self.interactor = interactor
        self.router = router
    }

    func loadGenresIfNeeded() async {
        guard genres.isEmpty, !isLoading else { return }
        await loadGenres()
    }

    func loadGenres() async {
        isLoading = true
        errorMessage = nil

        do {
            genres = try await interactor.fetchGenres()
        } catch {
            errorMessage = error.localizedDescription
        }

        isLoading = false
    }

    func didTapGenre(_ genre: GenreModel) {
        router.push(.discoverMovies(genre: genre))
    }
}
