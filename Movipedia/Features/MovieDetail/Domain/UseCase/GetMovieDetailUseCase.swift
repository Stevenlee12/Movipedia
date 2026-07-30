//
//  GetMovieDetailUseCase.swift
//  Movipedia
//
//  Created by Steven Lie on 29/07/26.
//

import Combine

public typealias MovieDetailResult = AnyPublisher<MovieDetailModel, Error>
public typealias MovieVideosResult = AnyPublisher<[VideoModel], Error>

protocol GetMovieDetailUseCaseProtocol {
    func execute(movieId: Int) -> MovieDetailResult
}

final class GetMovieDetailUseCase: GetMovieDetailUseCaseProtocol {
    private let repository: MovieDetailRepositoryProtocol

    init(repository: MovieDetailRepositoryProtocol) {
        self.repository = repository
    }

    func execute(movieId: Int) -> MovieDetailResult {
        repository.getMovieDetail(movieId: movieId)
    }
}
