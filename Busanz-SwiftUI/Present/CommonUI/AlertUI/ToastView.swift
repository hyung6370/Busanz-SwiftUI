//
//  ToastView.swift
//  Busanz-SwiftUI
//
//  Created by Hyungjun KIM on 8/27/24.
//

import SwiftUI

struct ToastView: View {
    let message: String
    
    var body: some View {
        Text(message)
            .foregroundColor(.white)
            .padding()
            .background(Color.black.opacity(0.7))
            .cornerRadius(10)
            .padding(.top, 100)
            .transition(.slide)
            .zIndex(1)
    }
}

#Preview {
    ToastView(message: "검색된 맛집이 없습니다.")
}
