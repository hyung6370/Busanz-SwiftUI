//
//  NaverMapView.swift
//  Busanz-SwiftUI
//
//  Created by Hyungjun KIM on 8/23/24.
//

import SwiftUI
import NMapsMap

struct NaverMapView: UIViewRepresentable {
    var lat: Double
    var lng: Double
    
    func makeUIView(context: Context) -> NMFNaverMapView {
        let mapView = NMFNaverMapView(frame: .zero)
        
        let cameraPosition = NMFCameraPosition(NMGLatLng(lat: lat, lng: lng), zoom: 15)
        mapView.mapView.moveCamera(NMFCameraUpdate(position: cameraPosition))
        
        mapView.showLocationButton = true
        mapView.showCompass = true
        
        let marker = NMFMarker()
        marker.position = NMGLatLng(lat: lat, lng: lng)
        
        if let image = UIImage(named: "ResMarker") {
            let resizedImage = image.resized(to: CGSize(width: 35, height: 35))
            marker.iconImage = NMFOverlayImage(image: resizedImage!)
        }
        marker.mapView = mapView.mapView
        
        return mapView
    }
    
    func updateUIView(_ uiView: NMFNaverMapView, context: Context) {
        
    }
}

#Preview {
    NaverMapView(lat: 35.152874, lng: 129.05957)
}
