//
//  NetworkManager.swift
//  Movipedia
//
//  Created by Steven Lie on 29/07/26.
//

import Foundation
import Combine
import Alamofire

protocol NetworkManagerProtocol {
    func performGetRequest<T: Codable>(endpoint: EndpointProtocol) -> AnyPublisher<T, Error>
}

final class NetworkManager: NetworkManagerProtocol {
    static let shared = NetworkManager()
    
    private let decoder: JSONDecoder = {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        return decoder
    }()
    
    func performGetRequest<T: Codable>(endpoint: EndpointProtocol) -> AnyPublisher<T, Error> {
        guard let url = endpoint.url else {
            return Fail(error: NetworkError.invalidURL).eraseToAnyPublisher()
        }
        
        return AF.request(url)
            .validate()
            .publishData()
            .tryMap { response in
                guard let httpResponse = response.response, (200...299).contains(httpResponse.statusCode) else {
                    let message = String(data: response.data ?? Data(), encoding: .utf8) ?? "Unknown error"
                    throw NetworkError.http(code: response.response?.statusCode ?? -1, message: message)
                }
                return response.data ?? Data()
            }
            .decode(type: T.self, decoder: decoder)
            .mapError { error in
                if error is DecodingError {
                    return DataError.decodingFail(message: error.localizedDescription)
                }
                return error
            }
            .eraseToAnyPublisher()
    }
}
