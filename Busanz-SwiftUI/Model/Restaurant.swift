//
//  Restaurant.swift
//  Busanz-SwiftUI
//
//  Created by Hyungjun KIM on 8/9/24.
//

import Foundation

struct Restaurant: Codable {
    let mainTitle: String
    let gugunNm: String
    let lat: Double
    let lng: Double
    let place: String
    let title: String
    let subtitle: String
    let addr1: String
    let addr2: String?
    let contactTel: String
    let homepageUrl: String
    let usageDayWeekAndTime: String
    let rprsntvMenu: String
    let mainImgNormal: String
    let mainImgThumb: String
    let itemContent: String
    
    enum CodingKeys: String, CodingKey {
        case mainTitle = "MAIN_TITLE"
        case gugunNm = "GUGUN_NM"
        case lat = "LAT"
        case lng = "LNG"
        case place = "PLACE"
        case title = "TITLE"
        case subtitle = "SUBTITLE"
        case addr1 = "ADDR1"
        case addr2 = "ADDR2"
        case contactTel = "CNTCT_TEL"
        case homepageUrl = "HOMEPAGE_URL"
        case usageDayWeekAndTime = "USAGE_DAY_WEEK_AND_TIME"
        case rprsntvMenu = "RPRSNTV_MENU"
        case mainImgNormal = "MAIN_IMG_NORMAL"
        case mainImgThumb = "MAIN_IMG_THUMB"
        case itemContent = "ITEMCNTNTS"
    }
}
