//
//  Endpoints.swift
//  Movipedia
//
//  Created by Steven Lie on 29/07/26.
//

import Foundation

protocol EndpointProtocol {
    var url: URL? { get }
}

enum Endpoints: EndpointProtocol {
    case genreList
    case discoverMovies(genreId: Int, page: Int)
    case movieDetail(movieId: Int)
    case movieReviews(movieId: Int, page: Int)
    case movieVideos(movieId: Int)

    private var path: String {
        switch self {
        case .genreList:
            return "/genre/movie/list"
        case .discoverMovies:
            return "/discover/movie"
        case .movieDetail(let movieId):
            return "/movie/\(movieId)"
        case .movieReviews(let movieId, _):
            return "/movie/\(movieId)/reviews"
        case .movieVideos(let movieId):
            return "/movie/\(movieId)/videos"
        }
    }

    private var queryItems: [URLQueryItem] {
        var items: [URLQueryItem] = [
            URLQueryItem(name: "api_key", value: APIConfig.apiKey)
        ]

        switch self {
        case .genreList:
            break
        case .discoverMovies(let genreId, let page):
            items.append(URLQueryItem(name: "with_genres", value: "\(genreId)"))
            items.append(URLQueryItem(name: "page", value: "\(page)"))
            items.append(URLQueryItem(name: "sort_by", value: "popularity.desc"))
        case .movieDetail:
            break
        case .movieReviews(_, let page):
            items.append(URLQueryItem(name: "page", value: "\(page)"))
        case .movieVideos:
            break
        }

        return items
    }

    var url: URL? {
        guard var components = URLComponents(string: APIConfig.baseURL + path) else {
            return nil
        }
        components.queryItems = queryItems
        return components.url
    }
}

