//
//  MapViewModel.swift
//  Busanz-SwiftUI
//
//  Created by Hyungjun KIM on 8/9/24.
//

import Foundation
import Combine
import NMapsMap

class MapViewModel: ObservableObject {
    @Published var restaurants: [Restaurant] = []
    @Published var filteredRestaurants: [Restaurant] = []
    @Published var isLoading = false
    @Published var errorMessage: String? = nil
    @Published var noneShowToast: Bool = false
    
    private let restaurantManager = BusanRestaurantKorManager()
    private var cancellables = Set<AnyCancellable>()
    
    private var selectedGugun: String? = nil
    private var selectedCount: Int = Int.max
    private var searchText: String = ""
    
    var isInitialLoad: Bool = true
    
    private let busanCenter = NMGLatLng(lat: 35.1796, lng: 129.0756) // 부산 중심 좌표
    private let busanBounds = NMGLatLngBounds(
        southWest: NMGLatLng(lat: 34.9170, lng: 128.8226), // 남서쪽 좌표
        northEast: NMGLatLng(lat: 35.4062, lng: 129.2904)  // 북동쪽 좌표
    )
    
    func fetchRestaurants() {
        isLoading = true
        errorMessage = nil
        
        restaurantManager.fetchRestaurants()
            .receive(on: DispatchQueue.main)
            .sink { [weak self] completion in
                self?.isLoading = false
                if case .failure(let error) = completion {
                    self?.errorMessage = "데이터를 가져오는 데 실패했습니다: \(error.localizedDescription)"
                }
            } receiveValue: { [weak self] restaurants in
                self?.restaurants = restaurants
//                print(restaurants)
                self?.applyFilters()
            }
            .store(in: &cancellables)
    }
    
    func showAllRestaurants() {
        selectedGugun = nil
        selectedCount = Int.max
        searchText = ""
        filteredRestaurants = restaurants
        
//        Coordinator.shared.addMarkers(for: restaurants)
    }
    
    func filterRestaurants(by gugun: String?) {
        selectedGugun = gugun
        applyFilters()
    }
    
    func filterRestaurants(byCount count: Int) {
        selectedCount = count
        applyFilters()
    }
    
    func filterRestaurants(bySearchText text: String) {
        searchText = text
        applyFilters()
    }
    
    private func applyFilters() {
        var filtered = restaurants
        
        // 구군별 필터링
        if let gugun = selectedGugun, !gugun.isEmpty {
            filtered = filtered.filter { $0.gugunNm == gugun }
        }
        
        // 검색어 필터링
        if !searchText.isEmpty {
            filtered = filtered.filter { $0.title.localizedCaseInsensitiveContains(searchText) }
        }
        
        // 개수별 필터링
        if selectedCount != Int.max {
            filtered = Array(filtered.prefix(selectedCount))
        }

        filteredRestaurants = filtered

        if filtered.isEmpty {
            noneShowToast = true
        } else {
            noneShowToast = false
            moveCameraToBusanBounds()
        }
        
        // 필터된 맛집에 대한 마커 업데이트
        Coordinator.shared.addMarkers(for: filteredRestaurants)
    }
    
    func getGugunList() -> [String] {
        let gugunSet = Set(restaurants.map { $0.gugunNm })
        return Array(gugunSet).sorted()
    }
    
    private func moveCameraToBusanBounds() {
        let cameraUpdate = NMFCameraUpdate(fit: busanBounds)
        cameraUpdate.animation = .easeIn
        cameraUpdate.animationDuration = 1.5
        Coordinator.shared.view.mapView.moveCamera(cameraUpdate)
    }
}
