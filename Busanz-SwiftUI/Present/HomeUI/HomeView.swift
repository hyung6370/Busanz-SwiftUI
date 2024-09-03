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
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 20) {
                    ForEach(viewModel.restaurants, id: \.mainTitle) { restaurant in
                        VCard(restaurant: restaurant)
                    }
                }
                .padding(20)
                .padding(.bottom, 10)
            }
        }
    }
    
    func startAutoScroll() {
        timer = Timer.publish(every: 3, on: .main, in: .common)
            .autoconnect()
            .sink { _ in
                if viewModel.restaurants.isEmpty { return }
                
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
