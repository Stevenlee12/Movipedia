//
//  DiscoverBuilder.swift
//  Movipedia
//
//  Created by Steven Lie on 29/07/26.
//

import Foundation

final class DiscoverBuilder {
    @MainActor static func build(genre: GenreModel, router: Router) -> DiscoverPresenter {
        let networkManager = NetworkManager.shared
        let interactor = DiscoverInteractor(networkManager: networkManager)
        return DiscoverPresenter(genre: genre, interactor: interactor, router: router)
    }
}
