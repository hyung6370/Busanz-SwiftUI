//
//  FavoriteManager.swift
//  Busanz-SwiftUI
//
//  Created by Hyungjun KIM on 9/5/24.
//

import Foundation
import Combine

class FavoriteManager: ObservableObject {
    @Published var favoriteRestaurants: [Restaurant] = [] {
        didSet {
            saveFavoritesToUserDefaults()
        }
    }
    
    private let favoritesKey = "favoriteRestaurants"
    
    init() {
        loadFavoritesFromUserDefaults()
    }
    
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
    
    // UserDefault에 즐겨찾기 저장
    private func saveFavoritesToUserDefaults() {
        let encoder = JSONEncoder()
        if let encoded = try? encoder.encode(favoriteRestaurants) {
            UserDefaults.standard.set(encoded, forKey: favoritesKey)
        }
    }
    
    // UserDefaults에서 즐겨찾기 불러오기
    private func loadFavoritesFromUserDefaults() {
        let decoder = JSONDecoder()
        if let savedData = UserDefaults.standard.data(forKey: favoritesKey),
           let loadedFavorites = try? decoder.decode([Restaurant].self, from: savedData) {
            favoriteRestaurants = loadedFavorites
        }
    }
}
