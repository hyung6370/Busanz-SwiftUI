//
//  DetailResInfoViewModel.swift
//  Busanz-SwiftUI
//
//  Created by Hyungjun KIM on 8/12/24.
//

import Foundation
import Combine

class DetailResInfoViewModel: ObservableObject {
    @Published var restaurant: Restaurant?
    @Published var isExpanded: Bool = false
    @Published var isFavorite: Bool = false
    
    private let favoriteManager: FavoriteManager
    
    init(restaurant: Restaurant?, favoriteManager: FavoriteManager) {
        self.restaurant = restaurant
        self.favoriteManager = favoriteManager
        if let restaurant = restaurant {
            self.isFavorite = favoriteManager.isFavorite(restaurant)
        }
    }
    
    func toggleFavorite() {
        guard let restaurant = restaurant else { return }
        if isFavorite {
            favoriteManager.removeFavorite(restaurant)
        }
        else {
            favoriteManager.addFavorite(restaurant)
        }
        isFavorite.toggle()
    }
}
