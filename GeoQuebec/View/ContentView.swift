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
            if viewModel.isGameOver {
                HStack {
                    VStack {
                        ScoreboardView()
                            .padding()
                        Spacer()
                    }
                    Spacer()
                }
            }
        }
    }
}

#Preview {
    ContentView()
        .environment(ViewModel())
    
}
