//
//  HomeView.swift
//  Busanz-SwiftUI
//
//  Created by Hyungjun KIM on 8/30/24.
//

import SwiftUI
import Combine

struct HomeView: View {
    @StateObject private var viewModel = HomeViewModel()
    @State private var currentIndex = 0
    @State private var timer: AnyCancellable?
    
    var body: some View {
        ZStack {
            Color("Background").ignoresSafeArea()
            
            ScrollView {
                content
            }
        }
        .onAppear {
            startAutoScroll()
        }
        .onDisappear {
            stopAutoScroll()
        }
    }

    var content: some View {
        VStack(alignment: .leading, spacing: 0) {
            Text("Busan's Collections")
                .font(.notosansBold30)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal, 20)
            
            ScrollViewReader { scrollViewProxy in
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 20) {
                        ForEach(viewModel.restaurants.indices, id: \.self) { index in
                            VCard(restaurant: viewModel.restaurants[index], index: index)
                                .id(index)
                                .onAppear {
                                    if index == currentIndex {
                                        scrollViewProxy.scrollTo(currentIndex, anchor: .center)
                                    }
                                }
                        }
                    }
                    .padding(20)
                    .padding(.bottom, 10)
                }
                .onChange(of: currentIndex) { newIndex in
                    withAnimation {
                        scrollViewProxy.scrollTo(newIndex, anchor: .center)
                    }
                }
            }
            
            Text("Random Pick!")
                .font(.notosansBold24)
                .padding(.horizontal, 20)
            
            VStack(spacing: 20) {
                ForEach(viewModel.restaurants.indices, id: \.self) { index in
                    HCard(restaurant: viewModel.restaurants[index], index: index)
                }
            }
            .padding(.horizontal, 20)
        }
    }
    
    func startAutoScroll() {
        timer = Timer.publish(every: 3, on: .main, in: .common)
            .autoconnect()
            .sink { _ in
                guard !viewModel.restaurants.isEmpty else { return }
                
                withAnimation {
                    currentIndex = (currentIndex + 1) % viewModel.restaurants.count
                }
            }
    }
    
    func stopAutoScroll() {
        timer?.cancel()
    }
}

#Preview {
    HomeView()
}
