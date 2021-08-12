//
//  ViewModel.swift
//  mvl-AirQuality
//
//  Created by 손대홍 on 2021/08/12.
//

import Foundation
import RxSwift

class ViewModel {
    var disposeBag = DisposeBag()
    var pointA: String?
    var pointB: String?
    
    var tempInfo: LocationInfo? {
        didSet{
            if tempInfo!.isHasNil() {
                
            } else {
                didFinishGetLocationInfo?()
            }
        }
    }
    var locationInfos: [LocationInfo] = []
    
    
    
    func getLocationInfo(lat: Double, long: Double) {
        
        tempInfo = LocationInfo()
        self.tempInfo?.coor = "lat: \(lat)\nlong: \(long)"
        
        MyAlamofireManager.shared.getLocationAdressRx(latitude: lat, longitude: long)
            .map { $0.sorted{ $0["order"].intValue > $1["order"].intValue }}
            .map { "\($0[1]["name"]) \($0[0]["name"])" }
            .subscribe(onNext: { [weak self] (result) in
                print(result)
                
                self?.tempInfo?.adress = result
            })
            .disposed(by: self.disposeBag)
        
        MyAlamofireManager.shared.getLocationAQIRx(latitude: lat, longitude: long)
            .map { $0.stringValue }
            .subscribe(onNext: { [weak self] (result) in
                print("aqi: \(result)")
                
                self?.tempInfo?.AQI = "\(result)"
            })
            .disposed(by: self.disposeBag)
    }
    
    func getPointA() -> String {
        return pointA ?? "point a"
    }
    
    func setPointA(content: String) {
        pointA = "point a \n" + content
    }
    
    func getPointB() -> String {
        return pointB ?? "point b"
    }
    
    func setPointB(content: String) {
        pointB = "point b \n" + content
    }
    
    func clearPoints() {
        pointA = nil
        pointB = nil
    }
    
    var didFinishGetLocationInfo: (() -> ())?
}
