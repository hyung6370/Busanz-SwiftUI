//
//  Coordinator.swift
//  Busanz-SwiftUI
//
//  Created by Hyungjun KIM on 8/5/24.
//

import UIKit
import NMapsMap

class Coordinator: NSObject, ObservableObject, NMFMapViewCameraDelegate, NMFMapViewTouchDelegate, CLLocationManagerDelegate {
    static let shared = Coordinator()
    
    @Published var coord: (Double, Double) = (0.0, 0.0)
    @Published var userLocation: (Double, Double) = (0.0, 0.0)
    @Published var selectedRestaurant: Restaurant? = nil
    
    var hasMovedToUserLocation = false
    
    var locationManager: CLLocationManager?
    let startInfoWindow = NMFInfoWindow()
    let view = NMFNaverMapView(frame: .zero)
    private var markers: [NMFMarker] = []
    private var currentInfoWindow: NMFInfoWindow?
    
    let compassView = NMFCompassView()
    let locationButton = NMFLocationButton()
    
    override init() {
        super.init()
        
        view.mapView.positionMode = .direction
        view.mapView.isNightModeEnabled = true
        
        view.showLocationButton = false // 현위치 버튼
        view.showZoomControls = true   // 줌 버튼
        view.showCompass = false        // 나침반
        
        view.mapView.logoAlign = .leftBottom
        view.mapView.logoMargin = UIEdgeInsets(top: 0, left: 25, bottom: 75, right: 0)
        
        addCustomControls()

        view.mapView.addCameraDelegate(delegate: self)
        view.mapView.touchDelegate = self
    }
    
    private func addCustomControls() {
        compassView.mapView = view.mapView
        view.addSubview(compassView)
        compassView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            compassView.topAnchor.constraint(equalTo: view.topAnchor, constant: 100),
            compassView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 15)
        ])
        
        // 커스텀 위치 버튼 추가
        locationButton.mapView = view.mapView
        view.addSubview(locationButton)
        locationButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            locationButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 23),
            locationButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -140)
        ])
    }
    
    func addMarkers(for restaurants: [Restaurant]) {
        // 기존 마커 제거
        markers.forEach { $0.mapView = nil }
        markers.removeAll() // 마커 배열 초기화
        
        for restaurant in restaurants {
            let marker = NMFMarker()
            marker.position = NMGLatLng(lat: restaurant.lat, lng: restaurant.lng)
            
            // 마커의 아이콘 설정
            if let image = UIImage(named: "ResMarker") {
                let resizedImage = image.resized(to: CGSize(width: 30, height: 30))
                marker.iconImage = NMFOverlayImage(image: resizedImage!)
            }
            
            marker.mapView = view.mapView // 마커를 맵에 추가
            
            // 마커 클릭 이벤트 처리
            marker.touchHandler = { [weak self] (overlay) -> Bool in
                guard let self = self else { return true }
                
                if let currentInfoWindow = self.currentInfoWindow {
                    currentInfoWindow.close()
                }
                
                let infoWindow = NMFInfoWindow()
                let dataSource = NMFInfoWindowDefaultTextSource.data()
                dataSource.title = restaurant.title
                infoWindow.dataSource = dataSource
                infoWindow.open(with: marker)
                self.currentInfoWindow = infoWindow
                
                infoWindow.touchHandler = { [weak self] (overlay) -> Bool in
                    guard let self = self else { return true }
                    DispatchQueue.main.async {
                        self.selectedRestaurant = restaurant
                    }
                    return true
                }
                
                return true
            }
            
            markers.append(marker) // 마커 배열에 추가
        }
    }
    
    func checkIfLocationServiceIsEnabled() {
        if CLLocationManager.locationServicesEnabled() {
            self.locationManager = CLLocationManager()
            self.locationManager!.delegate = self
            self.checkLocationAuthorization()
        } else {
            print("Location services are not enabled. Show an alert to the user.")
        }
    }
    
    func checkLocationAuthorization() {
        guard let locationManager = locationManager else {
            print("Location manager is not initialized in checkLocationAuthorization")
            return
        }

        print("Authorization status: \(locationManager.authorizationStatus.rawValue)")
        
        switch locationManager.authorizationStatus {
        case .notDetermined:
            print("Requesting authorization...")
            locationManager.requestWhenInUseAuthorization()
        case .restricted, .denied:
            print("Location access is restricted or denied.")
        case .authorizedAlways, .authorizedWhenInUse:
            print("Location access authorized.")
            coord = (Double(locationManager.location?.coordinate.latitude ?? 0.0), Double(locationManager.location?.coordinate.longitude ?? 0.0))
            userLocation = coord
            fetchUserLocation()
        @unknown default:
            break
        }
    }
    
    func fetchUserLocation() {
        if hasMovedToUserLocation {
            return
        }
        
        if let locationManager = locationManager {
            guard let lat = locationManager.location?.coordinate.latitude,
                  let lng = locationManager.location?.coordinate.longitude else {
                print("Failed to get location") // 위치 정보 가져오기 실패 시 로그 출력
                return
            }
            
            let cameraUpdate = NMFCameraUpdate(scrollTo: NMGLatLng(lat: lat, lng: lng), zoomTo: 15)
            cameraUpdate.animation = .easeIn
            cameraUpdate.animationDuration = 1
            
            let locationOverlay = view.mapView.locationOverlay
            locationOverlay.location = NMGLatLng(lat: lat, lng: lng)
            locationOverlay.hidden = false
            
            locationOverlay.icon = NMFOverlayImage(name: "location_overlay_icon")
            locationOverlay.iconWidth = CGFloat(NMF_LOCATION_OVERLAY_SIZE_AUTO)
            locationOverlay.iconHeight = CGFloat(NMF_LOCATION_OVERLAY_SIZE_AUTO)
            locationOverlay.anchor = CGPoint(x: 0.5, y: 1)
            
            view.mapView.moveCamera(cameraUpdate)
        } else {
            print("Location manager is not initialized")
        }
    }
    
    func getNaverMapView() -> NMFNaverMapView {
        view
    }
    
    func setMarker(lat: Double, lng: Double) {
        let marker = NMFMarker()
        marker.iconImage = NMF_MARKER_IMAGE_PINK
        marker.position = NMGLatLng(lat: lat, lng: lng)
        marker.mapView = view.mapView
        
        let infoWindow = NMFInfoWindow()
        let dataSource = NMFInfoWindowDefaultTextSource.data()
        dataSource.title = "서울특별시청"
        infoWindow.dataSource = dataSource
        infoWindow.open(with: marker)
    }
}
