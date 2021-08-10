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
import RxSwift
import RxCocoa

class ViewController: UIViewController, CLLocationManagerDelegate {

    var locationManager: CLLocationManager!
    let mapMarker = GMSMarker()
    var mapView: GMSMapView?
    
    var pointA: String?
    var pointB: String?
    var tempInfo: LocationInfo = LocationInfo()
    
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
        mapMarker.map = mapView
        let viewFrame = CGRect(x: 0, y: 0, width: self.view.layer.bounds.width, height: self.view.layer.bounds.height)
        showCustomView(CustomViewA(frame: viewFrame))
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
        let camera = GMSCameraPosition.camera(withLatitude: latitude, longitude: longitude, zoom: 16.0)
        let mapFrame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height - 100)
        mapView = GMSMapView.map(withFrame: mapFrame, camera: camera)
        mapView?.delegate = self
    }
    
}

// MARK: - CustomViewProtocol 
extension ViewController: CustomViewProtocol {
    func sendCustomViewButtonIsClicked(buttonName: String) {
        
        let viewFrame = CGRect(x: 0, y: 0, width: self.view.layer.bounds.width, height: self.view.layer.bounds.height)
        
        switch buttonName {
        
        case BUTTON_NAME.CUSTOM_VIEW_A.POINT_A:
            print("setPointA")
            let viewB = CustomViewB(frame: viewFrame)
            viewB.delegate = self
            viewB.myClosure = { [weak self] in
                self?.pointA = "point a \n \(self?.tempInfo.getInfoString() ?? "")"
            }
            showCustomView(viewB)
            
        case BUTTON_NAME.CUSTOM_VIEW_A.POINT_B:
            print("setPointB")
            let viewB = CustomViewB(frame: viewFrame)
            viewB.delegate = self
            viewB.myClosure = { [weak self] in
                self?.pointB = "point b \n \(self?.tempInfo.getInfoString() ?? "")"
            }
            showCustomView(viewB)
            
        case BUTTON_NAME.CUSTOM_VIEW_A.CLEAR:
            pointA = nil
            pointB = nil
            showCustomView(CustomViewA(frame: viewFrame))
            
        case BUTTON_NAME.CUSTOM_VIEW_B.SET:
            print("b Set")
            
            if let _ = pointA, let _ = pointB {
                showCustomView(CustomViewC(frame: viewFrame))
            } else {
                showCustomView(CustomViewA(frame: viewFrame))
            }
            
        case BUTTON_NAME.CUSTOM_VIEW_C.BACK:
            pointA = nil
            pointB = nil
            showCustomView(CustomViewA(frame: viewFrame))
            
        default:
            print("default")
        }
    }
}

// MARK: fileprivate, view 제어
extension ViewController {
    fileprivate func showCustomView(_ v: AnyObject) {
        
        if v is CustomViewA {
            let viewA = v as! CustomViewA
            UIView.transition(with: self.view, duration: 0.25, options: [.transitionCrossDissolve], animations: {
                self.view.addSubview(viewA)
            }) { [weak self] _ in
                self?.updateViewLabel(viewA)
            }
            viewA.delegate = self
            
        } else if v is CustomViewB {
            let viewB = v as! CustomViewB
            UIView.transition(with: self.view, duration: 0.25, options: [.transitionCrossDissolve], animations: {
                self.view.addSubview(viewB)
            }) { [weak self] _ in
                viewB.addSubview((self?.mapView!)!)
            }
            
        } else if v is CustomViewC {
            let viewC = v as! CustomViewC
            UIView.transition(with: self.view, duration: 0.25, options: [.transitionCrossDissolve], animations: {
                self.view.addSubview(viewC)
            }) { [weak self] _ in
                self?.updateViewLabel(viewC)
            }
            viewC.delegate = self
            
        } else {
            print("showCustomview - else")
        }
    }
    
    fileprivate func updateViewLabel(_ v: AnyObject) {
        if v is CustomViewA {
            let view = v as! CustomViewA
            view.pointALabel.text = self.pointA ?? "point a"
            view.pointBLabel.text = self.pointB ?? "point b"
        } else if v is CustomViewC{
            let view = v as! CustomViewC
            view.pointALabel.text = self.pointA ?? "값 전달 체크"
            view.pointBLabel.text = self.pointB ?? "값 전달 체크"
        } else {
            print("updateViewLabel - else")
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
        
        self.tempInfo.coor = "lat: \(lat)\n long: \(long)"
        
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

            self?.tempInfo.adress = str
            self?.mapMarker.title = str
        }
        
        MyAlamofireManager.shared.getLocationAQI(latitude: lat, longitude: long) { [weak self] result in
            print(type(of: result))     // JSON
            print("aqi: \(result)")
            
            self?.tempInfo.AQI = "\(result)"
            self?.mapMarker.snippet = "AQI: \(result)"
        }
    }
}


