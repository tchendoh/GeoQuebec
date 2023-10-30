//
//  AnswerCard.swift
//  GeoQuebec
//
//  Created by Eric Chandonnet on 2023-10-07.
//

import SwiftUI

struct AnswerCard: View {
    @Environment(ViewModel.self) private var viewModel: ViewModel
    var answer: Answer
    let circleSize: CGFloat = 30
    
    var body: some View {
        HStack(spacing: 0) {
            ZStack {
                if let areaId = viewModel.getAreaIdFromAnswerId(answer.id) {
                    Circle()
                        .fill(Color("answerCard").opacity(0.8))
                        .frame(width: circleSize)
                    Image(systemName: "\(areaId).circle")
                        .font(.system(size: circleSize - 6))
                        .foregroundColor(Color("answerCardTitle"))
                        .bold()
                        .opacity(areaId == viewModel.focusedAreaId ? 1 : 0.9)
                }
                else {
                    Circle()
                        .fill(viewModel.focusedAreaId != nil ? Color("answerCardTitle") : .white)
                        .frame(width: circleSize)
                        .shadow(radius: 2)
                }
            }
            .padding(5)
            Spacer()
            VStack(alignment: .leading) {
                Text("\(answer.name)")
                    .font(.system(size: getNameFontSize(answer.name)))
                    .foregroundStyle(Color("answerCardTitle"))
                    .lineLimit(1)
            }
            .padding(.trailing, 10)
            .padding(.vertical, 8)
        }
        .background {
            ZStack(alignment: .top) {
                if let attributedAreaId = viewModel.getAreaIdFromAnswerId(answer.id) {
                    Rectangle()
                        .foregroundColor(Color("answerCard").opacity(attributedAreaId == viewModel.focusedAreaId ? 1.0 : 0.3))
                }
                else {
                    Rectangle()
                        .foregroundColor(Color("answerCard").opacity(0.8))
                }
            }
        }
        .clipShape(RoundedRectangle(cornerRadius: 8, style: .continuous))
        .shadow(radius: 4)
        .onTapGesture {
            if let attributedAreaId = viewModel.getAreaIdFromAnswerId(answer.id) {
                viewModel.setFocusToAreaId(attributedAreaId)
                viewModel.setCamera(to: .focusedArea)
            }
            else {
                if let focusedAreaId = viewModel.focusedAreaId {
                    viewModel.addChoice(areaId: focusedAreaId, answerId: answer.id)
                    viewModel.selectNextArea()
                }
            }
        }
    }
    
    func getNameFontSize(_ text: String) -> CGFloat {
        if text.count > 24 {
            return 14
        }
        return 18
    }
}

#Preview {
    HStack {
        Spacer()
        VStack {
            Spacer()
            AnswerCard(answer: Answer(areaId: 12, name: "Abitibi-Témiscamingue"))
                .environment(ViewModel())
            Spacer()
        }
        Spacer()

    }
    .background(.gray)
}
