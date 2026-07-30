//
//  GenreListView.swift
//  Movipedia
//
//  Created by Steven Lie on 29/07/26.
//

import SwiftUI

struct GenreListView: View {
    @StateObject private var presenter = GenreBuilder.build()
    private let router = GenreRouter()

    private let columns = [
        GridItem(.flexible(), spacing: 12),
        GridItem(.flexible(), spacing: 12)
    ]

    var body: some View {
        Group {
            if presenter.isLoading && presenter.genres.isEmpty {
                genreListLoadingView
            } else if let error = presenter.errorMessage, presenter.genres.isEmpty {
                ErrorView(message: error) {
                    Task { await presenter.loadGenres() }
                }
            } else if presenter.genres.isEmpty {
                EmptyStateView(title: "No genres found")
            } else {
                genreGridView
            }
        }
        .background(Color(.systemBackground))
        .navigationTitle("Genres")
        .task { await presenter.loadGenresIfNeeded() }
    }

    private var genreGridView: some View {
        ScrollView {
            LazyVGrid(columns: columns, spacing: 12) {
                ForEach(presenter.genres) { genre in
                    NavigationLink {
                        router.makeDiscoverView(genre: genre)
                    } label: {
                        genreCard(genre)
                    }
                    .buttonStyle(.plain)
                }
            }
            .padding(16)
        }
        .scrollContentBackground(.hidden)
        .background(Color(.systemBackground))
    }

    private func genreCard(_ genre: GenreModel) -> some View {
        VStack(spacing: 8) {
            Image(systemName: genreIcon(for: genre.id))
                .font(.system(size: 32))
                .foregroundColor(.mainColor)

            Text(genre.name ?? "-")
                .font(.poppins(.medium, size: 14))
                .foregroundColor(.primary)
                .multilineTextAlignment(.center)
                .lineLimit(2)
        }
        .frame(maxWidth: .infinity)
        .frame(height: 100)
        .cardStyle()
    }

    private var genreListLoadingView: some View {
        ScrollView {
            LazyVGrid(columns: columns, spacing: 12) {
                ForEach(0..<20, id: \.self) { _ in
                    ShimmerView()
                        .frame(height: 100)
                        .cornerRadius(12)
                }
            }
            .padding(16)
        }
        .scrollContentBackground(.hidden)
        .background(Color(.systemBackground))
    }

    private func genreIcon(for id: Int) -> String {
        switch id {
        case 28: return "flame.fill"
        case 12: return "globe.asia.australia.fill"
        case 16: return "sparkles"
        case 35: return "face.smiling.fill"
        case 80: return "lock.shield.fill"
        case 99: return "doc.text.fill"
        case 18: return "theatermasks.fill"
        case 10751: return "house.fill"
        case 14: return "wand.and.stars"
        case 36: return "crown.fill"
        case 27: return "moon.stars.fill"
        case 10402: return "music.note"
        case 9648: return "magnifyingglass"
        case 10749: return "heart.fill"
        case 878: return "paperplane.fill"
        case 10770: return "tv.fill"
        case 53: return "bolt.fill"
        case 10752: return "shield.fill"
        case 37: return "sun.max.fill"
        default: return "movieclapper.fill"
        }
    }
}

struct GenreListView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            GenreListView()
        }
    }
}
