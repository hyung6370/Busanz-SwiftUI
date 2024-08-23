//
//  SearchBarView.swift
//  Busanz-SwiftUI
//
//  Created by Hyungjun KIM on 8/22/24.
//

import SwiftUI

struct SearchBarView: View {
    @Binding var text: String
    var onSearch: () -> Void
    
    var body: some View {
        HStack {
            TextField("맛집을 입력해주세요.", text: $text, onCommit: onSearch)
                .padding(7)
                .padding(.horizontal, 25)
                .background(Color(.systemGray6))
                .cornerRadius(8)
                .overlay(
                    HStack {
                        Image(systemName: "magnifyingglass")
                            .foregroundColor(.gray)
                            .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
                            .padding(.leading, 8)
                        
                        if !text.isEmpty {
                            Button(action: {
                                self.text = ""
                            }) {
                                Image(systemName: "xmark.circle.fill")
                                    .foregroundColor(.gray)
                                    .padding(8)
                            }
                        }
                    }
                )
                .padding(.horizontal, 10)
            
            Button(action: onSearch) {
                Text("검색")
                    .font(.notosansMedium16)
                    .foregroundColor(.black)
            }
            .padding(.trailing, 10)
        }
    }
}

#Preview {
    SearchBarView(text: .constant(""), onSearch: {})
}
