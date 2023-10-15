//
//  Area.swift
//  GeoQuebec
//
//  Created by Eric Chandonnet on 2023-10-02.
//

import Foundation
import MapKit
import SwiftUI

enum AreaType: Codable {
    case polygon
    case multiPolygon
    case unspecified
}

struct Area: Identifiable {
    let id = UUID()
    var name: String
    var type: AreaType
    var overlay: MKOverlay
    var areaId: Int
    var answerId: UUID?
}


