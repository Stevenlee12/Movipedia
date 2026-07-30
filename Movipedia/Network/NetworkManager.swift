//
//  NetworkManager.swift
//  Movipedia
//
//  Created by Steven Lie on 29/07/26.
//

import Foundation
import Alamofire

protocol NetworkManagerProtocol {
    func performGetRequest<T: Codable>(endpoint: EndpointProtocol) async throws -> T
}

final class NetworkManager: NetworkManagerProtocol {
    static let shared = NetworkManager()

    private let decoder: JSONDecoder = {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        return decoder
    }()

    func performGetRequest<T: Codable>(endpoint: EndpointProtocol) async throws -> T {
        guard let url = endpoint.url else {
            throw NetworkError.invalidURL
        }

        let response = await AF.request(url)
            .validate()
            .serializingDecodable(T.self, decoder: decoder)
            .response

        switch response.result {
        case .success(let value):
            return value
        case .failure(let error):
            if let afError = error.asAFError, afError.isResponseSerializationError {
                throw DataError.decodingFail(message: error.localizedDescription)
            }
            throw NetworkError.custom(message: error.localizedDescription)
        }
    }
}
