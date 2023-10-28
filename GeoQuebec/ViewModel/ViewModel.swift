//
//  ViewModel.swift
//  GeoQ
//
//  Created by Eric Chandonnet on 2023-10-06.
//

import Foundation
import MapKit
import Observation
import SwiftUI

enum ZoomCommand: String {
    case wholeMap
    case focusedArea
}

enum AreaSize: Double {
    case tiny = 200_000
    case small = 1_500_000
    case mid = 2_500_000
    case big = 4_000_000
}

@Observable class ViewModel {
    
    var areas: [Area] = []
    var answers: [Answer] = []
    var choices: [Int: UUID] = [:]
    var cameraPosition: MapCameraPosition = .automatic
    var isGameOver: Bool = false
    var focusedAreaId: Int?
    var unvailedAreas: Set<Int> = []
    
    init() {
        Task {
            areas = await GeoJsonService.getAreas()
//            areas = Array(areas.prefix(5)) // To test faster with less regions
            distributeRandomIdsToAreas()
            generateAnswers()
            sortAnswersByName() // not traduction friendly yet
            setCamera(to: .wholeMap)
        }
    }
    
    private func distributeRandomIdsToAreas() {
        areas.shuffle()
        var areaId = 0
        areas.indices.forEach { index in
            areaId += 1
            areas[index].areaId = areaId
        }
    }
    
    private func generateAnswers() {
        var alreadyThere: [Int] = []
        for area in areas {
            if !alreadyThere.contains(area.areaId) {
                answers.append(Answer(areaId: area.areaId, name: area.name))
                alreadyThere.append(area.areaId)
            }
        }
    }
    
    private func sortAnswersByName() {
        answers.sort { lhs, rhs in
            lhs.name < rhs.name
        }
    }
        
    func indexOf(areaId: Int) -> Int? {
        return areas.firstIndex(where: { $0.areaId == areaId })
    }
        
    func indexOf(answerId: UUID) -> Int? {
        return answers.firstIndex(where: { $0.id == answerId })
    }

}

// MARK: Choice related
extension ViewModel {
    func isAttributed(areaId: Int) -> Bool {
        choices.keys.contains(areaId)
    }
    
    func isAttributed(answerId: UUID) -> Bool {
        choices.values.contains(answerId)
    }
    
    func getAreaIdFromAnswerId(_ answerId: UUID) -> Int? {
        guard let choice = choices.first(where: { $0.value == answerId} ) else {
            return nil
        }
        return choice.key
    }
    
    func getAnswerIdFromAreaId(_ areaId: Int) -> UUID? {
        choices[areaId]
    }

    func getAttributedName(areaId: Int) -> String? {
        guard let answerId = getAnswerIdFromAreaId(areaId) else {
            print("No answerId for areaId \(areaId)")
            return nil
        }
        guard let index = indexOf(answerId: answerId) else {
            print("No index for answerId \(answerId).")
            return nil
        }
        return answers[index].name
    }
    
    func makeChoice(areaId: Int, answerId: UUID) {
        choices[areaId] = answerId
    }

    func removeChoice(areaId: Int) {
        choices.removeValue(forKey: areaId)
    }

}

// MARK: Focus related
extension ViewModel {
    
    func isFocused(areaId: Int) -> Bool {
        focusedAreaId == areaId
    }
    
    func setFocusToAreaId(_ areaId: Int) {
        focusedAreaId = areaId
    }

    func unfocusAll() {
        focusedAreaId = nil
    }

    func selectNextArea() {
        let listOfAllAreaIds = answers.map { $0.areaId }
        let remainingAreaIds = listOfAllAreaIds.filter { !choices.keys.contains($0) }
        
        if remainingAreaIds.isEmpty {
            endGame()
            return
        }
        guard let areaId = remainingAreaIds.min() else {
            print("Failed at selecting a next area.")
            return
        }
        focusedAreaId = areaId
        setCamera(to: .focusedArea)
    }
    
    func endGame() {
        isGameOver = true
        focusedAreaId = nil
        selectNextResult()
    }

}

// MARK: Camera related
extension ViewModel {
    func setCamera(to zoomCommand: ZoomCommand) {
        var newCameraPosition: MapCameraPosition
        switch zoomCommand {
        case .wholeMap:
            newCameraPosition = .region(.quebecProvince)
        case .focusedArea:
            guard let areaId = focusedAreaId else {
                print("Can't move camera to area because no area is focused.")
                return
            }
            guard let index = indexOf(areaId: areaId) else {
                print("Can't move camera because no index was found.")
                return
            }
            let areaCenterPoint = areas[index].overlay.coordinate
            let areaSize = areas[index].overlay.boundingMapRect.size
            
            switch getAreaSize(size: areaSize) {
            case .tiny:
                newCameraPosition = .camera(MapCamera(centerCoordinate: areaCenterPoint, distance: AreaSize.tiny.rawValue))
            case .small:
                newCameraPosition = .camera(MapCamera(centerCoordinate: areaCenterPoint, distance: AreaSize.small.rawValue))
            case .mid:
                newCameraPosition = .camera(MapCamera(centerCoordinate: areaCenterPoint, distance: AreaSize.mid.rawValue))
            case .big:
                newCameraPosition = .region(.quebecProvince)
            }
        }
        withAnimation {
            cameraPosition = newCameraPosition
        }
    }
    
    private func getAreaSize(size: MKMapSize) -> AreaSize {
        var areaArea = size.height * size.width
        areaArea /= 1000000000000

        if areaArea < 1 {
            return .tiny
        } else if areaArea < 2 {
            return .small
        } else if areaArea < 10 {
            return .mid
        } else {
            return .big
        }
    }
}

// MARK: The endgame
extension ViewModel {
    
    func getNameFromAnswerId(_ answerId: UUID) -> String? {
        guard let index = indexOf(answerId: answerId) else {
            print("No index for answerId \(answerId).")
            return nil
        }
        return answers[index].name
    }
    
    func getRealNameFromAreaId(_ areaId: Int) -> String? {
        guard let index = indexOf(areaId: areaId) else {
            print("No index for areaId \(areaId).")
            return nil
        }
        return areas[index].name
    }
    
    func getAnswer(answerId: UUID) -> Answer? {
        guard let answer = answers.first(where: { $0.id == answerId} ) else {
            print("No answer for answerId \(answerId) ")
            return nil
        }
        return answer
    }

    
    func isChoiceRight(areaId: Int) -> Bool {
        guard let answerId = getAnswerIdFromAreaId(areaId) else {
            return false
        }
        guard let answer = getAnswer(answerId: answerId) else {
            return false
        }
        
        return areaId == answer.areaId
    }

    func isUnvailed(areaId: Int) -> Bool {
        return unvailedAreas.contains(areaId)
    }
    
    func unvailResult(areaId: Int) {
        unvailedAreas.insert(areaId)
    }

    func selectNextResult() {
        let listOfAllAreaIds = answers.map { $0.areaId }
        let remainingAreaIds = listOfAllAreaIds.filter { !unvailedAreas.contains($0) }
        
        if remainingAreaIds.isEmpty {
            focusedAreaId = nil
            setCamera(to: .wholeMap)
            return
        }
        guard let areaId = remainingAreaIds.min() else {
            print("Failed at selecting a next result/area.")
            return
        }
        focusedAreaId = areaId
        setCamera(to: .focusedArea)
    }

}

// MARK: The ScoreBoard
extension ViewModel {
    func getScoreMaximum() -> Int {
        unvailedAreas.count
    }
    
    func getCurrentScore() -> Int {
        unvailedAreas.filter { isChoiceRight(areaId: $0) }.count
    }
}
