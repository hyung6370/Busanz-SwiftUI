//
//  APIResponse.swift
//  Busanz-SwiftUI
//
//  Created by Hyungjun KIM on 8/9/24.
//

import Foundation

struct APIResponse: Codable {
    let getFoodKr: ResponseBody
}

struct ResponseBody: Codable {
    let header: Header
    let item: [Restaurant]
    let numOfRows: Int
    let pageNo: Int
    let totalCount: Int
}

struct Header: Codable {
    let code: String
    let message: String
}
