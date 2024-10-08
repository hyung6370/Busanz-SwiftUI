//
//  VCard.swift
//  Busanz-SwiftUI
//
//  Created by Hyungjun KIM on 9/2/24.
//

import SwiftUI
import Kingfisher

struct VCard: View {
    var restaurant: Restaurant?
    var index: Int
    
    let colors: [Color] = [.vCardColor, .vCardColor2, .vCardColor3]
    
    var body: some View {
        if let restaurant = restaurant {
            VStack(alignment: .leading, spacing: 8) {
                Text(restaurant.mainTitle)
                    .font(.juaRegualr28)
                    .frame(maxWidth: 170, alignment: .leading)
                    .layoutPriority(1)
                    .padding(.leading, 3)
                    .lineLimit(2)
                    .multilineTextAlignment(.leading)
                Text(restaurant.addr1)
                    .font(.notosansRegular14)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .opacity(0.7)
  
                if let imageURL = URL(string: restaurant.mainImgThumb) {
                    KFImage(imageURL)
                        .onSuccess { result in
                            
                        }
                        .placeholder {
                            IndicatorView()
                                .padding(.leading, 75)
                                .padding(.top, 50)
                        }
                        .resizable()
                        .cacheOriginalImage()
                        .loadDiskFileSynchronously()
                        .downsampling(size: CGSize(width: 300, height: 300))
                        .cornerRadius(15)
                }
                else {
                    Image(systemName: "photo")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(maxWidth: .infinity)
                        .opacity(0.3)
                }
            }
            .foregroundColor(.white)
            .padding(30)
            .frame(width: 260, height: 310)
            .background(.linearGradient(colors: [colors[index % colors.count], colors[index % colors.count].opacity(0.5)], startPoint: .topLeading, endPoint: .bottomTrailing))
            .mask(RoundedRectangle(cornerRadius: 30, style: .continuous))
        }
        
    }
}

#Preview {
    VCard(restaurant: Restaurant(
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
        rprsntvMenu: "Sample Menu",
        mainImgNormal: "sample_image",
        mainImgThumb: "https://www.visitbusan.net/uploadImgs/files/cntnts/20210913110103549_thumbL",
        itemContent: "Sample item content"
    ),
          index: 0
    )
}
