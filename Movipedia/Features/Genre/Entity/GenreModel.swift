//
//  GenreModel.swift
//  Movipedia
//
//  Created by Steven Lie on 29/07/26.
//

import Foundation

struct GenreModel: Codable, Identifiable, Hashable {
    let id: Int
    let name: String?
}

struct GenreListResponse: Codable {
    let genres: [GenreModel]
}
