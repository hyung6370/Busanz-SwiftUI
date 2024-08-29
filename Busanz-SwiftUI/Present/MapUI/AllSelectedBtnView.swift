//
//  AllSelectedBtnView.swift
//  Busanz-SwiftUI
//
//  Created by Hyungjun KIM on 8/28/24.
//

import SwiftUI

struct AllSelectedBtnView: View {
    var onShowAll: () -> Void
    
    var body: some View {
        Button(action: {
            onShowAll()
        }) {
            Text("전체보기")
                .frame(width: 80, height: 30)
                .background(Color.white)
                .foregroundColor(Color.black)
                .cornerRadius(15)
                .shadow(color: .gray, radius: 5, x: 0, y: 2)
                .font(.notosansMedium14)
        }
    }
}
