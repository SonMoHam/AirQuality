//
//  MyAlamofireManager.swift
//  mvl-AirQuality
//
//  Created by 손대홍 on 2021/08/06.
//

import Foundation
import Alamofire
import SwiftyJSON


final class MyAlamofireManager {  // 오버라이드 금지, 재정의 필요 없음
    
    static let shared = MyAlamofireManager()
    
    func getLocationInfo(latitude: Double, longitude: Double, completion: @escaping ([JSON]) -> Void) {
        
        AF.request(LocationRouter.getLocationInfo(lat: latitude, long: longitude)).responseJSON { (response) in
            if let value = response.value {
                let json = JSON(value)
                completion(json["localityInfo"]["administrative"].arrayValue)
            }
        }
    }
    
    func getLocationAQI(latitude: Double, longitude: Double, completion: @escaping (JSON) -> Void) {
        
        AF.request(LocationRouter.getLocationAQI(lat: latitude, long: longitude)).responseJSON { (response) in
            if let value = response.value {
                let json = JSON(value)
                completion(json["data"]["aqi"])
            }
        }
    }
}
