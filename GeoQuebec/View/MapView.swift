//
//  MapView.swift
//  GeoQuebec
//
//  Created by Eric Chandonnet on 2023-10-07.
//

import SwiftUI
import MapKit

extension MKCoordinateRegion {
    static let quebecProvince = MKCoordinateRegion(
        center: CLLocationCoordinate2D(
            latitude: 53.93948272, longitude: -67.068334937),
        span: MKCoordinateSpan(latitudeDelta: 22.0, longitudeDelta: 22.0)
    )
}

struct MapView: View {
    @Environment(ViewModel.self) private var viewModel: ViewModel
    
    @State private var visibleRegion: MKCoordinateRegion?
    @State private var scaleEffect = 1.0
    
    @State private var trigger = false
    
    
    var body: some View {
        // special twist because environment and binding don't go along great just yet
        Map(position: Binding(get: { viewModel.cameraPosition }, set: { viewModel.cameraPosition = $0 })) {
            ForEach(viewModel.areas) { area in
                if let poly = area.overlay as? MKPolygon {
                    MapPolygon(poly)
                        .foregroundStyle(getAreaColor(areaId: area.areaId))
                        .stroke(.black, lineWidth: 3)
                } else if let multi = area.overlay as? MKMultiPolygon {
                    ForEach(multi.polygons, id: \.self) { poly in
                        MapPolygon(poly)
                            .foregroundStyle(getAreaColor(areaId: area.areaId))
                            .stroke(.black, lineWidth: 3)
                    }
                }
                Annotation(coordinate: area.overlay.coordinate, anchor: .center) {
                    ZStack {
                        Circle()
                            .fill(getAnnotationColor(areaId: area.areaId))
                            .frame(width: 32, height: 32)
                        Image(systemName: "\(area.areaId).circle")
                            .font(.system(size: 26))
                            .foregroundStyle(getAnnotationIconColor(areaId: area.areaId))
                            .padding(2)
                    }
                    .scaleEffect(area.areaId == viewModel.focusedAreaId ? scaleEffect : 1)
                    .animation(.bouncy(duration: 0.6, extraBounce: 0.3), value: viewModel.focusedAreaId)
                    .onTapGesture {
                        if viewModel.isFocused(areaId: area.areaId) {
                            if viewModel.isAttributed(areaId: area.areaId) {
                                viewModel.removeChoice(areaId: area.areaId)
                                viewModel.unfocusAll()
                                viewModel.setCamera(to: .wholeMap)
                            }
                            else {
                                viewModel.unfocusAll()
                                viewModel.setCamera(to: .wholeMap)
                            }
                        } else {
                            viewModel.setFocusToAreaId(area.areaId)
                            viewModel.setCamera(to: .focusedArea)
                        }
                    }
                    .onChange(of: viewModel.focusedAreaId, initial: true) { oldValue, newValue in
                        if (newValue != nil) == true {
                            withAnimation {
                                scaleEffect = 2.5
                            }
                        }
                    }
                } label: {
                    if viewModel.isAttributed(areaId: area.areaId) {
                        Text("\(viewModel.getAttributedName(areaId: area.areaId) ?? "")")
                    }
                    
                }
                
            }
        }
        .mapStyle(.imagery())
        .onMapCameraChange { context in
            visibleRegion = context.region
        }
        .mapControls {
            MapCompass()
                .mapControlVisibility(.visible)
            MapScaleView()
        }
        .onAppear {
            viewModel.selectNextArea()
        }
        
    }

    func getAnnotationColor(areaId: Int) -> Color {
        if viewModel.isFocused(areaId: areaId) {
            return Color("annotationFocused")
        }
        else {
            if viewModel.isAttributed(areaId: areaId) {
                return Color("annotationAttributed")
            }
            else {
                return Color("annotationAvailable")
            }
        }
    }

    func getAnnotationIconColor(areaId: Int) -> Color {
        if viewModel.isFocused(areaId: areaId) {
            return Color("annotationFocusedIcon")
        }
        else {
            if viewModel.isAttributed(areaId: areaId) {
                return Color("annotationAttributedIcon")
            }
            else {
                return Color("annotationAvailableIcon")
            }
        }
    }

    
    func getAreaColor(areaId: Int) -> Color {
        if viewModel.isGameOver {
            if viewModel.isUnvailed(areaId: areaId) {
                if viewModel.isFocused(areaId: areaId) {
                    return Color("areaFocused2")
                }
                else {
                    if viewModel.isChoiceRight(areaId: areaId) {
                        return Color("areaRight")
                    }
                    else {
                        return Color("areaWrong")
                    }
                }
            } 
            else {
                if viewModel.isFocused(areaId: areaId) {
                    return Color("areaFocused2")
                }
                else {
                    return Color("areaAttributed")
                }
            }
        } 
        else {
            if areaId == viewModel.focusedAreaId {
                return Color("areaFocused")
            }
            else {
                if viewModel.isAttributed(areaId: areaId) {
                    return Color("areaAttributed")
                }
                else {
                    return Color("areaAvailable")
                }
            }
        }
    }
            
}

#Preview {
    ContentView()
        .environment(ViewModel())
    
}
