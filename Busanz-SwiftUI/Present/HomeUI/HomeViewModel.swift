//
//  HomeViewModel.swift
//  Busanz-SwiftUI
//
//  Created by Hyungjun KIM on 8/30/24.
//

import Foundation
import Combine

class HomeViewModel: ObservableObject {
    @Published var restaurants: [Restaurant] = []
    private var cancellables = Set<AnyCancellable>()
    
    private let restaurantManager = BusanRestaurantKorManager()
    
    init() {
        fetchRestaurants()
    }
    
    func fetchRestaurants() {
        restaurantManager.fetchRestaurants()
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .failure(let error):
                    print("Error fetching restaurants: \(error)")
                case .finished:
                    break
                }
            }, receiveValue: { [weak self] restaurants in
                self?.restaurants = restaurants.shuffled()
            })
            .store(in: &cancellables)
    }
}
