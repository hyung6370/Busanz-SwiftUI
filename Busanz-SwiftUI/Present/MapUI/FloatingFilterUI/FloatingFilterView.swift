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
    var onCountSelected: (Int) -> Void
    
    @State private var isPickerVisible = false
    @State private var isCountPickerVisible = false
    @State private var selectedCount: Int = 100
    
    var counts = [10, 20, 50, 100, Int.max]
    
    var body: some View {
        HStack(spacing: 10) {
            VStack(alignment: .leading) {
                Button(action: {
                    isPickerVisible.toggle()
                }) {
                    Text(selectedGugun ?? "구/군별로 보기")
                        .frame(width: 100, height: 30)
                        .background(Color.white)
                        .foregroundColor(Color.black)
                        .cornerRadius(15)
                        .shadow(color: .gray, radius: 5, x: 0, y: 2)
                        .font(.notosansMedium16)
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
            
            VStack(alignment: .leading) {
                Button(action: {
                    isCountPickerVisible.toggle()
                }) {
                    Text("개수별로 보기")
                        .frame(width: 100, height: 30)
                        .background(Color.white)
                        .foregroundColor(Color.black)
                        .cornerRadius(15)
                        .shadow(color: .gray, radius: 5, x: 0, y: 2)
                        .font(.custom("NotoSansCJKkr-Regular", size: 16))
                }
            }
            .actionSheet(isPresented: $isCountPickerVisible) {
                ActionSheet(title: Text("표시할 개수를 선택하세요"), buttons: counts.map { count in
                    .default(Text(count == Int.max ? "전체" : "\(count)개")) {
                        selectedCount = count
                        onCountSelected(selectedCount)
                    }
                } + [.cancel()])
            }
        }
        .padding()
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
    FloatingFilterView(
        selectedGugun: .constant(nil),
        gugunList: ["중구", "서구", "동구", "영도구", "부산진구", "동래구", "남구", "북구", "해운대구", "사하구", "금정구", "강서구", "연제구", "수영구", "사상구", "기장군"],
        onGugunSelected: { gugun in
            print("Selected Gugun: \(gugun ?? "전체")")
        },
        onCountSelected: { count in
            print("Selected Count: \(count == Int.max ? "전체" : "\(count)개")")
        }
    )
}
