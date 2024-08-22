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
    @State private var searchText: String = ""
        
    var body: some View {
        
        ZStack(alignment: .topLeading) {
            VStack {
                if viewModel.isLoading {
                    ProgressView("Loading...")
                }
                else {
                    NaverMap(restaurants: $viewModel.filteredRestaurants)
                        .ignoresSafeArea(.all)
                }
            }
            .onAppear {
                Coordinator.shared.checkIfLocationServiceIsEnabled()
                viewModel.fetchRestaurants()
            }
            
            if !viewModel.isLoading {
                VStack {
                    SearchBarView(text: $searchText) {
                        viewModel.filterRestaurants(bySearchText: searchText)
                    }
                    .padding(.trailing, 16)
                    .padding(.bottom, 20)
                    
                    Spacer()
                
                    FloatingFilterView(selectedGugun: $selectedGugun, gugunList: viewModel.getGugunList()) { gugun in
                        viewModel.filterRestaurants(by: gugun)
                    } onCountSelected: { count in
                        viewModel.filterRestaurants(byCount: count)
                    }
                    .padding(.bottom, 35)
                    .padding(.leading, 150)
                    .transition(.opacity)
                }
            }
        }
    }
}

#Preview {
    ContentView()
}
