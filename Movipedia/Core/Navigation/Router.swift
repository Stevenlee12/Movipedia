//
//  Router.swift
//  Movipedia
//
//  Created by Steven Lie on 29/07/26.
//

import Combine
import SwiftUI

final class Router: ObservableObject {
    @Published var navigationPath: [Destination] = []

    func push(_ destination: Destination) {
        navigationPath.append(destination)
    }

    func pop() {
        guard !navigationPath.isEmpty else { return }
        navigationPath.removeLast()
    }

    func popToRoot() {
        navigationPath.removeAll()
    }
}

