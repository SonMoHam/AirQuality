//
//  Model.swift
//  mvl-AirQuality
//
//  Created by 손대홍 on 2021/08/10.
//

import Foundation

struct LocationInfo {
    var coor: String?
    var adress: String?
    var AQI: String?
    
    func isHasNil() -> Bool {
        if coor != nil && adress != nil && AQI != nil {
            return false
        } else {
            return true
        }
    }
    
    func getInfoString() -> String {
        return "\(coor ?? "")\nAdress: \(adress ?? "")\nAQI: \(AQI ?? "")"
    }
    
    func getLatitude() -> Double {
        guard let str = coor else { return 0 }
        let splited = str.split(separator: "\n")
        let latitude = Double(splited[0].split(separator: " ")[1]) ?? 0

        return latitude
    }
    
    func getLongitude() -> Double {
        guard let str = coor else { return 0 }
        let splited = str.split(separator: "\n")
        let longitude = Double(splited[1].split(separator: " ")[1]) ?? 0

        return longitude
    }
}
