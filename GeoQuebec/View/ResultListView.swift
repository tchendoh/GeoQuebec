//
//  ResultListView.swift
//  GeoQuebec
//
//  Created by Eric Chandonnet on 2023-10-17.
//

import SwiftUI

struct ResultListView: View {
    @Environment(ViewModel.self) private var viewModel: ViewModel

    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack (spacing: 1) {
                ForEach(viewModel.areaList, id: \.self) { areaId in
                    ZStack {
                        ResultCard(areaId: areaId)
                    }
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
    ResultListView()
        .environment(ViewModel())
}
