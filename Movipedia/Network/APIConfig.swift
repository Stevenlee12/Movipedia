//
//  APIConfig.swift
//  Movipedia
//
//  Created by Steven Lie on 29/07/26.
//

import Foundation

enum APIConfig {
    static let baseURL = "https://api.themoviedb.org/3"
    static let imageBaseURL = "https://image.tmdb.org/t/p"
    static let apiKey = "b03125ac027c08c7e15fe2d6f0ba1895"

    enum ImageSize {
        static let poster = "w500"
        static let backdrop = "w1280"
    }
}
