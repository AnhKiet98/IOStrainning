//
//  InfoViewController.swift
//  MVVM-Observables
//
//  Created by PHAN ANH KIET on 28/06/2023.
//

import UIKit
import MapKit
import CoreLocation

class InfoViewController : UIViewController, CLLocationManagerDelegate, UISearchBarDelegate, MKLocalSearchCompleterDelegate{
    
    @IBOutlet weak var searchCompleter: UISearchBar!
    @IBOutlet weak var mapView: MKMapView!
    // locationManagerを宣言する
    var locationManager: CLLocationManager!
    let geocoder = CLGeocoder()
    let completer = MKLocalSearchCompleter()
    var searchResults: [MKLocalSearchCompletion] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        // ロケーションマネージャーのセットアップ
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager!.requestWhenInUseAuthorization()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        let buttonSize: CGFloat = 48
        let buttonPadding: CGFloat = 20
        let buttonOriginX = mapView.frame.width - buttonSize - buttonPadding
        let buttonOriginY = mapView.frame.height - buttonSize - buttonPadding
        
        let locationButton = UIButton(type: .system)
        locationButton.frame = CGRect(x: buttonOriginX, y: buttonOriginY, width: buttonSize, height: buttonSize)
        locationButton.setImage(UIImage(systemName: "location.fill"), for: .normal)
        locationButton.tintColor = .systemBlue
        locationButton.backgroundColor = .white
        locationButton.layer.cornerRadius = 24
        locationButton.addTarget(self, action: #selector(centerMapOnUserLocation), for: .touchUpInside)
        mapView.addSubview(locationButton)
        searchCompleter.delegate = self
        completer.delegate = self
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        zoomToUserLocation()
    }
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        completer.queryFragment = searchText
    }
    
    func completerDidUpdateResults(_ completer: MKLocalSearchCompleter) {
        searchResults = completer.results
    }
    
    func completer(_ completer: MKLocalSearchCompleter, didFailWithError error: Error) {
        print("Search completer failed with error: \(error.localizedDescription)")
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder() // Ẩn bàn phím khi nhấn nút tìm
        
        if let selectedResult = searchResults.first {
            let searchRequest = MKLocalSearch.Request(completion: selectedResult)
            let search = MKLocalSearch(request: searchRequest)
            search.start { (response, error) in
                if let mapItem = response?.mapItems.first {
                    let placemark = mapItem.placemark
                    let region = MKCoordinateRegion(center: placemark.coordinate, latitudinalMeters: 1000, longitudinalMeters: 1000)
                    self.mapView.setRegion(region, animated: true)
                }
            }
        }
    }
    
    func regionForCoordinates(_ coordinates: CLLocationCoordinate2D) -> MKCoordinateRegion {
        let regionSpan = MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
        let region = MKCoordinateRegion(center: coordinates, span: regionSpan)
        return mapView.regionThatFits(region)
    }
    
    func zoomToUserLocation() {
        guard let userLocation = mapView.userLocation.location?.coordinate else { return }
        
        let span = MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
        let region = MKCoordinateRegion(center: userLocation, span: span)
        mapView.setRegion(region, animated: true)
    }
    @objc func centerMapOnUserLocation() {
        guard let userLocation = mapView.userLocation.location?.coordinate else {
            return
        }
        let region = MKCoordinateRegion(center: userLocation, latitudinalMeters: 1000, longitudinalMeters: 1000)
        mapView.setRegion(region, animated: true)
    }
    
    // 許可を求めるためのdelegateメソッド
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedWhenInUse || status == .authorizedAlways {
            locationManager.startUpdatingLocation()
            mapView.showsUserLocation = true
        } else {
            locationManager.stopUpdatingLocation()
            mapView.showsUserLocation = false
        }
        switch status {
            // 許可されてない場合
        case .notDetermined:
            // 許可を求める
            manager.requestWhenInUseAuthorization()
            // 拒否されてる場合
        case .restricted, .denied:
            // 何もしない
            break
            // 許可されている場合
        case .authorizedAlways, .authorizedWhenInUse:
            // 現在地の取得を開始
            manager.startUpdatingLocation()
            break
        default:
            break
        }
    }
}
