//
//  BusanRestaurantKorManager.swift
//  Busanz-SwiftUI
//
//  Created by Hyungjun KIM on 8/9/24.
//

import Foundation
import Alamofire
import Combine

class BusanRestaurantKorManager {
    private let baseURL = "http://apis.data.go.kr/6260000/FoodService/getFoodKr"
    private let serviceKey = Bundle.main.DATA_DECODING_KEY
    
    func fetchRestaurants() -> AnyPublisher<[Restaurant], Error> {
        let parameters: Parameters = [
            "serviceKey": serviceKey,
            "numOfRows": 10,
            "pageNo": 1,
            "resultType": "json"
        ]
        
        return AF.request(baseURL, parameters: parameters)
            .publishData()
            .tryMap { response in
                guard let data = response.data else {
                    throw URLError(.badServerResponse)
                }
                
                let apiResponse = try JSONDecoder().decode(APIResponse.self, from: data)
                return apiResponse.getFoodKr.item
            }
            .eraseToAnyPublisher()
    }
}


