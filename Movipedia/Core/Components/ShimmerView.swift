//
//  ShimmerView.swift
//  Movipedia
//
//  Created by Steven Lie on 29/07/26.
//

import SwiftUI

struct ShimmerView: View {
    @State private var isInitialState = true

    var body: some View {
        RoundedRectangle(cornerRadius: 8)
            .fill(
                LinearGradient(
                    gradient: Gradient(colors: [
                        Color(.systemGray5),
                        Color(.systemGray4),
                        Color(.systemGray5)
                    ]),
                    startPoint: isInitialState ? .leading : .trailing,
                    endPoint: isInitialState ? .trailing : .leading
                )
            )
            .onAppear {
                withAnimation(.easeInOut(duration: 1.2).repeatForever(autoreverses: false)) {
                    isInitialState = false
                }
            }
    }
}

struct ShimmerPosterCard: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            ShimmerView()
                .aspectRatio(2/3, contentMode: .fit)

            ShimmerView()
                .frame(height: 14)
                .frame(width: 120)

            ShimmerView()
                .frame(height: 12)
                .frame(width: 80)
        }
    }
}

struct ShimmerRow: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            ShimmerView()
                .frame(height: 16)
                .frame(width: 200)

            ShimmerView()
                .frame(height: 12)

            ShimmerView()
                .frame(height: 12)
                .frame(width: 180)
        }
        .padding(.vertical, 8)
    }
}
