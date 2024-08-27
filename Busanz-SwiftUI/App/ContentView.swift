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
    @State private var isDetailViewActive: Bool = false
    @State private var hasRestoredCameraPosition = false
        
    var body: some View {
        NavigationStack {
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
                    if hasRestoredCameraPosition {
                        Coordinator.shared.restoreCameraPosition()
                    }
                    else {
                        Coordinator.shared.checkIfLocationServiceIsEnabled()
                        viewModel.fetchRestaurants()
                        hasRestoredCameraPosition = true
                    }
                }
                
                if !viewModel.isLoading {
                    VStack {
                        SearchBarView(text: $searchText) {
                            if searchText.isEmpty {
                                // 아무것도 입력 안됐을 때
                            }
                            else {
                                viewModel.filterRestaurants(bySearchText: searchText)
                            }
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
                
                if let selectedRestaurant = coordinator.selectedRestaurant {
                    NavigationLink(
                        destination: DetailResInfoView(restaurant: selectedRestaurant),
                        isActive: $isDetailViewActive, // 활성화 상태 바인딩
                        label: { EmptyView() }
                    )
                    .onAppear {
                        isDetailViewActive = true // 뷰가 나타날 때 활성화
                        Coordinator.shared.saveCurrentCameraPosition()
                    }
                    .onDisappear {
                        isDetailViewActive = false
                        coordinator.selectedRestaurant = nil
                        Coordinator.shared.restoreCameraPosition()
                    }
                }
            }
            .navigationDestination(isPresented: $isDetailViewActive) {
                if let selectedRestaurant = coordinator.selectedRestaurant {
                    DetailResInfoView(restaurant: selectedRestaurant)
                }
            }
            .overlay(
                Group {
                    if viewModel.showToast {
                        ToastView(message: "검색된 맛집이 없습니다.")
                            .onAppear {
                                DispatchQueue.main.asyncAfter(deadline: .now()+1) {
                                    withAnimation {
                                        viewModel.showToast = false
                                    }
                                }
                            }
                    }
                }
            )
        }
    }
}

#Preview {
    ContentView()
}
