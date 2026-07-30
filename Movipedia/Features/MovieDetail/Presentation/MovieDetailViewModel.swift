//
//  MovieDetailViewModel.swift
//  Movipedia
//
//  Created by Steven Lie on 29/07/26.
//

import Foundation
import Combine

@MainActor
final class MovieDetailViewModel: ObservableObject {
    let movieId: Int
    private let getMovieDetailUseCase: GetMovieDetailUseCaseProtocol
    private let getMovieReviewsUseCase: GetMovieReviewsUseCaseProtocol
    private let repository: MovieDetailRepositoryProtocol

    @Published var movieDetail: MovieDetailModel?
    @Published var reviews: [ReviewModel] = []
    @Published var videos: [VideoModel] = []

    @Published var isLoading = false
    @Published var isLoadingReviews = false
    @Published var isLoadingNextReviews = false
    @Published var isLoadingVideos = false

    @Published var errorMessage: String?

    private var reviewsCurrentPage = 1
    private var reviewsTotalPages = 1
    private var isLoadingReviewsPage = false

    private var cancellables: Set<AnyCancellable> = []

    init(
        movieId: Int,
        getMovieDetailUseCase: GetMovieDetailUseCaseProtocol,
        getMovieReviewsUseCase: GetMovieReviewsUseCaseProtocol,
        repository: MovieDetailRepositoryProtocol
    ) {
        self.movieId = movieId
        self.getMovieDetailUseCase = getMovieDetailUseCase
        self.getMovieReviewsUseCase = getMovieReviewsUseCase
        self.repository = repository
    }

    func loadMovieDetail() {
        isLoading = true
        errorMessage = nil

        getMovieDetailUseCase.execute(movieId: movieId)
            .subscribe(on: DispatchQueue.global(qos: .background))
            .receive(on: RunLoop.main)
            .sink { [weak self] completion in
                self?.isLoading = false
                if case .failure(let error) = completion {
                    self?.errorMessage = error.localizedDescription
                }
            } receiveValue: { [weak self] detail in
                self?.movieDetail = detail
            }
            .store(in: &cancellables)
    }

    func loadReviewsIfNeeded() {
        guard reviews.isEmpty, !isLoadingReviews else { return }
        loadReviews()
    }

    func loadReviews() {
        guard !isLoadingReviewsPage else { return }
        isLoadingReviews = true
        isLoadingReviewsPage = true

        getMovieReviewsUseCase.execute(movieId: movieId, page: 1)
            .subscribe(on: DispatchQueue.global(qos: .background))
            .receive(on: RunLoop.main)
            .sink { [weak self] completion in
                self?.isLoadingReviews = false
                self?.isLoadingReviewsPage = false
            } receiveValue: { [weak self] result in
                self?.reviews = result.reviews
                self?.reviewsTotalPages = result.totalPages
                self?.reviewsCurrentPage = 1
            }
            .store(in: &cancellables)
    }

    func loadNextReviewsIfNeeded(currentItem: ReviewModel?) {
        guard let currentItem = currentItem else { return }

        let thresholdIndex = reviews.index(reviews.endIndex, offsetBy: -4)
        if reviews.firstIndex(where: { $0.id == currentItem.id }) ?? 0 >= thresholdIndex {
            loadNextReviews()
        }
    }

    private func loadNextReviews() {
        guard reviewsCurrentPage < reviewsTotalPages, !isLoadingReviewsPage else { return }
        isLoadingNextReviews = true
        isLoadingReviewsPage = true

        let nextPage = reviewsCurrentPage + 1

        getMovieReviewsUseCase.execute(movieId: movieId, page: nextPage)
            .subscribe(on: DispatchQueue.global(qos: .background))
            .receive(on: RunLoop.main)
            .sink { [weak self] completion in
                self?.isLoadingNextReviews = false
                self?.isLoadingReviewsPage = false
            } receiveValue: { [weak self] result in
                self?.reviews.append(contentsOf: result.reviews)
                self?.reviewsCurrentPage = nextPage
            }
            .store(in: &cancellables)
    }

    func loadVideos() {
        guard !isLoadingVideos else { return }
        isLoadingVideos = true

        repository.getMovieVideos(movieId: movieId)
            .subscribe(on: DispatchQueue.global(qos: .background))
            .receive(on: RunLoop.main)
            .sink { [weak self] completion in
                self?.isLoadingVideos = false
                if case .failure(let error) = completion {
                    self?.errorMessage = error.localizedDescription
                }
            } receiveValue: { [weak self] videos in
                self?.videos = videos
            }
            .store(in: &cancellables)
    }

    var officialTrailer: VideoModel? {
        videos.first {
            $0.site?.lowercased() == "youtube"
                && $0.type?.lowercased() == "trailer"
        }
    }
}
