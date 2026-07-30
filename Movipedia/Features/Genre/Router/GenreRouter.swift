//
//  GenreRouter.swift
//  Movipedia
//
//  Created by Steven Lie on 29/07/26.
//

import SwiftUI

protocol GenreRouterProtocol {
    func makeDiscoverView(genre: GenreModel) -> DiscoverMovieListView
}

final class GenreRouter: GenreRouterProtocol {
    func makeDiscoverView(genre: GenreModel) -> DiscoverMovieListView {
        DiscoverMovieListView(genre: genre)
    }
}
