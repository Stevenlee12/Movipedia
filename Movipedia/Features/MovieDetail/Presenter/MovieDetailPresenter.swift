//
//  MovieDetailPresenter.swift
//  Movipedia
//
//  Created by Steven Lie on 29/07/26.
//

import Combine
import Foundation

@MainActor
final class MovieDetailPresenter: ObservableObject {
    let movieId: Int

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

    private let interactor: MovieDetailInteractorProtocol

    init(movieId: Int, interactor: MovieDetailInteractorProtocol) {
        self.movieId = movieId
        self.interactor = interactor
    }

    func loadMovieDetail() async {
        isLoading = true
        errorMessage = nil

        do {
            movieDetail = try await interactor.fetchMovieDetail(movieId: movieId)
        } catch {
            errorMessage = error.localizedDescription
        }

        isLoading = false
    }

    func loadReviewsIfNeeded() async {
        guard reviews.isEmpty, !isLoadingReviews else { return }
        await loadReviews()
    }

    func loadReviews() async {
        guard !isLoadingReviewsPage else { return }
        isLoadingReviews = true
        isLoadingReviewsPage = true

        do {
            let result = try await interactor.fetchMovieReviews(movieId: movieId, page: 1)
            reviews = result.reviews
            reviewsTotalPages = result.totalPages
            reviewsCurrentPage = 1
        } catch {}

        isLoadingReviews = false
        isLoadingReviewsPage = false
    }

    func loadNextReviewsIfNeeded(currentItem: ReviewModel?) async {
        guard let currentItem = currentItem else { return }

        let thresholdIndex = reviews.index(reviews.endIndex, offsetBy: -4)
        if reviews.firstIndex(where: { $0.id == currentItem.id }) ?? 0 >= thresholdIndex {
            await loadNextReviews()
        }
    }

    private func loadNextReviews() async {
        guard reviewsCurrentPage < reviewsTotalPages, !isLoadingReviewsPage else { return }
        isLoadingNextReviews = true
        isLoadingReviewsPage = true

        let nextPage = reviewsCurrentPage + 1

        do {
            let result = try await interactor.fetchMovieReviews(movieId: movieId, page: nextPage)
            reviews.append(contentsOf: result.reviews)
            reviewsCurrentPage = nextPage
        } catch {}

        isLoadingNextReviews = false
        isLoadingReviewsPage = false
    }

    func loadVideos() async {
        guard !isLoadingVideos else { return }
        isLoadingVideos = true

        do {
            videos = try await interactor.fetchMovieVideos(movieId: movieId)
        } catch {}

        isLoadingVideos = false
    }

    var officialTrailer: VideoModel? {
        videos.first {
            $0.site?.lowercased() == "youtube"
                && $0.type?.lowercased() == "trailer"
        }
    }
}
