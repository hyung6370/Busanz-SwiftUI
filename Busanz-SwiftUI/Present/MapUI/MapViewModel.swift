//
//  MapViewModel.swift
//  Busanz-SwiftUI
//
//  Created by Hyungjun KIM on 8/9/24.
//

import Foundation

class MapViewModel: ObservableObject {
    @Published var restaurants: [Restaurant] = []
    @Published var isLoading = false
    @Published var errorMessage: String? = nil
    
    private let restaurantManager = BusanRestaurantKorManager()
    
    func fetchRestaurants() {
        self.isLoading = true
        self.errorMessage = nil
        
        restaurantManager.fetchRestaruants { [weak self] restaurants in
            DispatchQueue.main.async {
                self?.isLoading = false
                
                if let restaurants = restaurants {
                    self?.restaurants = restaurants
                    print(restaurants)
                }
                else {
                    self?.errorMessage = "데이터를 가져오는 데 실패했습니다."
                }
            }
        }
    }
}
