//
//  FavResViewModel.swift
//  Busanz-SwiftUI
//
//  Created by Hyungjun KIM on 9/5/24.
//

import Foundation
import Combine

class FavResViewModel: ObservableObject {
    @Published var favoriteRestaurants: [Restaurant] = []
    
    private var cancellables = Set<AnyCancellable>()
    private var favoriteManager: FavoriteManager
    
    init(favoriteManager: FavoriteManager) {
        self.favoriteManager = favoriteManager
        // favoriteManager에서 데이터 변경 감지
        self.favoriteManager.$favoriteRestaurants
            .assign(to: &$favoriteRestaurants)
    }
    
    func removeFavorite(at index: Int) {
        let restaurant = favoriteRestaurants[index]
        favoriteManager.removeFavorite(restaurant)
    }
    
}
