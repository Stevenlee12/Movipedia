//
//  MovieDetailBuilder.swift
//  Movipedia
//
//  Created by Steven Lie on 29/07/26.
//

import Foundation

final class MovieDetailBuilder {
    @MainActor static func build(movieId: Int) -> MovieDetailPresenter {
        let networkManager = NetworkManager.shared
        let interactor = MovieDetailInteractor(networkManager: networkManager)
        return MovieDetailPresenter(movieId: movieId, interactor: interactor)
    }
}
