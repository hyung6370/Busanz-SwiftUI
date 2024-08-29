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
    @State private var emptyTFShowToast: Bool = false
        
    var body: some View {
        NavigationStack {
            ZStack(alignment: .topLeading) {
                NaverMap(restaurants: $viewModel.filteredRestaurants)
                    .ignoresSafeArea(.all)
                    .onAppear {
                        viewModel.fetchRestaurants()
                    }
                
                if !viewModel.isLoading {
                    VStack {
                        SearchBarView(text: $searchText) {
                            if searchText.isEmpty {
                                emptyTFShowToast = true
                                DispatchQueue.main.asyncAfter(deadline: .now()+2) {
                                    emptyTFShowToast = false
                                }
                            }
                            else {
                                viewModel.filterRestaurants(bySearchText: searchText)
                            }
                        }
                        .padding(.trailing, 16)
                        .padding(.bottom, 20)
                        
                        Spacer()
                        
                        VStack(spacing: 1) {
                            HStack {
                                Spacer()
                                AllSelectedBtnView() {
                                    viewModel.showAllRestaurants()
                                }
                            }
                            .padding(.trailing, 17)
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
                
                if let selectedRestaurant = coordinator.selectedRestaurant {
                    NavigationLink(
                        destination: DetailResInfoView(restaurant: selectedRestaurant),
                        isActive: $isDetailViewActive, // 활성화 상태 바인딩
                        label: { EmptyView() }
                    )
                    .onAppear {
                        isDetailViewActive = true // 뷰가 나타날 때 활성화
                    }
                    .onDisappear {
                        isDetailViewActive = false
                        coordinator.selectedRestaurant = nil
                    }
                }
                
                ZStack {
                    if emptyTFShowToast {
                        ToastView(message: "맛집을 입력해주세요.")
                    }
                    
                    if viewModel.noneShowToast {
                        ToastView(message: "검색된 맛집이 없습니다.")
                            .onAppear {
                                DispatchQueue.main.asyncAfter(deadline: .now()+2) {
                                    viewModel.noneShowToast = false
                                }
                            }
                            .opacity(viewModel.noneShowToast ? 1 : 0)
                    }
                }
                .frame(maxWidth: .infinity, alignment: .center)
                .padding(.top, 10)
                
                if viewModel.isLoading {
                    IndicatorView()
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .zIndex(1)
                }
            }
            .navigationDestination(isPresented: $isDetailViewActive) {
                if let selectedRestaurant = coordinator.selectedRestaurant {
                    DetailResInfoView(restaurant: selectedRestaurant)
                }
            }
        }
    }
}

#Preview {
    ContentView()
}
