//
//  ViewController.swift
//  mvl-AirQuality
//
//  Created by 손대홍 on 2021/08/05.
//

import UIKit
import GoogleMaps
import CoreLocation
import MapKit

class ViewController: UIViewController, CLLocationManagerDelegate {
    
    var locationManager: CLLocationManager!
    let mapMarker = GMSMarker()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        pointALabel.layer.borderWidth = 1
        pointALabel.layer.borderColor = #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)
        pointALabel.layer.cornerRadius = 5
        
        pointBLabel.layer.borderWidth = 1
        pointBLabel.layer.borderColor = #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)
        pointBLabel.layer.cornerRadius = 5
        
        // 현재 위치 가져오기
        locationManager = CLLocationManager()
        locationManager.delegate = self
        
        // 앱이 실행될 때 위치 추적 권한 요청
        locationManager.requestWhenInUseAuthorization()
        // 배터리에 맞게 권장되는 최적의 정확도
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        // 위치 업데이트
        locationManager.startUpdatingLocation()
        
        // 위, 경도 가져오기
        let coor = locationManager.location?.coordinate
        
        let latitude = (coor?.latitude ?? 37.566508) as Double
        let longitude = (coor?.longitude ?? 126.977945) as Double
        
        
        // 카메라 세팅
        let camera = GMSCameraPosition.camera(withLatitude: latitude, longitude: longitude, zoom: 16.0)
        let mapFrame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height/2)
        let mapView = GMSMapView.map(withFrame: mapFrame, camera: camera)
        self.view.addSubview(mapView)
        
        mapView.delegate = self
        
        // 마커 세팅
        
        mapMarker.position = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        mapMarker.title = "Sydney"
        mapMarker.snippet = "South Korea"
        mapMarker.map = mapView
    }
    
    // MARK: - IBOutlet, Action
    @IBOutlet weak var pointALabel: UILabel!
    @IBOutlet weak var pointBLabel: UILabel!
    
    @IBAction func onSetPointAButtonClicked(_ sender: Any) {
        MyAlamofireManager.shared.getLocationInfo(latitude: "37.566508", longitude: "126.977945") { result in

            result.forEach {
                print($0["order"])
            }
            let sorted = result.sorted { (first, second) -> Bool in
                return first["order"].intValue > second["order"].intValue
            }
            print("\(sorted[0]["name"]) \(sorted[1]["name"])")
        }
    }
    @IBAction func onSetPointBButtonClicked(_ sender: Any) {
        MyAlamofireManager.shared.getLocationAQI(latitude: "37.566508", longitude: "126.977945") { result in

        }
    }
    @IBAction func onClearButtonClicked(_ sender: Any) {
        
    }
    
}


extension ViewController: GMSMapViewDelegate {
    
    func mapView(_ mapView: GMSMapView, didChange position: GMSCameraPosition) {
        print("2")
        mapMarker.position = position.target
    }
}

