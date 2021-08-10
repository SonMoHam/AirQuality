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
    
    func getInfoString() -> String {
        return "\(coor ?? "")\nAdress: \(adress ?? "")\nAQI: \(AQI ?? "")"
    }
}
