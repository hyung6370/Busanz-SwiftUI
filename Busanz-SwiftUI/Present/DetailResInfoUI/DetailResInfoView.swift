//
//  DetailResInfoView.swift
//  Busanz-SwiftUI
//
//  Created by Hyungjun KIM on 8/12/24.
//

import SwiftUI

struct DetailResInfoView: View {
    @StateObject var viewModel: DetailResInfoViewModel
    @Environment(\.colorScheme) var colorScheme
    @EnvironmentObject var tabBarVisibility: TabBarVisibility
    
    var body: some View {
        ZStack {
            Color("Background").ignoresSafeArea()
            
            ScrollView {
                VStack(alignment: .leading) {
                    if let restaurant = viewModel.restaurant {
                        ZStack {
                            Rectangle()
                                .fill(.linearGradient(colors: [Color.hCardColor3, Color.hCardColor2.opacity(0.5)], startPoint: .topLeading, endPoint: .bottomTrailing))
                                .cornerRadius(15)
                                .frame(width: 360, height: 410)
                            
                            NaverMapView(lat: restaurant.lat, lng: restaurant.lng)
                                .padding([.leading, .trailing], 20)
                                .frame(width: 380, height: 390)
                        }
                        
                        VStack(alignment: .leading, spacing: 3) {
                            Text("주소")
                                .foregroundColor(colorScheme == .dark ? .white : .black)
                                .font(.notosansBold16)
                                .padding(.leading, 3)
                            HStack(spacing: 4) {
                                Image(systemName: "house.circle")
                                    .foregroundColor(colorScheme == .dark ? .white : .black)
                                    .font(.system(size: 16))
                                    .padding(.top, 3)
                                let busan = restaurant.addr1
                                if busan.contains("부산시") {
                                    Text(restaurant.addr1)
                                        .foregroundColor(colorScheme == .dark ? .white : .black)
                                        .font(.notosansBold18)
                                }
                                else {
                                    Text("부산시 " + restaurant.addr1)
                                        .foregroundColor(colorScheme == .dark ? .white : .black)
                                        .font(.notosansBold18)
                                }
                                Spacer()
                                Button(action: {
                                    viewModel.toggleFavorite()
                                }) {
                                    Image(systemName: viewModel.isFavorite ? "heart.fill" : "heart")
                                        .foregroundColor(viewModel.isFavorite ? .red : (colorScheme == .dark ? .white : .black))
                                        .frame(width: 35, height: 35)
                                }
                            }
                        }
                        .padding([.leading, .trailing], 15)
                        .padding(.top, 5)
                        
                        Text(restaurant.itemContent)
                            .foregroundColor(colorScheme == .dark ? .white : .black)
                            .font(.notosansRegular16)
                            .padding(.top, 2)
                            .padding([.leading, .trailing], 15)
                        
                        VStack(alignment: .leading, spacing: 5) {
                            if restaurant.contactTel != "" {
                                Text("연락처")
                                    .foregroundColor(colorScheme == .dark ? .white : .black)
                                    .font(.notosansBold16)
                                    .padding(.leading, 3)
                                HStack(spacing: 4) {
                                    Image(systemName: "phone.circle")
                                        .foregroundColor(colorScheme == .dark ? .white : .black)
                                        .font(.system(size: 16))
                                    Link("\(restaurant.contactTel)", destination: URL(string: "tel://\(restaurant.contactTel)")!)
                                        .foregroundColor(.blue)
                                        .padding(.bottom, 2)
                                }
                            }
                        }
                        .padding([.leading, .trailing], 15)
                        
                        VStack(alignment: .leading, spacing: 5) {
                            Text("운영 시간")
                                .font(.notosansBold16)
                                .padding(.leading, 3)
                                .foregroundColor(colorScheme == .dark ? .white : .black)

                            HStack(spacing: 4) {
                                Image(systemName: "clock")
                                    .foregroundColor(colorScheme == .dark ? .white : .black)
                                    .font(.system(size: 16))
                                    .alignmentGuide(.top) { _ in 0 }
                                    .frame(height: 16)
                                
                                VStack(alignment: .leading) {
                                    HStack {
                                        Text("운영 시간")
                                            .font(.notosansBold16)
                                            .foregroundColor(colorScheme == .dark ? .white : .black)

                                        Spacer()
                                        Image(systemName: viewModel.isExpanded ? "chevron.up" : "chevron.down")
                                            .foregroundColor(colorScheme == .dark ? .white : .black)
                                    }
                                    .onTapGesture {
                                        withAnimation {
                                            viewModel.isExpanded.toggle()
                                        }
                                    }
                                    
                                    if viewModel.isExpanded {
                                        Text(restaurant.usageDayWeekAndTime)
                                            .foregroundColor(colorScheme == .dark ? .white : .black)
                                            .font(.notosansRegular14)
                                            .padding(.top, 2)
                                    }
                                }
                                .padding(.leading, 4)
                                .padding(.bottom, 2)
                            }
                        }
                        .font(.notosansRegular16)
                        .padding([.leading, .trailing], 15)
                        .padding(.top, 25)
     
                        
                        Spacer()
                    }
                    else {
                        Text("맛집 정보를 불러올 수 없습니다.")
                    }
                }
                .navigationTitle(viewModel.restaurant?.title ?? "상세 정보")
            }
        }
        .onAppear {
            tabBarVisibility.isVisible = false
        }
        .onDisappear {
            tabBarVisibility.isVisible = true
        }
    }
}

#Preview {
    DetailResInfoView(viewModel: DetailResInfoViewModel(
        restaurant: Restaurant(
            mainTitle: "Sample Restaurant",
            gugunNm: "Haeundae",
            lat: 35.1587,
            lng: 129.1604,
            place: "Sample Place",
            title: "Sample Title",
            subtitle: "Sample Subtitle",
            addr1: "Sample Address 1",
            addr2: "Sample Address 2",
            contactTel: "010-1234-5678",
            homepageUrl: "http://example.com",
            usageDayWeekAndTime: "9 AM - 10 PM",
            rprsntvMenu: "Sample Menu",
            mainImgNormal: "sample_image",
            mainImgThumb: "sample_thumb",
            itemContent: "Sample item content"
        ),
        favoriteManager: FavoriteManager()
    ))
}
