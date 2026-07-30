//
//  DiscoverMovieListView.swift
//  Movipedia
//
//  Created by Steven Lie on 29/07/26.
//

import SwiftUI
import Kingfisher

struct DiscoverMovieListView: View {
    @StateObject private var viewModel: DiscoverViewModel

    private let columns = [
        GridItem(.flexible(), spacing: 12),
        GridItem(.flexible(), spacing: 12)
    ]

    init(genre: GenreModel) {
        _viewModel = StateObject(wrappedValue: DiscoverInjection.provideDiscoverViewModel(genre: genre))
    }

    var body: some View {
        Group {
            if viewModel.isLoading && viewModel.movies.isEmpty {
                movieListLoadingView
            } else if let error = viewModel.errorMessage, viewModel.movies.isEmpty {
                ErrorView(message: error) { viewModel.loadMovies() }
            } else if viewModel.movies.isEmpty {
                EmptyStateView(
                    icon: "film.stack",
                    title: "No movies found",
                    subtitle: "There are no movies in the \"\(viewModel.genre.name ?? "")\" genre."
                )
            } else {
                movieGridView
            }
        }
        .background(Color(.systemBackground))
        .navigationTitle(viewModel.genre.name ?? "")
        .onAppear {
            if viewModel.movies.isEmpty {
                viewModel.loadMovies()
            }
        }
    }

    private var movieGridView: some View {
        ScrollView {
            LazyVGrid(columns: columns, spacing: 12) {
                ForEach(viewModel.movies) { movie in
                    NavigationLink {
                        MovieDetailView(movieId: movie.id)
                    } label: {
                        MovieCardView(movie: movie)
                    }
                    .buttonStyle(.plain)
                    .onAppear {
                        viewModel.loadNextPageIfNeeded(currentItem: movie)
                    }
                }
            }
            .padding(16)

            if viewModel.isLoadingNextPage {
                PaginatedLoadMoreView(isLoading: true)
            }
        }
        .scrollContentBackground(.hidden)
        .background(Color(.systemBackground))
    }

    private var movieListLoadingView: some View {
        ScrollView {
            LazyVGrid(columns: columns, spacing: 12) {
                ForEach(0..<10, id: \.self) { _ in
                    ShimmerPosterCard()
                }
            }
            .padding(16)
        }
        .scrollContentBackground(.hidden)
        .background(Color(.systemBackground))
    }
}

struct MovieCardView: View {
    let movie: MovieListItem

    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            KFImage(movie.posterURL)
                .resizable()
                .placeholder {
                    ShimmerView()
                        .aspectRatio(2/3, contentMode: .fit)
                }
                .fade(duration: 0.3)
                .aspectRatio(2/3, contentMode: .fill)
                .clipped()
            
            VStack(alignment: .leading, spacing: 4) {
                Text(movie.title)
                    .font(.poppins(.medium, size: 13))
                    .foregroundColor(.primary)
                    .lineLimit(2)

                HStack(spacing: 4) {
                    Image(systemName: "star.fill")
                        .font(.system(size: 10))
                        .foregroundColor(.orange)

                    Text(movie.rating)
                        .font(.poppins(.regular, size: 12))
                        .foregroundColor(.secondary)
                }
            }
            .padding(8)
        }
        .cardStyle()
    }
}

struct DiscoverMovieListView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            DiscoverMovieListView(genre: GenreModel(id: 28, name: "Action"))
        }
    }
}
