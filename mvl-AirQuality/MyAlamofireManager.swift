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

    let aiqToken = "809ef3190596db15041a647ed0db24c5deb874e3"
    
    func getLocationInfo(latitude: Double, longitude: Double, completion: @escaping ([JSON]) -> Void) {
        let lat = latitude
        let long = longitude
        
        AF.request("https://api.bigdatacloud.net/data/reverse-geocode-client?latitude=\(lat)&longitude=\(long)&localityLanguage=ko").responseJSON { (response) in
            if let value = response.value {
                let json = JSON(value)
                completion(json["localityInfo"]["administrative"].arrayValue)
            }
        }
    }
    
    func getLocationAQI(latitude: Double, longitude: Double, completion: @escaping (JSON) -> Void) {
        let lat = latitude
        let long = longitude
        
        AF.request("https://api.waqi.info/feed/geo:\(lat);\(long)/?token=\(aiqToken)").responseJSON { (response) in
            if let value = response.value {
                let json = JSON(value)
                completion(json["data"]["aqi"])
            }
        }
    }
}
