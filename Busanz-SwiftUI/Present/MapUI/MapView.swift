//
//  MapView.swift
//  Busanz-SwiftUI
//
//  Created by Hyungjun KIM on 8/5/24.
//

import SwiftUI
import NMapsMap
import CoreLocation

struct NaverMap: UIViewRepresentable {
    @Binding var restaurants: [Restaurant]
    
    func makeCoordinator() -> Coordinator {
        Coordinator.shared
    }
    
    func makeUIView(context: Context) -> NMFNaverMapView {
        context.coordinator.getNaverMapView()
    }
    
    func updateUIView(_ uiView: NMFNaverMapView, context: Context) {
        context.coordinator.addMarkers(for: restaurants)
    }
}
