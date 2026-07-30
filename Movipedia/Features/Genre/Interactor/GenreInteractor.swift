//
//  GenreInteractor.swift
//  Movipedia
//
//  Created by Steven Lie on 29/07/26.
//

import Foundation

protocol GenreInteractorProtocol {
    func fetchGenres() async throws -> [GenreModel]
}

final class GenreInteractor: GenreInteractorProtocol {
    private let networkManager: NetworkManagerProtocol

    init(networkManager: NetworkManagerProtocol = NetworkManager.shared) {
        self.networkManager = networkManager
    }

    func fetchGenres() async throws -> [GenreModel] {
        let response: GenreListResponse = try await networkManager.performGetRequest(endpoint: Endpoints.genreList)
        return response.genres
    }
}
