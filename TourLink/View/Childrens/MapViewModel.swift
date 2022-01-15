//
//  MapViewModel.swift
//  TourLink
//
//  Created by Luong Thuan Chung on 14/01/2022.
//

import SwiftUI
import MapKit
import CoreLocation
//all map data goes here

class MapViewModel: NSObject, ObservableObject, CLLocationManagerDelegate {
    
    @Published var mapView = MKMapView()
    @Published var region: MKCoordinateRegion!
    @Published var permissionDenied = false
    @Published var mapType = MKMapType.standard
    @Published var searchTxt = ""
    @Published var arrPlacesFound : [PlaceModel] = []
    
    //Search Dia Chi
    func searchQuery()
    {
        self.arrPlacesFound.removeAll()
        
        let request = MKLocalSearch.Request()
        request.naturalLanguageQuery = searchTxt
        
        MKLocalSearch(request: request).start { valueReturn, error in
            guard let valueRe = valueReturn else {return}
        
            self.arrPlacesFound = valueRe.mapItems.compactMap({ item -> PlaceModel? in
                return PlaceModel(place: item.placemark)
            })
        }
    }
    
    
    //thay doi dang map
    func updateMapType(){
        if mapType == .standard{
            mapType = .hybrid
            mapView.mapType = mapType
        }
        else{
            mapType = .standard
            mapView.mapType = mapType
        }
    }
    
    //zoom vao vi tri cua user
    func focusLocation() {
        guard let _ = region else {
            return
        }
        mapView.setRegion(region, animated: true)
        self.mapView.setVisibleMapRect(self.mapView.visibleMapRect, animated: true)
    }
    
    
    //xin phep cap quyen lay data location
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        //check permissions...
        switch manager.authorizationStatus {
        case .denied:
            //show alert
            permissionDenied.toggle()
        case .notDetermined:
            //get permission
            manager.requestWhenInUseAuthorization()
            
        case .authorizedWhenInUse:
            manager.requestLocation()
            
        default:
            ()
        }
    }
    
    //co loi khi lay location
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error.localizedDescription)
    }
    
    //khi user update vi tri
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else {
            return
        }
        
        self.region = MKCoordinateRegion(center: location.coordinate, latitudinalMeters: 1000, longitudinalMeters: 1000)
        self.mapView.setRegion(region, animated: true)
        self.mapView.setVisibleMapRect(self.mapView.visibleMapRect, animated: true)
    }
    
}
