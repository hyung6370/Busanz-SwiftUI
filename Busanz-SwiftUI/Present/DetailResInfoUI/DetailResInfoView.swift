//
//  DetailResInfoView.swift
//  Busanz-SwiftUI
//
//  Created by Hyungjun KIM on 8/12/24.
//

import SwiftUI

struct DetailResInfoView: View {
    var restaurant: Restaurant?
    
    var body: some View {
        VStack {
            if let restaurant = restaurant {
                ZStack {
                    Rectangle()
                        .fill(Color.customOrange)
                        .cornerRadius(15)
                        .frame(width: 370, height: 440)
                    
                    NaverMapView(lat: restaurant.lat, lng: restaurant.lng)
                        .padding([.leading, .trailing], 20)
                        .frame(width: 380, height: 410)
                }
                
                
                Text(restaurant.addr1)
                    .font(.notosansBold24)
                    
                Text(restaurant.itemContent)
                    .padding()
                
                Spacer()
            }
            else {
                Text("맛집 정보를 불러올 수 없습니다.")
            }
        }
        .navigationTitle(restaurant?.title ?? "상세 정보")
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
