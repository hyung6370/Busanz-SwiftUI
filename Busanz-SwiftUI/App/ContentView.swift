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
    
    @State private var showSplash = true
    
    let backgroundGradient = LinearGradient(
        colors: [Color("Background").opacity(0), Color("Background")],
        startPoint: .top,
        endPoint: .bottom
    )
        
    var body: some View {
        ZStack {
            if showSplash {
                SplashView()
            }
            else {
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
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                withAnimation {
                    showSplash = false
                }
            }
        }
    }
}

struct SplashView: View {
    var body: some View {
        ZStack {
            Color.blue
                .opacity(0.3)
                .ignoresSafeArea()
            LottieView(jsonName: "SplashAnimation")
                .frame(width: 200, height: 200)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
