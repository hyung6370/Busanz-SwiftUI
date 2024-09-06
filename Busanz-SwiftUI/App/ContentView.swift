//
//  ContentView.swift
//  Busanz-SwiftUI
//
//  Created by Hyungjun KIM on 8/5/24.
//

import SwiftUI
import Combine

struct ContentView: View {
    @AppStorage("selectedTab") var selectedTab: Tab = .timer
    @StateObject var tabBarVisibility = TabBarVisibility()
    
    let backgroundGradient = LinearGradient(
        colors: [Color("Background").opacity(0), Color("Background")],
        startPoint: .top,
        endPoint: .bottom
    )
        
    var body: some View {
        ZStack {
            Group {
                switch selectedTab {
                case .timer:
                    HomeView()
                case .search:
                    SearchView()
                case .user:
                    FavResView(viewModel: FavResViewModel(favoriteManager: FavoriteManager()))
                }
            }
            .safeAreaInset(edge: .bottom) {
                Color.clear.frame(height: 80)
            }
            .safeAreaInset(edge: .top) {
                Color.clear.frame(height: 104)
            }
            .mask(RoundedRectangle(cornerRadius: 30, style: .continuous))
            .ignoresSafeArea()
            
            if tabBarVisibility.isVisible {
                TabBar()
                    .offset(y: -24)
                    .background(
                        backgroundGradient
                            .frame(height: 150)
                            .frame(maxHeight: .infinity, alignment: .bottom)
                            .allowsHitTesting(false)
                    )
                    .ignoresSafeArea()
            }
        }
        .environmentObject(tabBarVisibility)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
