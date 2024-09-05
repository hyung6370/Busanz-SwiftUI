//
//  DetailResInfoView.swift
//  Busanz-SwiftUI
//
//  Created by Hyungjun KIM on 8/12/24.
//

import SwiftUI

struct DetailResInfoView: View {
    var restaurant: Restaurant?
    @State private var isExpanded: Bool = false
    @EnvironmentObject var favoriteManager: FavoriteManager
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading) {
                if let restaurant = restaurant {
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
                            .font(.notosansBold16)
                            .padding(.leading, 3)
                        HStack(spacing: 4) {
                            Image(systemName: "house.circle")
                                .foregroundColor(.black)
                                .font(.system(size: 16))
                                .padding(.top, 3)
                            let busan = restaurant.addr1
                            if busan.contains("부산시") {
                                Text(restaurant.addr1)
                                    .font(.notosansBold18)
                            }
                            else {
                                Text("부산시 " + restaurant.addr1)
                                    .font(.notosansBold18)
                            }
                            Spacer()
                            Button(action: {
                                toggleFavorite(restaurant)
                            }) {
                                Image(systemName: favoriteManager.isFavorite(restaurant) ? "heart.fill" : "heart")
                                    .foregroundColor(favoriteManager.isFavorite(restaurant) ? .red : .black)
                            }
                        }
                    }
                    .padding([.leading, .trailing], 15)
                    .padding(.top, 5)
                    
                    Text(restaurant.itemContent)
                        .font(.notosansRegular16)
                        .padding(.top, 2)
                        .padding([.leading, .trailing], 15)
                    
                    VStack(alignment: .leading, spacing: 5) {
                        if restaurant.contactTel != "" {
                            Text("연락처")
                                .font(.notosansBold16)
                                .padding(.leading, 3)
                            HStack(spacing: 4) {
                                Image(systemName: "phone.circle")
                                    .foregroundColor(.black)
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
                            .foregroundColor(.black)
                        
                        HStack(spacing: 4) {
                            Image(systemName: "clock")
                                .foregroundColor(.black)
                                .font(.system(size: 16))
                                .alignmentGuide(.top) { _ in 0 }
                                .frame(height: 16)
                            
                            VStack(alignment: .leading) {
                                HStack {
                                    Text("운영 시간")
                                        .font(.notosansBold16)
                                    Spacer()
                                    Image(systemName: isExpanded ? "chevron.up" : "chevron.down")
                                        .foregroundColor(.black)
                                }
                                .onTapGesture {
                                    withAnimation {
                                        isExpanded.toggle()
                                    }
                                }
                                
                                if isExpanded {
                                    Text(restaurant.usageDayWeekAndTime)
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
            .navigationTitle(restaurant?.title ?? "상세 정보")
        }
    }
    
    func toggleFavorite(_ restaurant: Restaurant) {
        if favoriteManager.isFavorite(restaurant) {
            favoriteManager.removeFavorite(restaurant)
        }
        else {
            favoriteManager.addFavorite(restaurant)
        }
    }
}

#Preview {
    DetailResInfoView(restaurant: Restaurant(
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
    ))
}
