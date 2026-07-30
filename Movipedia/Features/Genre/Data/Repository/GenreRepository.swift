//
//  GenreRepository.swift
//  Movipedia
//
//  Created by Steven Lie on 29/07/26.
//

import Combine

typealias GenresResult = AnyPublisher<[GenreModel], Error>

protocol GenreRepositoryProtocol {
    func getGenres() -> GenresResult
}

final class GenreRepository: GenreRepositoryProtocol {
    private let networkManager: NetworkManagerProtocol

    init(networkManager: NetworkManagerProtocol = NetworkManager.shared) {
        self.networkManager = networkManager
    }

    func getGenres() -> GenresResult {
        networkManager
            .performGetRequest(endpoint: Endpoints.genreList)
            .map { (response: GenreListResponse) in response.genres }
            .eraseToAnyPublisher()
    }
}

