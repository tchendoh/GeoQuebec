//
//  ResultCard.swift
//  GeoQuebec
//
//  Created by Eric Chandonnet on 2023-10-24.
//

import SwiftUI

struct ResultCard: View {
    @Environment(ViewModel.self) private var viewModel: ViewModel
    var areaId: Int
    let circleSize: CGFloat = 40
    
    var body: some View {
        ZStack {
            HStack(spacing: 0) {
                ZStack {
                    Circle()
                        .fill(getNumberColor(areaId: areaId))
                        .frame(width: circleSize)
                    Image(systemName: "\(areaId).circle")
                        .font(.system(size: circleSize - 6))
                        .foregroundColor(Color("answerCardTitle"))
                        .bold()
                        .padding(5)
                }
                HStack {
                    ZStack {
                        if let answerId = viewModel.choices[areaId] {
                            if let guessedName = viewModel.getNameFromAnswerId(answerId) {
                                Text("\(guessedName)")
                                    .font(.system(size: getNameFontSize(guessedName)))
                                    .foregroundStyle(Color("answerCardTitle"))
                                    .lineLimit(1)
                            }
                        }
                        else {
                            Text("---")
                                .font(.system(size: getNameFontSize("---")))
                                .foregroundStyle(Color("answerCardTitle"))

                        }
                    }
                    Spacer()
                }
                .padding(.trailing, 10)
                .padding(.vertical, 8)
                
            }
            .background {
                Rectangle()
                    .foregroundColor(getResultColor(areaId: areaId))
                    .opacity(viewModel.isFocused(areaId: areaId) ? 1 : 0.8)
            }
            .overlay {
                if viewModel.isUnvailed(areaId: areaId) {
                    if viewModel.isChoiceRight(areaId: areaId) {
                    }
                    else {
                        if let realName = viewModel.getRealNameFromAreaId(areaId) {
                            HStack {
                                Spacer()
                                Text("\(realName)")
                                    .font(.system(size: getNameFontSize(realName) - 5))
                                    .lineLimit(1)
                                    .foregroundColor(.white)
                                    .padding(.horizontal, 8)
                                    .padding(.vertical, 4)
                                    .background(
                                        RoundedRectangle(cornerRadius: 12)
                                            .foregroundColor(.pink)
                                            .overlay(
                                                RoundedRectangle(cornerRadius: 12)
                                                    .stroke(Color.white, lineWidth: 2)
                                            )
                                            .shadow(radius: 4)
                                    )
                                    .rotationEffect(Angle.degrees(-8))
                            }
                            
                            
                        }
                    }
                    
                }
            }
            .clipShape(RoundedRectangle(cornerRadius: 8, style: .continuous))
            .onTapGesture {
                if viewModel.isUnvailed(areaId: areaId) {
                    if viewModel.isFocused(areaId: areaId) {
                        viewModel.unfocusAll()
                        viewModel.setCamera(to: .wholeMap)
                    }
                    else {
                        viewModel.setFocusToAreaId(areaId)
                        viewModel.setCamera(to: .focusedArea)
                    }
                }
                else {
                    if viewModel.isFocused(areaId: areaId) {
                        viewModel.unvailResult(areaId: areaId)
                        viewModel.selectNextResult()
                    }
                    else {
                        viewModel.setFocusToAreaId(areaId)
                        viewModel.setCamera(to: .focusedArea)
                    }
                }
            }
            .shadow(radius: 4)
        }
        if viewModel.isChoiceRight(areaId: areaId) &&  viewModel.isUnvailed(areaId: areaId) {
            HStack {
                Spacer()
                Image(systemName: "checkmark.diamond.fill")
                    .font(.system(size: 25))
                    .foregroundColor(.green)
                    .scrollClipDisabled()
                    .shadow(radius: 4)
            }
            .scrollClipDisabled()
        }
        
    }
    
    func getNameFontSize(_ text: String) -> CGFloat {
        if text.count > 24 {
            return 14
        }
        return 18
    }
    
    func getNumberColor(areaId: Int) -> Color {
        if viewModel.isUnvailed(areaId: areaId) {
            if viewModel.isChoiceRight(areaId: areaId) {
                return .green
            }
            else {
                return .red
            }
        }
        else {
            return .black
            
        }
    }
    
    func getResultColor(areaId: Int) -> Color {
        if viewModel.isUnvailed(areaId: areaId) {
            if viewModel.isFocused(areaId: areaId) {
                if viewModel.isChoiceRight(areaId: areaId) {
                    return Color("resultRight")
                }
                else {
                    return Color("resultWrong")
                }
            }
            else {
                if viewModel.isChoiceRight(areaId: areaId) {
                    return Color("resultRight").opacity(0.8)
                }
                else {
                    return Color("resultWrong").opacity(0.8)
                }
            }
        }
        else {
            if viewModel.isFocused(areaId: areaId) {
                return Color("resultFocused")
            }
            else {
                return Color("resultHidden").opacity(0.8)
            }
        }
    }
    
}

#Preview {
    ContentView()
        .environment(ViewModel())
}
