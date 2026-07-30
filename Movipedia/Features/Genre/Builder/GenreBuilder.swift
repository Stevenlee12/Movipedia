//
//  GenreBuilder.swift
//  Movipedia
//
//  Created by Steven Lie on 29/07/26.
//

import Foundation

final class GenreBuilder {
    @MainActor static func build(router: Router) -> GenrePresenter {
        let networkManager = NetworkManager.shared
        let interactor = GenreInteractor(networkManager: networkManager)
        return GenrePresenter(interactor: interactor, router: router)
    }
}
