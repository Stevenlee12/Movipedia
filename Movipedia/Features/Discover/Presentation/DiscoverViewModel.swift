//
//  DiscoverViewModel.swift
//  Movipedia
//
//  Created by Steven Lie on 29/07/26.
//

import Foundation
import Combine

@MainActor
final class DiscoverViewModel: ObservableObject {
    let genre: GenreModel
    private let getMoviesByGenreUseCase: GetMoviesByGenreUseCaseProtocol

    @Published var movies: [MovieListItem] = []
    @Published var isLoading = false
    @Published var isLoadingNextPage = false
    @Published var errorMessage: String?

    private var currentPage = 1
    private var totalPages = 1
    private var isLoadingPage = false

    private var cancellables: Set<AnyCancellable> = []

    init(genre: GenreModel, getMoviesByGenreUseCase: GetMoviesByGenreUseCaseProtocol) {
        self.genre = genre
        self.getMoviesByGenreUseCase = getMoviesByGenreUseCase
    }

    func loadMovies() {
        guard !isLoadingPage else { return }
        isLoading = movies.isEmpty
        isLoadingPage = true
        errorMessage = nil

        getMoviesByGenreUseCase.execute(genreId: genre.id, page: 1)
            .subscribe(on: DispatchQueue.global(qos: .background))
            .receive(on: RunLoop.main)
            .sink { [weak self] completion in
                self?.isLoading = false
                self?.isLoadingPage = false
                if case .failure(let error) = completion {
                    self?.errorMessage = error.localizedDescription
                }
            } receiveValue: { [weak self] result in
                self?.movies = result.movies
                self?.totalPages = result.totalPages
                self?.currentPage = 1
            }
            .store(in: &cancellables)
    }

    func loadNextPageIfNeeded(currentItem: MovieListItem?) {
        guard let currentItem = currentItem else { return }

        let thresholdIndex = movies.index(movies.endIndex, offsetBy: -4)
        if movies.firstIndex(where: { $0.id == currentItem.id }) ?? 0 >= thresholdIndex {
            loadNextPage()
        }
    }

    private func loadNextPage() {
        guard currentPage < totalPages, !isLoadingPage else { return }
        isLoadingNextPage = true
        isLoadingPage = true

        let nextPage = currentPage + 1

        getMoviesByGenreUseCase.execute(genreId: genre.id, page: nextPage)
            .subscribe(on: DispatchQueue.global(qos: .background))
            .receive(on: RunLoop.main)
            .sink { [weak self] completion in
                self?.isLoadingNextPage = false
                self?.isLoadingPage = false
                if case .failure(let error) = completion {
                    self?.errorMessage = error.localizedDescription
                }
            } receiveValue: { [weak self] result in
                self?.movies.append(contentsOf: result.movies)
                self?.currentPage = nextPage
            }
            .store(in: &cancellables)
    }
}
