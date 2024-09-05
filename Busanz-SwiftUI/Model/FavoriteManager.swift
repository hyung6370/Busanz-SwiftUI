//
//  FavoriteManager.swift
//  Busanz-SwiftUI
//
//  Created by Hyungjun KIM on 9/5/24.
//

import Foundation
import Combine

class FavoriteManager: ObservableObject {
    @Published var favoriteRestaurants: [Restaurant] = []
    
    func addFavorite(_ restaurant: Restaurant) {
        if !favoriteRestaurants.contains(where: { $0.mainTitle == restaurant.mainTitle }) {
            favoriteRestaurants.append(restaurant)
        }
    }
    
    func removeFavorite(_ restaurant: Restaurant) {
        favoriteRestaurants.removeAll { $0.mainTitle == restaurant.mainTitle }
    }
    
    func isFavorite(_ restaurant: Restaurant) -> Bool {
        return favoriteRestaurants.contains(where: { $0.mainTitle == restaurant.mainTitle })
    }
}
