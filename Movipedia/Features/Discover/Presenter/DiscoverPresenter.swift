//
//  DiscoverPresenter.swift
//  Movipedia
//
//  Created by Steven Lie on 29/07/26.
//

import Combine
import Foundation

@MainActor
final class DiscoverPresenter: ObservableObject {
    let genre: GenreModel

    @Published var movies: [MovieListItem] = []
    @Published var isLoading = false
    @Published var isLoadingNextPage = false
    @Published var errorMessage: String?

    private var currentPage = 1
    private var totalPages = 1
    private var isLoadingPage = false
    private let interactor: DiscoverInteractorProtocol
    private let router: Router

    init(genre: GenreModel, interactor: DiscoverInteractorProtocol, router: Router) {
        self.genre = genre
        self.interactor = interactor
        self.router = router
    }

    func loadMovies() async {
        guard !isLoadingPage else { return }
        isLoading = movies.isEmpty
        isLoadingPage = true
        errorMessage = nil

        do {
            let result = try await interactor.fetchMoviesByGenre(genreId: genre.id, page: 1)
            movies = result.movies
            totalPages = result.totalPages
            currentPage = 1
        } catch {
            errorMessage = error.localizedDescription
        }

        isLoading = false
        isLoadingPage = false
    }

    func loadNextPageIfNeeded(currentItem: MovieListItem?) async {
        guard let currentItem = currentItem else { return }

        let thresholdIndex = movies.index(movies.endIndex, offsetBy: -4)
        if movies.firstIndex(where: { $0.id == currentItem.id }) ?? 0 >= thresholdIndex {
            await loadNextPage()
        }
    }

    private func loadNextPage() async {
        guard currentPage < totalPages, !isLoadingPage else { return }
        isLoadingNextPage = true
        isLoadingPage = true

        let nextPage = currentPage + 1

        do {
            let result = try await interactor.fetchMoviesByGenre(genreId: genre.id, page: nextPage)
            movies.append(contentsOf: result.movies)
            currentPage = nextPage
        } catch {
            errorMessage = error.localizedDescription
        }

        isLoadingNextPage = false
        isLoadingPage = false
    }

    func didTapMovie(_ movieId: Int) {
        router.push(.movieDetail(movieId: movieId))
    }
}
