//
//  Color++Ex.swift
//  Busanz-SwiftUI
//
//  Created by Hyungjun KIM on 8/23/24.
//

import SwiftUI

extension Color {
    static let customOrange = Color(hex: "d24134")
    static let vCardColor = Color(hex: "7850F0")
    static let vCardColor2 = Color(hex: "6792FF")
    static let vCardColor3 = Color(hex: "005FE7")
    
    static let hCardColor = Color(hex: "9CC5FF")
    static let hCardColor2 = Color(hex: "6E6AE8")
    static let hCardColor3 = Color(hex: "005FE7")
    static let hCardColor4 = Color(hex: "BBA6FF")
    
    init(hex: String) {
        let scanner = Scanner(string: hex)
        scanner.currentIndex = hex.startIndex
        var rgbValue: UInt64 = 0
        scanner.scanHexInt64(&rgbValue)
        
        let red = Double((rgbValue & 0xFF0000) >> 16) / 255.0
        let green = Double((rgbValue & 0x00FF00) >> 8) / 255.0
        let blue = Double(rgbValue & 0x0000FF) / 255.0
        
        self.init(red: red, green: green, blue: blue)
    }
}
