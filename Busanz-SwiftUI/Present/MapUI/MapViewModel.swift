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
    @Published var isLoading = false
    @Published var errorMessage: String? = nil
    
    private let restaurantManager = BusanRestaurantKorManager()
    private var cancellables = Set<AnyCancellable>()
    
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
                print(restaurants)
            }
            .store(in: &cancellables)
    }
}
