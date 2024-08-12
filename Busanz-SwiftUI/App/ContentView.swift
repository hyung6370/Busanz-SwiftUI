//
//  ContentView.swift
//  Busanz-SwiftUI
//
//  Created by Hyungjun KIM on 8/5/24.
//

import SwiftUI
import Combine

struct ContentView: View {
    @StateObject var coordinator: Coordinator = Coordinator.shared
    @StateObject private var viewModel = MapViewModel()
        
    var body: some View {
        VStack {
            if viewModel.isLoading {
                ProgressView("Loading...")
            }
            else {
                NaverMap(restaurants: $viewModel.restaurants)
                    .ignoresSafeArea(.all)
            }
        }
        .onAppear {
            Coordinator.shared.checkIfLocationServiceIsEnabled()
            viewModel.fetchRestaurants()
        }
    }
}

#Preview {
    ContentView()
}
