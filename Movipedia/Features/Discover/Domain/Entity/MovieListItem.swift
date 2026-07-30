//
//  MovieListItem.swift
//  Movipedia
//
//  Created by Steven Lie on 29/07/26.
//

import Foundation

struct PaginatedResponse<T: Codable>: Codable {
    let page: Int
    let results: [T]
    let totalPages: Int
    let totalResults: Int
}

