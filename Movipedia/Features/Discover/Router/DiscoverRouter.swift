//
//  DiscoverRouter.swift
//  Movipedia
//
//  Created by Steven Lie on 29/07/26.
//

import SwiftUI

protocol DiscoverRouterProtocol {
    func makeMovieDetailView(movieId: Int) -> MovieDetailView
}

final class DiscoverRouter: DiscoverRouterProtocol {
    func makeMovieDetailView(movieId: Int) -> MovieDetailView {
        MovieDetailView(movieId: movieId)
    }
}
