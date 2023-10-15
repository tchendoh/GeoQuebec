//
//  AnswerListView.swift
//  GeoQuebec
//
//  Created by Eric Chandonnet on 2023-10-07.
//

import SwiftUI

struct AnswerListView: View {
    @Environment(ViewModel.self) private var viewModel: ViewModel

    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack (spacing: 1) {
                if viewModel.isGameOver {
                    Text("GAME OVER")
                        .font(.largeTitle)
                        .bold()
                }
                ForEach(viewModel.answers) { answer in
                    AnswerCard(answer: answer)
                }
            }
            .padding(10)
            .frame(width: 280)
        }
        .background(.ultraThinMaterial.opacity(0.8))
        .clipShape(RoundedRectangle(cornerRadius: 20))
        .shadow(radius: 10)
    }
}

#Preview {
    AnswerListView()
        .environment(ViewModel())

}
