//
//  Destination.swift
//  Movipedia
//
//  Created by Steven Lie on 29/07/26.
//

import Foundation

enum Destination: Hashable {
    case discoverMovies(genre: GenreModel)
    case movieDetail(movieId: Int)
}
