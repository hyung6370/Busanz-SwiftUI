//
//  BusanRestaurantKorManager.swift
//  Busanz-SwiftUI
//
//  Created by Hyungjun KIM on 8/9/24.
//

import Foundation
import Alamofire

class BusanRestaurantKorManager {
    private let baseURL = "http://apis.data.go.kr/6260000/FoodService/getFoodKr"
    private let serviceKey = Bundle.main.DATA_ENCODING_KEY
    
    func fetchRestaruants(completion: @escaping ([Restaurant]?) -> Void) {
        let parameters: Parameters = [
            "serviceKey": serviceKey,
            "numOfRows": 10,
            "pageNo": 1,
            "resultType": "json"
        ]
        
        AF.request(baseURL, parameters: parameters).responseDecodable(of: APIResponse.self) { response in
            switch response.result {
            case .success(let apiResponse):
                completion(apiResponse.body.items)
            case .failure(let error):
                print("Error fetching restaruants: \(error)")
                completion(nil)
            }
        }
    }
}

struct APIResponse: Codable {
    let body: ResponseBody
}

struct ResponseBody: Codable {
    let items: [Restaurant]
}
