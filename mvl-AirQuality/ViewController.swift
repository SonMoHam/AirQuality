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

class ViewController: UIViewController, CLLocationManagerDelegate {
    
    var locationManager: CLLocationManager!
    let mapMarker = GMSMarker()
    var mapView: GMSMapView?
    var myTableView: UITableView?
    
    let viewModel = ViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configLocationManager()
        // 현재 위치 위, 경도 가져오기
        //        let coor = locationManager.location?.coordinate
        //                let latitude = (coor?.latitude ?? 37.566508) as Double
        //                let longitude = (coor?.longitude ?? 126.977945) as Double
        
        let latitude = 37.566508 as Double
        let longitude = 126.977945 as Double
        
        // 카메라 세팅
        configMapView(latitude: latitude, longitude: longitude)
        configMyTableView()
        // 마커 세팅
        mapMarker.position = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        mapMarker.map = mapView
        
        // 타이틀, 스니펫 띄우기
        mapView?.selectedMarker = mapMarker
        let viewFrame = CGRect(x: 0, y: 0, width: self.view.layer.bounds.width, height: self.view.layer.bounds.height)
        
        showCustomView(CustomViewA(frame: viewFrame))
        
    }
    
    // MARK: - fileprivate func - config
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
        let mapFrame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: (self.view.frame.height - 100) / 2 )
        mapView = GMSMapView.map(withFrame: mapFrame, camera: camera)
        mapView?.delegate = self
    }
    
    fileprivate func configMyTableView() {
        let tableFrame = CGRect(x: 0, y: (self.view.frame.height - 100) / 2, width: self.view.frame.width, height: (self.view.frame.height - 100) / 2)
        myTableView = UITableView()
        let myTableViewCellNib = UINib(nibName: String(describing: MyTableViewCell.self), bundle: nil)
        
        myTableView?.register(myTableViewCellNib, forCellReuseIdentifier: "myTableViewCell")
        
        myTableView?.rowHeight = UITableView.automaticDimension
        myTableView?.estimatedRowHeight = 120
        
        myTableView?.delegate = self
        myTableView?.dataSource = self
        
        myTableView?.translatesAutoresizingMaskIntoConstraints = false
        myTableView?.frame = tableFrame
        
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
                
                guard let info = self?.viewModel.tempInfo else { return  }
                let str = info.getInfoString()
                
                self?.viewModel.pointA = "point a \n" + str
                self?.viewModel.locationInfos.append(info)
            }
            showCustomView(viewB)
            
        case BUTTON_NAME.CUSTOM_VIEW_A.POINT_B:
            print("setPointB")
            let viewB = CustomViewB(frame: viewFrame)
            viewB.delegate = self
            viewB.myClosure = { [weak self] in
                
                guard let info = self?.viewModel.tempInfo else { return  }
                let str = info.getInfoString()
                
                self?.viewModel.pointB = "point b \n" + str
                self?.viewModel.locationInfos.append(info)
            }
            showCustomView(viewB)
            
        case BUTTON_NAME.CUSTOM_VIEW_A.CLEAR:
            viewModel.clearPoints()
            showCustomView(CustomViewA(frame: viewFrame))
            
        case BUTTON_NAME.CUSTOM_VIEW_B.SET:
            print("b Set")

            if let _ = viewModel.pointA, let _ = viewModel.pointB {
                showCustomView(CustomViewC(frame: viewFrame))
            } else {
                showCustomView(CustomViewA(frame: viewFrame))
            }
            
        case BUTTON_NAME.CUSTOM_VIEW_C.BACK:
            viewModel.clearPoints()
            showCustomView(CustomViewA(frame: viewFrame))
            
        default:
            print("default")
        }
    }
}

// MARK: fileprivate view Control
extension ViewController {
    fileprivate func showCustomView(_ v: AnyObject) {
        switch v {
        
        case is CustomViewA:
            let viewA = v as! CustomViewA
            UIView.transition(with: self.view, duration: 0.25, options: [.transitionCrossDissolve], animations: {
                self.view.addSubview(viewA)
            }) { [weak self] _ in
                self?.updateViewLabel(viewA)
            }
            viewA.delegate = self
            
        case is CustomViewB:
            let viewB = v as! CustomViewB
            UIView.transition(with: self.view, duration: 0.25, options: [.transitionCrossDissolve], animations: {
                self.view.addSubview(viewB)
            }) { [weak self] _ in
                viewB.addSubview((self?.mapView!)!)
                self?.myTableView?.reloadData()
                viewB.addSubview((self?.myTableView!)!)
            }
            
        case is CustomViewC:
            let viewC = v as! CustomViewC
            UIView.transition(with: self.view, duration: 0.25, options: [.transitionCrossDissolve], animations: {
                self.view.addSubview(viewC)
            }) { [weak self] _ in
                self?.updateViewLabel(viewC)
            }
            viewC.delegate = self
            
        default:
            print("showCustomview - else")
        }
    }
    
    // -------------
    
    fileprivate func updateViewLabel(_ v: AnyObject) {
        
        switch v {
        
        case is CustomViewA:
            let view = v as! CustomViewA
            view.pointALabel.text = viewModel.pointA ?? "point a"
            view.pointBLabel.text = viewModel.pointB ?? "point b"
            
        case is CustomViewC:
            let view = v as! CustomViewC
            view.pointALabel.text = viewModel.pointA ?? "값 전달 체크"
            view.pointBLabel.text = viewModel.pointB ?? "값 전달 체크"
            
        default:
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

        viewModel.getLocationInfo(lat: lat, long: long)
        viewModel.didFinishGetLocationInfo = { [weak self] in
            
            guard let info = self?.viewModel.tempInfo else { return  }
            self?.mapMarker.title = info.adress
            self?.mapMarker.snippet = "AQI: \(info.AQI!)"
        }
        
    }
}

// MARK: - TableView Delegate
extension ViewController: UITableViewDelegate {
    
}

extension ViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.locationInfos.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = myTableView?.dequeueReusableCell(withIdentifier: "myTableViewCell", for: indexPath) as! MyTableViewCell
        
        cell.content = viewModel.locationInfos[indexPath.row].getInfoString()
        cell.backgroundColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let locationInfo = viewModel.locationInfos[indexPath.row]
        
        let lat = locationInfo.getLatitude()
        let long = locationInfo.getLongitude()
        
        let cameraPosition = GMSCameraPosition.camera(withLatitude: lat, longitude: long, zoom: 16.0)
        mapView?.camera = cameraPosition
        mapMarker.position = cameraPosition.target
        mapView?.reloadInputViews()
    }
}
