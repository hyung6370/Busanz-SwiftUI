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
    @State private var marker: NMFMarker? = nil
    
    func makeUIView(context: Context) -> NMFNaverMapView {
        let mapView = NMFNaverMapView(frame: .zero)
        
        // 초기 카메라 위치 설정
        let cameraPosition = NMFCameraPosition(NMGLatLng(lat: lat, lng: lng), zoom: 15)
        mapView.mapView.moveCamera(NMFCameraUpdate(position: cameraPosition))
        
        mapView.showLocationButton = true
        mapView.showCompass = true
        
        // 마커 추가
        addMarker(to: mapView.mapView, at: lat, lng: lng)
        
        return mapView
    }
    
    func updateUIView(_ uiView: NMFNaverMapView, context: Context) {
        // 카메라 위치가 변경되면 업데이트
        let cameraPosition = NMFCameraPosition(NMGLatLng(lat: lat, lng: lng), zoom: 15)
        uiView.mapView.moveCamera(NMFCameraUpdate(position: cameraPosition))
        
        // 기존 마커를 모두 제거하고 새로운 위치에 마커 추가
        marker?.mapView = nil
        addMarker(to: uiView.mapView, at: lat, lng: lng)
    }
    
    private func addMarker(to mapView: NMFMapView, at lat: Double, lng: Double) {
        let marker = NMFMarker()
        marker.position = NMGLatLng(lat: lat, lng: lng)
        
        if let image = UIImage(named: "ResMarker") {
            let resizedImage = image.resized(to: CGSize(width: 35, height: 35))
            marker.iconImage = NMFOverlayImage(image: resizedImage!)
        }
        marker.mapView = mapView
    }
}

#Preview {
    NaverMapView(lat: 35.152874, lng: 129.05957)
}
