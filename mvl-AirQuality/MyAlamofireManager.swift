//
//  MyAlamofireManager.swift
//  mvl-AirQuality
//
//  Created by 손대홍 on 2021/08/06.
//

import Foundation
import Alamofire
import SwiftyJSON
import RxSwift

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
    
    func getLocationAdressRx(latitude: Double, longitude: Double) -> Observable<String> {
        return Observable.create { (emitter) -> Disposable in
            
            self.getLocationInfo(latitude: latitude, longitude: longitude) { result in
                let sorted = result.sorted { (first, second) -> Bool in
                    return first["order"].intValue > second["order"].intValue
                }
                sorted.forEach {
                    print($0["order"], terminator: ", ")
                }
                let str = "\(sorted[1]["name"]) \(sorted[0]["name"])"
                print(str)
                
                emitter.onNext(str)
                emitter.onCompleted()
            }
            return Disposables.create()
        }
    }
}
