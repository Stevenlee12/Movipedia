//
//  MovieDetailView.swift
//  Movipedia
//
//  Created by Steven Lie on 29/07/26.
//

import SwiftUI
import Kingfisher

struct MovieDetailView: View {
    @StateObject private var presenter: MovieDetailPresenter
    @State private var showTrailerPlayer = false

    init(movieId: Int) {
        _presenter = StateObject(wrappedValue: MovieDetailBuilder.build(movieId: movieId))
    }

    var body: some View {
        Group {
            if presenter.isLoading || (presenter.movieDetail == nil && presenter.errorMessage == nil) {
                LoadingView("Loading movie details...")
            } else if let error = presenter.errorMessage, presenter.movieDetail == nil {
                ErrorView(message: error) {
                    Task { await presenter.loadMovieDetail() }
                }
            } else if let movie = presenter.movieDetail {
                movieDetailContent(movie)
            }
        }
        .background(Color(.systemBackground))
        .navigationBarTitleDisplayMode(.inline)
        .toolbarBackground(.hidden, for: .navigationBar)
        .task { await presenter.loadMovieDetail() }
        .sheet(isPresented: $showTrailerPlayer) {
            if let key = presenter.officialTrailer?.key {
                YouTubePlayerView(videoKey: key)
                    .edgesIgnoringSafeArea(.all)
            }
        }
    }

    private func movieDetailContent(_ movie: MovieDetailModel) -> some View {
        ScrollView {
            VStack(spacing: 24) {
                backdropSection(movie)
                infoSection(movie)
                overviewSection(movie)
                detailsSection(movie)
                trailerSection
                reviewsSection
            }
        }
        .ignoresSafeArea(edges: [.top, .bottom])
        .scrollContentBackground(.hidden)
        .background(Color(.systemBackground))
    }

    // MARK: - Backdrop

    private func backdropSection(_ movie: MovieDetailModel) -> some View {
        ZStack(alignment: .bottomLeading) {
            KFImage(movie.backdropURL)
                .resizable()
                .placeholder {
                    ShimmerView()
                        .frame(height: 250)
                        .frame(maxWidth: .infinity, alignment: .center)
                }
                .frame(maxWidth: .infinity, maxHeight: 250, alignment: .center)
                .clipped()
                .background(Color(hex: "#F8F8F8"))
                .overlay(
                    LinearGradient(
                        gradient: Gradient(colors: [Color.gray.opacity(0.4), Color.black.opacity(0.0)]),
                        startPoint: .top,
                        endPoint: .bottom
                    )
                    .blendMode(.multiply)
                )

            HStack(alignment: .bottom, spacing: 12) {
                KFImage(movie.posterURL)
                    .resizable()
                    .placeholder {
                        ShimmerView()
                            .frame(width: 80, height: 120)
                    }
                    .fade(duration: 0.3)
                    .scaledToFill()
                    .frame(width: 80, height: 120)
                    .clipped()
                    .cornerRadius(8)
                    .shadow(color: .black.opacity(0.3), radius: 4)

                VStack(alignment: .leading, spacing: 4) {
                    Text(movie.title)
                        .font(.poppins(.bold, size: 20))
                        .foregroundColor(.white)
                        .lineLimit(2)
                        .multilineTextAlignment(.leading)
                        .fixedSize(horizontal: false, vertical: true)

                    HStack(spacing: 8) {
                        Text(movie.year)
                            .font(.poppins(.regular, size: 13))
                            .foregroundColor(.white.opacity(0.8))

                        if movie.runtime != nil {
                            Text(movie.runtimeFormatted)
                                .font(.poppins(.regular, size: 13))
                                .foregroundColor(.white.opacity(0.8))
                        }

                        HStack(spacing: 4) {
                            Image(systemName: "star.fill")
                                .font(.system(size: 11))
                                .foregroundColor(.orange)
                            Text(movie.rating)
                                .font(.poppins(.medium, size: 13))
                                .foregroundColor(.white.opacity(0.9))
                        }
                    }
                }
                .frame(maxWidth: .infinity, alignment: .leading)
            }
            .padding(16)
        }
    }

    // MARK: - Primary Info

    private func infoSection(_ movie: MovieDetailModel) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            if let tagline = movie.tagline, !tagline.isEmpty {
                Text(tagline)
                    .font(.poppins(.medium, size: 14))
                    .foregroundColor(.secondary)
                    .italic()
            }

            Text(movie.genreNames)
                .font(.poppins(.regular, size: 13))
                .foregroundColor(.accentColor)
                .fixedSize(horizontal: false, vertical: true)
                .frame(maxWidth: .infinity, alignment: .leading)
        }
        .padding(.horizontal, 16)
        .frame(maxWidth: .infinity, alignment: .leading)
    }

    // MARK: - Overview

    private func overviewSection(_ movie: MovieDetailModel) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            sectionHeader("Overview")

            if let overview = movie.overview, !overview.isEmpty {
                Text(overview)
                    .font(.poppins(.regular, size: 14))
                    .foregroundColor(.primary)
                    .lineSpacing(4)
                    .fixedSize(horizontal: false, vertical: true)
                    .frame(maxWidth: .infinity, alignment: .leading)
            } else {
                Text("No overview available.")
                    .font(.poppins(.regular, size: 14))
                    .foregroundColor(.secondary)
            }
        }
        .padding(.horizontal, 16)
    }

    // MARK: - Details

    private func detailsSection(_ movie: MovieDetailModel) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            sectionHeader("Details")

            detailRow("Status", movie.status ?? "-")
            detailRow("Release Date", movie.releaseDate ?? "-")
            detailRow("Runtime", movie.runtimeFormatted)
            detailRow("Budget", movie.budgetFormatted)
            detailRow("Revenue", movie.revenueFormatted)
            detailRow("Votes", "\(movie.voteCount)")

            if let companies = movie.productionCompanies, !companies.isEmpty {
                VStack(alignment: .leading, spacing: 4) {
                    Text("Production")
                        .font(.poppins(.medium, size: 14))
                        .foregroundColor(.primary)
                    Text(companies.map(\.name).joined(separator: ", "))
                        .font(.poppins(.regular, size: 13))
                        .foregroundColor(.secondary)
                        .fixedSize(horizontal: false, vertical: true)
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
            }

            if let languages = movie.spokenLanguages, !languages.isEmpty {
                VStack(alignment: .leading, spacing: 4) {
                    Text("Languages")
                        .font(.poppins(.medium, size: 14))
                        .foregroundColor(.primary)
                    Text(languages.map(\.englishName).joined(separator: ", "))
                        .font(.poppins(.regular, size: 13))
                        .foregroundColor(.secondary)
                        .fixedSize(horizontal: false, vertical: true)
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
            }
        }
        .padding(.horizontal, 16)
    }

    private func detailRow(_ label: String, _ value: String) -> some View {
        HStack(alignment: .top) {
            Text(label)
                .font(.poppins(.medium, size: 14))
                .foregroundColor(.primary)
                .frame(width: 100, alignment: .leading)
            Text(value)
                .font(.poppins(.regular, size: 13))
                .foregroundColor(.secondary)
                .fixedSize(horizontal: false, vertical: true)
                .frame(maxWidth: .infinity, alignment: .leading)
            Spacer(minLength: 0)
        }
    }

    // MARK: - Trailers

    private var trailerSection: some View {
        Group {
            if presenter.isLoadingVideos {
                VStack(spacing: 8) {
                    sectionHeader("Trailers")
                    ProgressView()
                        .padding(.vertical, 20)
                        .frame(maxWidth: .infinity)
                }
                .padding(.horizontal, 16)
            } else if let trailer = presenter.officialTrailer {
                VStack(alignment: .leading, spacing: 12) {
                    sectionHeader("Trailers")

                    VStack(alignment: .leading, spacing: 4) {
                        Text(trailer.name ?? "-")
                            .font(.poppins(.medium, size: 13))
                            .foregroundColor(.primary)

                        if let key = trailer.key {
                            KFImage(URL(string: "https://img.youtube.com/vi/\(key)/hqdefault.jpg"))
                                .resizable()
                                .placeholder {
                                    ShimmerView()
                                        .frame(height: 200)
                                }
                                .fade(duration: 0.3)
                                .aspectRatio(16 / 9, contentMode: .fill)
                                .frame(maxWidth: .infinity)
                                .frame(height: 200)
                                .clipped()
                                .cornerRadius(8)
                                .shadow(color: .black.opacity(0.1), radius: 4)
                                .overlay(
                                    Image(systemName: "play.circle.fill")
                                        .font(.system(size: 44))
                                        .foregroundColor(.white.opacity(0.9))
                                        .shadow(color: .black.opacity(0.4), radius: 4)
                                )
                        }
                    }
                    .contentShape(Rectangle())
                    .onTapGesture { showTrailerPlayer = true }
                }
                .padding(.horizontal, 16)
            } else {
                EmptyStateView(
                    icon: "play.rectangle",
                    title: "No trailers available",
                    subtitle: "Trailers for this movie are not available yet."
                )
                .padding(.bottom, 32)
                .padding(.horizontal, 16)
            }
        }
        .task { await presenter.loadVideos() }
    }

    // MARK: - Reviews

    private var reviewsSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            sectionHeader("Reviews")

            if presenter.isLoadingReviews {
                VStack(spacing: 12) {
                    ForEach(0..<3, id: \.self) { _ in
                        ShimmerRow()
                    }
                }
            } else if presenter.reviews.isEmpty {
                EmptyStateView(
                    icon: "bubble.left",
                    title: "No reviews yet",
                    subtitle: "Reviews for this movie will appear here."
                )
                .padding(.bottom, 32)
            } else {
                LazyVStack(spacing: 16) {
                    ForEach(presenter.reviews) { review in
                        reviewCard(review)
                            .task {
                                await presenter.loadNextReviewsIfNeeded(currentItem: review)
                            }
                    }

                    if presenter.isLoadingNextReviews {
                        PaginatedLoadMoreView(isLoading: true)
                    }
                }
            }
        }
        .padding(.horizontal, 16)
        .task { await presenter.loadReviewsIfNeeded() }
    }

    private func reviewCard(_ review: ReviewModel) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack(spacing: 10) {
                KFImage(review.avatarURL)
                    .resizable()
                    .placeholder {
                        Circle()
                            .fill(Color(.systemGray4))
                            .frame(width: 36, height: 36)
                            .overlay(
                                Image(systemName: "person.fill")
                                    .foregroundColor(.secondary)
                            )
                    }
                    .fade(duration: 0.2)
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 36, height: 36)
                    .clipShape(Circle())

                VStack(alignment: .leading, spacing: 2) {
                    Text(review.author)
                        .font(.poppins(.medium, size: 14))
                        .foregroundColor(.primary)

                    HStack(spacing: 4) {
                        if let rating = review.rating, rating > 0 {
                            HStack(spacing: 2) {
                                Image(systemName: "star.fill")
                                    .font(.system(size: 10))
                                    .foregroundColor(.orange)
                                Text(String(format: "%.1f", rating))
                                    .font(.poppins(.regular, size: 12))
                                    .foregroundColor(.secondary)
                            }
                        }
                        Text(review.formattedDate)
                            .font(.poppins(.regular, size: 11))
                            .foregroundColor(.secondary)
                    }
                }

                Spacer()
            }

            Text(review.content)
                .font(.poppins(.regular, size: 13))
                .foregroundColor(.primary)
                .lineLimit(6)
                .lineSpacing(2)
                .fixedSize(horizontal: false, vertical: true)
                .frame(maxWidth: .infinity, alignment: .leading)
        }
        .padding(12)
        .cardStyle()
    }

    // MARK: - Helpers

    private func sectionHeader(_ title: String) -> some View {
        Text(title)
            .font(.poppins(.semibold, size: 16))
            .foregroundColor(.primary)
    }
}

struct MovieDetailView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            MovieDetailView(movieId: 550)
        }
    }
}
