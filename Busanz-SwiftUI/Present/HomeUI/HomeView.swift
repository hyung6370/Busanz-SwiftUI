//
//  HomeView.swift
//  Busanz-SwiftUI
//
//  Created by Hyungjun KIM on 8/30/24.
//

import SwiftUI

struct HomeView: View {
    @StateObject private var viewModel = HomeViewModel()
    
    var body: some View {
        ZStack {
            Color("Background").ignoresSafeArea()
            
            ScrollView {
                content
            }
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
}

#Preview {
    HomeView()
}
