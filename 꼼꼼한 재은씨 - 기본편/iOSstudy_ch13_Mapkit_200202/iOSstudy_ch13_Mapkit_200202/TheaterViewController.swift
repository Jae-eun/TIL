//
//  TheaterViewController.swift
//  iOSstudy_ch9_network_20191223
//
//  Created by 이재은 on 02/02/2020.
//  Copyright © 2020 jaeeun. All rights reserved.
//

import UIKit
import MapKit

class TheaterViewController: UIViewController {

    @IBOutlet var map: MKMapView!

    // 전달되는 데이터를 받을 변수
    var param: NSDictionary!

    override func viewDidLoad() {
        self.navigationItem.title = self.param["상영관명"] as? String

        setMapView()
    }

    func setMapView() {
        // 위도와 경도를 추출하여 Double 값으로 캐스팅
        let lat = (param["위도"] as! NSString).doubleValue
        let lng = (param["경도"] as! NSString).doubleValue

        // 위도와 경도를 인수로 하는 2D 위치 정보 객체 정의
        let location = CLLocationCoordinate2D(latitude: lat, longitude: lng)

        // 지도에 표현될 거리: 값의 단위 m
        let regionRadius: CLLocationDistance = 100

        // 거리를 반영한 지역 정보를 조합한 지도 데이터를 생성
        let coordinateRegion = MKCoordinateRegion(center: location, latitudinalMeters: regionRadius, longitudinalMeters: regionRadius)

        // map 변수에 연결된 지도 객체에 데이터를 전달하여 화면에 표시
        self.map.setRegion(coordinateRegion, animated: true)

        // 위치를 표시해줄 객체를 생성하고, 앞에서 작성해준 위치값 객체를 할당
        let point = MKPointAnnotation()
        point.coordinate = location

        // 위치 표현값을 추가
        self.map.addAnnotation(point)
    }

}
