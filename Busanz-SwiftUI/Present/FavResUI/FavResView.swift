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
    @State var viewModel: FavResViewModel
        
    var body: some View {
        NavigationView {
            ZStack {
                Color("Background").ignoresSafeArea()
                
                if viewModel.favoriteRestaurants.isEmpty {
                    VStack {
                        Spacer()
                        Text("즐겨찾는 맛집이 없습니다.")
                            .font(.juaRegualr30)
                            .padding()
                        Text("나만의 맛집을 추가해보세요! 😉")
                            .font(.juaRegualr24)
                        Spacer()
                        Spacer()
                    }
                    .multilineTextAlignment(.center)
                    .padding()
                }
                else {
                    List {
                        ForEach(viewModel.favoriteRestaurants.indices, id: \.self) { index in
                            NavigationLink(
                                destination: DetailResInfoView(
                                    viewModel: DetailResInfoViewModel(
                                        restaurant: viewModel.favoriteRestaurants[index],
                                        favoriteManager: FavoriteManager()
                                    )
                                )) {
                                HCard(restaurant: viewModel.favoriteRestaurants[index], index: index)
                                    .listRowBackground(Color.clear)
                            }
                            .swipeActions {
                                Button(role: .destructive) {
                                    viewModel.removeFavorite(at: index)
                                } label: {
                                    Label("삭제", systemImage: "trash")
                                }
                            }
                        }
                        .listRowSeparator(.hidden)
                    }
                    .listStyle(.plain)
                }
            }
            .navigationTitle("My Favorites")
        }
    }
}

#Preview {
    FavResView(viewModel: FavResViewModel(favoriteManager: FavoriteManager()))
}
