//
//  FloatingFilterView.swift
//  Busanz-SwiftUI
//
//  Created by Hyungjun KIM on 8/12/24.
//

import SwiftUI

struct FloatingFilterView: View {
    @Binding var selectedGugun: String?
    
    var gugunList: [String]
    var onGugunSelected: (String?) -> Void
    
    @State private var isPickerVisible = false
    
    var body: some View {
        HStack(spacing: 10) {
            VStack(alignment: .leading) {
                Button(action: {
                    isPickerVisible.toggle()
                }) {
                    Text(selectedGugun ?? "구/군별로 보기")
                        .frame(width: 100, height: 30)
                        .background(Color.black)
                        .foregroundColor(Color.white)
                        .cornerRadius(15)
                }
            }
            .sheet(isPresented: $isPickerVisible) {
                PickerViewSheet(
                    selectedGugun: $selectedGugun,
                    gugunList: gugunList,
                    onGugunSelected: { selected in
                        onGugunSelected(selected)
                        isPickerVisible = false
                    })
            }
        }
        
    }
}

struct PickerViewSheet: View {
    @Binding var selectedGugun: String?
    
    var gugunList: [String]
    var onGugunSelected: (String?) -> Void
    
    var body: some View {
        VStack {
            Picker("구/군을 선택하세요.", selection: $selectedGugun) {
                Text("전체").tag(String?.none)
                ForEach(gugunList, id: \.self) { gugun in
                    Text(gugun).tag(String?.some(gugun))
                }
            }
            .pickerStyle(WheelPickerStyle())
            .labelsHidden()
            .cornerRadius(15)
            .onChange(of: selectedGugun) { _, newValue in
                onGugunSelected(newValue)
            }
        }
        .presentationDetents([.fraction(0.25)])
        .presentationDragIndicator(.visible)
    }
}


#Preview {
    FloatingFilterView(selectedGugun: .constant(nil), gugunList: ["중구", "서구", "동구", "영도구", "부산진구", "동래구", "남구", "북구", "해운대구", "사하구", "금정구", "강서구", "연제구", "수영구", "사상구", "기장군"]) { _ in}
}
