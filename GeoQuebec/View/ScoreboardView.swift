//
//  ScoreboardView.swift
//  GeoQuebec
//
//  Created by Eric Chandonnet on 2023-10-28.
//

import SwiftUI

struct ScoreboardView: View {
    @Environment(ViewModel.self) private var viewModel: ViewModel

    var body: some View {
        VStack {
            Text("\(viewModel.getCurrentScore()) / \(viewModel.getScoreMaximum()) ")
                .font(.largeTitle)
        }
        .padding(10)
        .background(.ultraThinMaterial.opacity(0.8))
        .clipShape(RoundedRectangle(cornerRadius: 20))
        .shadow(radius: 10)
    }
}

#Preview {
    ScoreboardView()
        .environment(ViewModel())
}
