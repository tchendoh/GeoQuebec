//
//  GeoJsonService.swift
//  GeoQuebec
//
//  Created by Eric Chandonnet on 2023-10-06.
//


import Foundation
import MapKit

struct Region: Codable {
    var res_nm_reg: String
}

/// The kinds of errors that occur when loading feature data.
enum ImportJSONError: Error {
    case wrongDataFormat(error: Error)
    case missingData
}

final class GeoJsonService {
    
    static func getAreas() async -> [Area] {
        var areas: [Area] = []
        
        do {
            let featureCollection = try await fetchGeoObjects()
                        
            for feature in featureCollection {
                var name = ""
                switch feature {
                case let feature as MKGeoJSONFeature:
                    if let propertyData = feature.properties {
                        do {
                            let regionProps = try JSONDecoder().decode(Region.self, from: propertyData)
                            name = regionProps.res_nm_reg
                            // print(name)
                        }
                        catch {
                            print(error)
                        }
                    }
                    for geo in feature.geometry {
                        switch geo {
                        case let poly as MKPolygon :
                            areas.append(Area(name: name, type: AreaType.polygon, overlay: poly, areaId: 0))
                        case let multi as MKMultiPolygon :
                            areas.append(Area(name: name, type: AreaType.multiPolygon, overlay: multi, areaId: 0))
                        default:
                            print("forme inconnue")
                        }
                    }
                default:
                    print("Feature de type inconnu")
                }
            }
                        
        } catch let error {
            print("\(error.localizedDescription)")
        }
        return areas
    }
    
    static func fetchGeoObjects() async throws -> [MKGeoJSONObject] {
        guard let url = Bundle.main.url(forResource: "RegionsQuebec2023", withExtension: "geojson") else {
            fatalError("Failure to fetch the geojson file.")
        }
        guard let data = try? Data(contentsOf: url) else {
            fatalError("Failed to load geojson file from bundle.")
        }
        do {
            // Decode the GeoJSON into a data model.
            let jsonDecoder = MKGeoJSONDecoder()
            let decodedData = try jsonDecoder.decode(data)
            return decodedData
            
        } catch {
            if let decodingError = error as? DecodingError {
                switch decodingError {
                case .dataCorrupted(let context):
                    print("Erreur de données corrompues : \(context.debugDescription)")
                case .keyNotFound(let key, let context):
                    print("Clé introuvable : \(key) - Chemin de l'erreur : \(context.codingPath)")
                case .typeMismatch(let type, let context):
                    print("Type inattendu : \(type) - Chemin de l'erreur : \(context.codingPath)")
                    dump(context)
                case .valueNotFound(let type, let context):
                    print("Valeur introuvable de type : \(type) - Chemin de l'erreur : \(context.codingPath)")
                @unknown default:
                    print("Erreur de décodage inconnue")
                }
            } else {
                // Gérer d'autres erreurs non liées au décodage JSON
                print("Erreur inattendue : \(error.localizedDescription)")
            }
            throw ImportJSONError.wrongDataFormat(error: error)
        }
    }
}
