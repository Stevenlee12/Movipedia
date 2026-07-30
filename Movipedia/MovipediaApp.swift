//
//  MovipediaApp.swift
//  Movipedia
//
//  Created by Steven Lie on 29/07/26.
//

import SwiftUI

@main
struct MovipediaApp: App {
    @StateObject private var router = Router()

    var body: some Scene {
        WindowGroup {
            NavigationStack(path: $router.navigationPath) {
                GenreListView(router: router)
                    .navigationDestination(for: Destination.self) { destination in
                        view(for: destination)
                    }
            }
        }
    }

    @ViewBuilder
    private func view(for destination: Destination) -> some View {
        switch destination {
        case .discoverMovies(let genre):
            DiscoverMovieListView(genre: genre, router: router)
        case .movieDetail(let movieId):
            MovieDetailView(movieId: movieId, router: router)
        }
    }
}
