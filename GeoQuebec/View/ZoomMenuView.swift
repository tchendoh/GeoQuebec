//
//  ZoomMenuView.swift
//  GeoQuebec
//
//  Created by Eric Chandonnet on 2023-10-10.
//

import SwiftUI

struct ZoomMenuView: View {
    @Environment(ViewModel.self) private var viewModel: ViewModel

    var iconSize: CGFloat = 40
    var buttonSize: CGFloat = 50
    var buttonColor: Color = Color("zoomButton")
    
    var body: some View {
        VStack {
            Button {
                viewModel.setCamera(to: .wholeMap)
            } label: {
                HStack {
                    Image(systemName: "arrow.up.left.and.down.right.magnifyingglass")
                        .font(.system(size: iconSize))
                        .foregroundColor(.white)
                }
                .frame(width: buttonSize, height: buttonSize, alignment: .center)
                .background {
                    RoundedRectangle(cornerRadius: 12)
                        .fill(buttonColor)
                }
            }
            Button {
                viewModel.setCamera(to: .focusedArea)
            } label: {
                HStack {
                    Image(systemName: "sparkle.magnifyingglass")
                        .font(.system(size: iconSize))
                        .foregroundColor(.white)
                }
                .frame(width: buttonSize, height: buttonSize, alignment: .center)
                .background {
                    RoundedRectangle(cornerRadius: 12)
                        .fill(buttonColor)
                }
            }

        }
        .padding(10)
        .background(.ultraThinMaterial.opacity(0.8))
        .clipShape(RoundedRectangle(cornerRadius: 20))
        .shadow(radius: 10)
    }
}

#Preview {
    ZoomMenuView()
        .environment(ViewModel())
}
