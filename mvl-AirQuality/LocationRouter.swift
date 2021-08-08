//
//  LocationRouter.swift
//  mvl-AirQuality
//
//  Created by 손대홍 on 2021/08/08.
//

import Foundation
import Alamofire

enum LocationRouter: URLRequestConvertible {
    case getLocationInfo(lat: Double, long: Double)
    case getLocationAQI(lat: Double, long: Double)
    
    var method: HTTPMethod {
        return .get
    }
    
    var baseURL: String {
        switch self {
        case .getLocationInfo:
            return API.LOCATION_INFO.BASE_URL
        case.getLocationAQI:
            return API.AIQ.BASE_URL
        }
    }
    
    var endpoint: String {
        switch self {
        case .getLocationInfo:
            return API.LOCATION_INFO.ENDPOINT
        case.getLocationAQI:
            return API.AIQ.ENDPOINT
        }
    }
    
    var paramString: String {
        switch self {
        case let .getLocationInfo(lat, long):
            return "?latitude=\(lat)&longitude=\(long)&localityLanguage=ko"
        case let .getLocationAQI(lat, long):
            return ":\(lat);\(long)/?token=\(API.AIQ.TOKEN)"
        }
    }
    
    func asURLRequest() throws -> URLRequest {
        
        let url = baseURL + endpoint + paramString
        print("url: \(url)")
        var request = URLRequest(url: URL(string: url)!)
        request.method = method
        return request
    }
}
