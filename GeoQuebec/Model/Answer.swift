//
//  Answer.swift
//  GeoQuebec
//
//  Created by Eric Chandonnet on 2023-10-07.
//

import Foundation

struct Answer: Identifiable {
    var id = UUID()
    var areaId: Int
    var name: String
}
