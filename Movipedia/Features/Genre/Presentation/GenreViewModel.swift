//
//  GenreViewModel.swift
//  Movipedia
//
//  Created by Steven Lie on 29/07/26.
//

import Foundation
import Combine

@MainActor
final class GenreViewModel: ObservableObject {
    private let getGenresUseCase: GetGenresUseCaseProtocol

    @Published var genres: [GenreModel] = []
    @Published var isLoading = false
    @Published var errorMessage: String?

    private var cancellables: Set<AnyCancellable> = []

    init(getGenresUseCase: GetGenresUseCaseProtocol) {
        self.getGenresUseCase = getGenresUseCase
    }

    func loadGenresIfNeeded() {
        guard genres.isEmpty, !isLoading else { return }
        loadGenres()
    }

    func loadGenres() {
        isLoading = true
        errorMessage = nil

        getGenresUseCase.executeGetGenres()
            .subscribe(on: DispatchQueue.global(qos: .background))
            .receive(on: RunLoop.main)
            .sink { [weak self] completion in
                self?.isLoading = false
                if case .failure(let error) = completion {
                    self?.errorMessage = error.localizedDescription
                }
            } receiveValue: { [weak self] genres in
                self?.genres = genres
            }
            .store(in: &cancellables)
    }
}

