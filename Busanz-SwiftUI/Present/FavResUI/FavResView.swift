//
//  FavResView.swift
//  Busanz-SwiftUI
//
//  Created by Hyungjun KIM on 9/5/24.
//

import SwiftUI
import Combine

struct FavResView: View {
    @State private var isLoading = true
    @EnvironmentObject var favoriteManager: FavoriteManager
        
    var body: some View {
        NavigationView {
            ZStack {
                Color("Background").ignoresSafeArea()
                
                if favoriteManager.favoriteRestaurants.isEmpty {
                    Text("My Favorites")
                        .font(.notosansBold30)
                        .padding()
                }
                else {
                    ScrollView {
                        LazyVStack(alignment: .leading, spacing: 20) {
                            ForEach(favoriteManager.favoriteRestaurants.indices, id: \.self) { index in
                                NavigationLink(destination: DetailResInfoView(restaurant: favoriteManager.favoriteRestaurants[index])) {
                                    HCard(restaurant: favoriteManager.favoriteRestaurants[index], index: index)
                                }
                            }
                        }
                        .padding(20)
                    }
                }
            }
            .navigationTitle("My Favorites")
        }
    }
    
    var content: some View {
        LazyVStack(alignment: .leading, spacing: 0) {
            Text("My Favorites")
                .font(.notosansBold30)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal, 20)
        }
    }
}

#Preview {
    FavResView()
}
