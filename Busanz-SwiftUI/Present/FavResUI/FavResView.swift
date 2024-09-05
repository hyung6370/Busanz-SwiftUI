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
                    Text("즐겨찾는 맛집이 없습니다.")
                        .font(.juaRegualr30)
                        .padding()
                    Text("나만의 맛집을 추가해보세요! 😉")
                        .font(.juaRegualr24)
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
