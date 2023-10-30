//
//  ContentView.swift
//  GeoQuebec
//
//  Created by Eric Chandonnet on 2023-10-01.
//

import SwiftUI
import MapKit


struct ContentView: View {
    @Environment(ViewModel.self) private var viewModel: ViewModel
    @State var endGameEffect: CGFloat = 0.0
    
    var body: some View {
        ZStack {
            MapView()
                .safeAreaInset(edge: .leading) {
                    ZoomMenuView()
                        .padding()
                }
                .safeAreaInset(edge: .trailing, alignment: .center) {
                    if viewModel.isGameOver {
                        ResultListView()
                            .padding()
                    }
                    else {
                        AnswerListView()
                            .padding()
                        
                    }
                }
            HStack {
                VStack {
                    if viewModel.isGameOver {
                        ScoreboardView()
                            .padding()
                    } else {
                        CountdownView(timeRemaining: CGFloat(viewModel.answers.count) * 10)
                            .padding()
                    }
                    Spacer()
                }
                Spacer()
            }
            Color.green
                .ignoresSafeArea()
                .opacity(endGameEffect)
        }
        .onChange(of: viewModel.isGameOver) { oldValue, newValue in
            withAnimation(.easeOut(duration: 1.2)) {
                endGameEffect = 1.0
            } completion: {
                withAnimation {
                    endGameEffect = 0.0
                }
            
            }

        }

    }
}

#Preview {
    ContentView()
        .environment(ViewModel())
    
}
