//
//  CountdownView.swift
//  GeoQuebec
//
//  Created by Eric Chandonnet on 2023-11-01.
//

import SwiftUI

struct CountdownView: View {
    @Environment(ViewModel.self) private var viewModel: ViewModel
    @Environment(\.scenePhase) var scenePhase
    @State var timeRemaining: CGFloat
    let timer = Timer.publish(every: 0.1, on: .main, in: .common).autoconnect()
    
    @State private var isActive = true
    
    
    var body: some View {
        VStack {
            Text("\(timeRemaining > 20 ? String(format: "%.0f", timeRemaining) : String(format: "%.1f", timeRemaining))")
                .font(.largeTitle)
                .fontWeight(.heavy)
                .foregroundStyle(timeRemaining > 10 ? .black : .red)
        }
        .padding(10)
        .background(.ultraThinMaterial.opacity(0.8))
        .clipShape(RoundedRectangle(cornerRadius: 20))
        .shadow(radius: 10)
        .onReceive(timer) { time in
            guard isActive else { return }
            if timeRemaining >= 0.1 {
                timeRemaining -= 0.1
            }
            else {
                timeRemaining = 0
                viewModel.endGame()
            }
                
        }
        .onChange(of: scenePhase) { oldPhase, newPhase in
            if newPhase == .active {
                isActive = true
            } else {
                isActive = false
            }
        }
    }
}
                  
#Preview {
    CountdownView(timeRemaining: 200)
        .environment(ViewModel())
}
