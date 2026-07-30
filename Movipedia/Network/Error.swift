//
//  Error.swift
//  Movipedia
//
//  Created by Steven Lie on 29/07/26.
//

import Foundation

enum NetworkError: Error, LocalizedError {
    case invalidURL
    case http(code: Int, message: String)
    case custom(message: String)

    var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "Invalid URL"
        case .http(let code, let message):
            return "HTTP \(code): \(message)"
        case .custom(let message):
            return message
        }
    }
}

enum DataError: Error, LocalizedError {
    case decodingFail(message: String)

    var errorDescription: String? {
        switch self {
        case .decodingFail(let message):
            return "Decoding error: \(message)"
        }
    }
}
