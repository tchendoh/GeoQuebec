//
//  GeoQuebecApp.swift
//  GeoQuebec
//
//  Created by Eric Chandonnet on 2023-10-15.
//

import SwiftUI

@main
struct GeoQuebecApp: App {
    @State private var viewModel = ViewModel()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(viewModel)
        }
    }
}
