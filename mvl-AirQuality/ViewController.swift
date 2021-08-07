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
    var mapView: GMSMapView?
    var pointA: String?
    var pointB: String?
    var tempCoor: String?
    var tempAdress: String?
    var tempAQI: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
        let latitude = 37.566508 as Double
        let longitude = 126.977945 as Double
        
//        let latitude = (coor?.latitude ?? 37.566508) as Double
//        let longitude = (coor?.longitude ?? 126.977945) as Double
        
        
        // 카메라 세팅
        configMapView(latitude: latitude, longitude: longitude)
        //        let camera = GMSCameraPosition.camera(withLatitude: latitude, longitude: longitude, zoom: 16.0)
        //        let mapFrame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height/2)
        //        let mapView = GMSMapView.map(withFrame: mapFrame, camera: camera)
        
        
        mapView!.delegate = self
        
        // 마커 세팅
        
        mapMarker.position = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        mapMarker.title = "Sydney"
        mapMarker.snippet = "South Korea"
        mapMarker.map = mapView
    }
    
    // MARK: - fileprivate func
    fileprivate func configMapView(latitude: Double, longitude: Double) {
        let lat = latitude
        let long = longitude
        
        let camera = GMSCameraPosition.camera(withLatitude: lat, longitude: long, zoom: 16.0)
        let mapFrame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height - 100)
        self.mapView = GMSMapView.map(withFrame: mapFrame, camera: camera)
        
    }
    
    fileprivate func showCustomViewA() {
        let view = CustomViewA(frame: CGRect(x: 0, y: 0, width: self.view.layer.bounds.width, height: self.view.layer.bounds.height))
        UIView.transition(with: self.view, duration: 0.25, options: [.transitionCrossDissolve], animations: {
            self.view.addSubview(view)
        }) { [weak self] _ in
            view.pointALabel.text = self?.pointA ?? "a"
            view.pointBLabel.text = self?.pointB ?? "b"
        }
        view.delegate = self
        
    }
    
    fileprivate func showCustomViewB(_ view: CustomViewB) {
        UIView.transition(with: self.view, duration: 0.25, options: [.transitionCrossDissolve], animations: {
            self.view.addSubview(view)
        }) { [weak self] _ in
            view.addSubview((self?.mapView!)!)
        }
    }
    
    fileprivate func showCustomViewC() {
        let view = CustomViewC(frame: CGRect(x: 0, y: 0, width: self.view.layer.bounds.width, height: self.view.layer.bounds.height))
        UIView.transition(with: self.view, duration: 0.25, options: [.transitionCrossDissolve], animations: {
            self.view.addSubview(view)
        }) { [weak self] _ in
            view.pointALabel.text = self?.pointA
            view.pointBLabel.text = self?.pointB
        }
        view.delegate = self
    }
    
    
    // MARK: - IBOutlet, Action
    
    @IBAction func onSetPointAButtonClicked(_ sender: Any) {
        showCustomViewA()
    }
    
    @IBAction func onSetPointBButtonClicked(_ sender: Any) {
//        showCustomViewB()
    }
    
    @IBAction func onClearButtonClicked(_ sender: Any) {
        showCustomViewC()
    }
    
}

// MARK: - GMSMapViewDelegate Methods
extension ViewController: GMSMapViewDelegate {
    // 화면 드래그 시, 카메라의 포지션에 맞춰 마커 포지션 변경
    func mapView(_ mapView: GMSMapView, didChange position: GMSCameraPosition) {
        print("2")
        mapMarker.position = position.target
    }
    
    // 화면 렌더링 완료 or 드래그 후
    func mapViewSnapshotReady(_ mapView: GMSMapView) {
        print("1")
        print("lat: \(mapMarker.position.latitude) long: \(mapMarker.position.longitude)")
        let lat = mapMarker.position.latitude as Double
        let long = mapMarker.position.longitude as Double
        tempCoor = "\(lat)\n\(long)"
        
        MyAlamofireManager.shared.getLocationInfo(latitude: lat, longitude: long) { [weak self] result in
            let sorted = result.sorted { (first, second) -> Bool in
                return first["order"].intValue > second["order"].intValue
            }
            sorted.forEach {
                print($0["order"])
            }
            print("\(sorted[1]["name"]) \(sorted[0]["name"])")
            self?.tempAdress = "\(sorted[1]["name"]) \(sorted[0]["name"])"
        }
        
        MyAlamofireManager.shared.getLocationAQI(latitude: lat, longitude: long) { [weak self] result in
            print("aqi: \(result)")
            self?.tempAQI = "\(result)"
        }
    }
}

// MARK: - CustomViewProtocol 
extension ViewController: CustomViewProtocol {
    func sendCustomViewButtonIsClicked(buttonName: String) {
        switch buttonName {
        case BUTTON_NAME.CUSTOM_VIEW_A.POINT_A:
            print("setPointA")
            let view = CustomViewB(frame: CGRect(x: 0, y: 0, width: self.view.layer.bounds.width, height: self.view.layer.bounds.height))
            view.delegate = self
            view.myClosure = { [weak self] in
                self?.pointA = "pointA \n \(self?.tempCoor ?? "") \n Adress \(self?.tempAdress ?? "") \n AQI \(self?.tempAQI ?? "")"
            }
            showCustomViewB(view)
            
        case BUTTON_NAME.CUSTOM_VIEW_A.POINT_B:
            print("setPointB")
            let view = CustomViewB(frame: CGRect(x: 0, y: 0, width: self.view.layer.bounds.width, height: self.view.layer.bounds.height))
            view.delegate = self
            view.myClosure = { [weak self] in
                self?.pointB = "pointB \n \(self?.tempCoor ?? "") \n Adress: \(self?.tempAdress ?? "") \n AQI: \(self?.tempAQI ?? "")"
            }
            showCustomViewB(view)
            
        case BUTTON_NAME.CUSTOM_VIEW_A.CLEAR:
            print("clear")
            
        case BUTTON_NAME.CUSTOM_VIEW_B.SET:
            print("b")
            if let a = pointA, let b = pointB {
                showCustomViewC()
                
            }
            
        case BUTTON_NAME.CUSTOM_VIEW_C.BACK:
            pointA = nil
            pointB = nil
            
        default:
            print("default")
        }
    }
    
    
}
