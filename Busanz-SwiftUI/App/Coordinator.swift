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
    
    var locationManager: CLLocationManager?
    let startInfoWindow = NMFInfoWindow()
    let view = NMFNaverMapView(frame: .zero)
    private var markers: [NMFMarker] = []
    private var currentInfoWindow: NMFInfoWindow?
    
    override init() {
        super.init()
        
//        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
//            self.setInitialCameraPosition()
//        }
        
        view.mapView.positionMode = .direction
        view.mapView.isNightModeEnabled = true
        
        view.showLocationButton = true // 현위치 버튼
        view.showZoomControls = true   // 줌 버튼
        view.showCompass = true        // 나침반
        view.showScaleBar = true       // 스케일 바
        
        view.mapView.addCameraDelegate(delegate: self)
        view.mapView.touchDelegate = self
    }
    
//    private func setInitialCameraPosition() {
//        let busanCenter = NMGLatLng(lat: 35.1796, lng: 129.0756)
//        let southWest = NMGLatLng(lat: 34.9170, lng: 128.8226)
//        let northEast = NMGLatLng(lat: 35.4062, lng: 129.2904)
//        
//        let busanBounds = NMGLatLngBounds(southWest: southWest, northEast: northEast)
//        view.mapView.extent = busanBounds
//        
//        let cameraUpdate = NMFCameraUpdate(scrollTo: busanCenter, zoomTo: 10)
//        view.mapView.moveCamera(cameraUpdate)
//    }
    
    func moveCameraToRestaurant(_ restaurant: Restaurant) {
        let latLng = NMGLatLng(lat: restaurant.lat, lng: restaurant.lng)
        let cameraUpdate = NMFCameraUpdate(scrollTo: latLng, zoomTo: 15)
        cameraUpdate.animation = .easeIn
        cameraUpdate.animationDuration = 1.5
        view.mapView.moveCamera(cameraUpdate)
    }
    
    func addMarkers(for restaurants: [Restaurant]) {
        markers.forEach { $0.mapView = nil } // 기존 마커 제거
        markers.removeAll() // 마커 배열 초기화
        
        for restaurant in restaurants {
            let marker = NMFMarker()
            marker.position = NMGLatLng(lat: restaurant.lat, lng: restaurant.lng)
            
            // 마커의 아이콘 설정 (선택 사항)
            if let image = UIImage(named: "ResMarker") {
                let resizedImage = image.resized(to: CGSize(width: 30, height: 30))
                marker.iconImage = NMFOverlayImage(image: resizedImage!)
            }
            
            marker.mapView = view.mapView // 마커를 맵에 추가
            
            // 마커 클릭 이벤트 처리 (선택 사항)
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
    
    func mapView(_ mapView: NMFMapView, cameraWillChangeByReason reason: Int, animated: Bool) {
        
    }
    
    func mapView(_ mapView: NMFMapView, cameraIsChangingByReason reason: Int) {
        
    }
    
    /*
     ContentView 에서 .onAppear 에서 위치 정보 제공을 동의 했는지 확인하는 함수를 호출한다.
     
     위치 정보 제공 동의 순서
     1. MapView에서 .onAppear에서 checkIfLocationServiceIsEnabled() 호출
     2. checkIfLocationServiceIsEnabled() 함수 안에서 locationServicesEnabled() 값이 true 인지 체크
     3. true일 경우(동의한 경우), checkLocationAuthorization() 호출
     4. case .authorizedAlways(항상 허용), .authorizedWhenInUse(앱 사용중에만 허용)일 경우에만 fetchUserLocation() 호출
     */
    
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
