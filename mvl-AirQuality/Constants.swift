//
//  Constants.swift
//  mvl-AirQuality
//
//  Created by 손대홍 on 2021/08/07.
//

import Foundation

enum BUTTON_NAME {
    enum CUSTOM_VIEW_A {
        static let POINT_A = "pointA"
        static let POINT_B = "pointB"
        static let CLEAR = "clear"
    }
    
    enum CUSTOM_VIEW_B {
        static let SET = "set"
    }
    
    enum CUSTOM_VIEW_C {
        static let BACK = "back"
    }
}

enum API {
    enum AIQ {
        static let BASE_URL = "https://api.waqi.info"
        static let ENDPOINT = "/feed/geo"
        static let TOKEN = "809ef3190596db15041a647ed0db24c5deb874e3"
    }
    enum LOCATION_INFO {
        static let BASE_URL = "https://api.bigdatacloud.net"
        static let ENDPOINT = "/data/reverse-geocode-client"
    }
    static let GMS_APIKEY = "AIzaSyDGUVsKsFG6d2NlXyMjiXtN_CkuR6zVPjU"
}
