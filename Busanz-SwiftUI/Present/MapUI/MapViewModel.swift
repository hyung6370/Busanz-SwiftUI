//
//  MapViewModel.swift
//  Busanz-SwiftUI
//
//  Created by Hyungjun KIM on 8/9/24.
//

import Foundation
import Combine

class MapViewModel: ObservableObject {
    @Published var restaurants: [Restaurant] = []
    @Published var filteredRestaurants: [Restaurant] = []
    @Published var isLoading = false
    @Published var errorMessage: String? = nil
    
    private let restaurantManager = BusanRestaurantKorManager()
    private var cancellables = Set<AnyCancellable>()
    
    private var selectedGugun: String? = nil
    private var selectedCount: Int = Int.max
    
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
//                self?.filteredRestaurants = restaurants
                self?.applyFilters()
            }
            .store(in: &cancellables)
    }
    
//    func filterRestaurants(by gugun: String?) {
//        if let gugun = gugun {
//            filteredRestaurants = restaurants.filter { $0.gugunNm == gugun }
//        }
//        else {
//            filteredRestaurants = restaurants
//        }
//    }
    
    func filterRestaurants(by gugun: String?) {
        selectedGugun = gugun
        applyFilters()
    }
    
    func filterRestaurants(byCount count: Int) {
        selectedCount = count
        applyFilters()
    }
    
    private func applyFilters() {
        var filtered = restaurants
        
        // 구군별 필터링 적용
        if let gugun = selectedGugun {
            filtered = filtered.filter { $0.gugunNm == gugun }
        }
        
        // 개수별 필터링 적용
        if selectedCount != Int.max {
            filtered = Array(filtered.prefix(selectedCount))
        }
        
        filteredRestaurants = filtered
    }
    
    func getGugunList() -> [String] {
        let gugunSet = Set(restaurants.map { $0.gugunNm })
        return Array(gugunSet).sorted()
    }
}
