//
//  HCard.swift
//  Busanz-SwiftUI
//
//  Created by Hyungjun KIM on 9/3/24.
//

import SwiftUI

struct HCard: View {
    var restaurant: Restaurant?
    
    var body: some View {
        if let restaurant = restaurant {
            HStack(spacing: 20) {
                VStack(alignment: .leading, spacing: 8) {
                    Text(restaurant.mainTitle)
                        .font(.juaRegualr28)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    Text(restaurant.rprsntvMenu)
                        .font(.notosansMedium18)
                }
                Divider()
                if let imageURL = URL(string: restaurant.mainImgNormal) {
                    AsyncImage(url: imageURL) { phase in
                        switch phase {
                        case .empty:
                            IndicatorView()
                        case .success(let image):
                            image
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(maxWidth: .infinity)
                                .cornerRadius(15)
                                .clipped()
                        case .failure:
                            Image(systemName: "photo")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(maxWidth: .infinity)
                                .opacity(0.3)
                                .cornerRadius(15)
                        @unknown default:
                            EmptyView()
                        }
                    }
                }
                else {
                    Image(systemName: "photo")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(maxWidth: .infinity)
                        .opacity(0.3)
                }
            }
            .padding(30)
            .frame(maxWidth: .infinity, maxHeight: 110)
            .background(Color.hCardColor)
            .foregroundColor(.white)
            .mask(RoundedRectangle(cornerRadius: 30, style: .continuous))
        }
    }
}

#Preview {
    HCard(restaurant: Restaurant(
        mainTitle: "공감식당",
        gugunNm: "Haeundae",
        lat: 35.1587,
        lng: 129.1604,
        place: "Sample Place",
        title: "Sample Title",
        subtitle: "Sample Subtitle",
        addr1: "부산진구 동평로 81",
        addr2: "Sample Address 2",
        contactTel: "010-1234-5678",
        homepageUrl: "http://example.com",
        usageDayWeekAndTime: "9 AM - 10 PM",
        rprsntvMenu: "맑고 청아한 조개탕",
        mainImgNormal: "https://www.visitbusan.net/uploadImgs/files/cntnts/20230607132213312_ttiel",
        mainImgThumb: "https://www.visitbusan.net/uploadImgs/files/cntnts/20210913110103549_thumbL",
        itemContent: "Sample item content"
    ))
}
