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
    
    @State private var selectedGugun: String? = nil
        
    var body: some View {
        ZStack(alignment: .topLeading) {
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
            
            if !viewModel.isLoading {
                FloatingFilterView(selectedGugun: $selectedGugun, gugunList: viewModel.getGugunList()) { gugun in
                    viewModel.filterRestaurants(by: gugun)
                }
                .padding()
                .transition(.opacity)
            }
        }
    }
}

#Preview {
    ContentView()
}
