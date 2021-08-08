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
    var tempAdress: String? {
        didSet {
            mapMarker.title = tempAdress
        }
    }
    var tempAQI: String? {
        didSet {
            mapMarker.snippet = "AQI: " + tempAQI!
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configLocationManager()
        // 위, 경도 가져오기
        let coor = locationManager.location?.coordinate
//                let latitude = (coor?.latitude ?? 37.566508) as Double
//                let longitude = (coor?.longitude ?? 126.977945) as Double
        
        let latitude = 37.566508 as Double
        let longitude = 126.977945 as Double
        
        // 카메라 세팅
        configMapView(latitude: latitude, longitude: longitude)
        
        // 마커 세팅
        mapMarker.position = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        //        mapMarker.title = "title"
        //        mapMarker.snippet = "snippet"
        mapMarker.map = mapView
        showCustomViewA()
    }
    
    // MARK: - fileprivate func
    fileprivate func configLocationManager() {
        // 현재 위치 가져오기
        locationManager = CLLocationManager()
        locationManager.delegate = self
        
        // 앱이 실행될 때 위치 추적 권한 요청
        locationManager.requestWhenInUseAuthorization()
        // 배터리에 맞게 권장되는 최적의 정확도
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        // 위치 업데이트
        locationManager.startUpdatingLocation()
    }
    
    fileprivate func configMapView(latitude: Double, longitude: Double) {
        let lat = latitude
        let long = longitude
        
        let camera = GMSCameraPosition.camera(withLatitude: lat, longitude: long, zoom: 16.0)
        let mapFrame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height - 100)
        mapView = GMSMapView.map(withFrame: mapFrame, camera: camera)
        mapView?.delegate = self
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
            pointA = nil
            pointB = nil
            showCustomViewA()
        case BUTTON_NAME.CUSTOM_VIEW_B.SET:
            print("b")
            
            if let _ = pointA, let _ = pointB {
                showCustomViewC()
            } else {
                showCustomViewA()
            }
            
        case BUTTON_NAME.CUSTOM_VIEW_C.BACK:
            pointA = nil
            pointB = nil
            showCustomViewA()
        default:
            print("default")
        }
    }
}

// MARK: fileprivate, view 제어
extension ViewController {
    fileprivate func showCustomViewA() {
        let viewA = CustomViewA(frame: CGRect(x: 0, y: 0, width: self.view.layer.bounds.width, height: self.view.layer.bounds.height))
        UIView.transition(with: self.view, duration: 0.25, options: [.transitionCrossDissolve], animations: {
            self.view.addSubview(viewA)
        }) { [weak self] _ in
            self?.updateViewLabel(viewA)
        }
        viewA.delegate = self
        
    }
    
    fileprivate func showCustomViewB(_ view: CustomViewB) {
        UIView.transition(with: self.view, duration: 0.25, options: [.transitionCrossDissolve], animations: {
            self.view.addSubview(view)
        }) { [weak self] _ in
            view.addSubview((self?.mapView!)!)
        }
    }
    
    fileprivate func showCustomViewC() {
        let viewC = CustomViewC(frame: CGRect(x: 0, y: 0, width: self.view.layer.bounds.width, height: self.view.layer.bounds.height))
        UIView.transition(with: self.view, duration: 0.25, options: [.transitionCrossDissolve], animations: {
            self.view.addSubview(viewC)
        }) { [weak self] _ in
            self?.updateViewLabel(viewC)
        }
        viewC.delegate = self
    }
    
    fileprivate func updateViewLabel(_ view: AnyObject) {
        if view is CustomViewA {
            let v = view as! CustomViewA
            v.pointALabel.text = self.pointA ?? "point a"
            v.pointBLabel.text = self.pointB ?? "point b"
        } else {
            // view is CustomViewC
            let v = view as! CustomViewC
            v.pointALabel.text = self.pointA ?? "값 전달 체크"
            v.pointBLabel.text = self.pointB ?? "값 전달 체크"
        }
    }
}

// MARK: - GMSMapViewDelegate
extension ViewController: GMSMapViewDelegate {
    // 화면 드래그 시, 카메라의 포지션에 맞춰 마커 포지션 변경
    func mapView(_ mapView: GMSMapView, didChange position: GMSCameraPosition) {
        mapMarker.position = position.target
    }
    
    func mapView(_ mapView: GMSMapView, idleAt position: GMSCameraPosition) {
        print("lat: \(mapMarker.position.latitude) long: \(mapMarker.position.longitude)")
        let lat = mapMarker.position.latitude as Double
        let long = mapMarker.position.longitude as Double
        tempCoor = "lat: \(lat)\n long: \(long)"
        
        MyAlamofireManager.shared.getLocationInfo(latitude: lat, longitude: long) { [weak self] result in
            print(type(of: result))     // Array<JSON>
            let sorted = result.sorted { (first, second) -> Bool in
                return first["order"].intValue > second["order"].intValue
            }
            sorted.forEach {
                print($0["order"], terminator: ", ")
            }
            let str = "\(sorted[1]["name"]) \(sorted[0]["name"])"
            print(str)
            self?.tempAdress = str
        }
        
        MyAlamofireManager.shared.getLocationAQI(latitude: lat, longitude: long) { [weak self] result in
            print(type(of: result))     // JSON
            print("aqi: \(result)")
            self?.tempAQI = "\(result)"
        }
    }
}
