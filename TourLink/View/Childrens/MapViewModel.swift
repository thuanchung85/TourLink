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
    
    var vitri1: CLLocationCoordinate2D?
    var vitri2:CLLocationCoordinate2D?
    
    //show duong di
    func showDirection()
    {
        print("chi duong")
        guard let p1 = vitri1 else {return}
        guard let p2 = vitri2  else {return}
        
        let mark1 = MKPlacemark(coordinate: p1)
        let mark2 = MKPlacemark(coordinate: p2)
        print(mark1)
        print(mark2)
    }
    
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
    
    //chon dia chi sau khi search text
    func selectPlace(place: PlaceModel)
    {
        self.searchTxt = ""
        
        guard let coordinate = place.place.location?.coordinate else {return}
        
        //save vitri 1
        self.vitri1 = coordinate
        
        let pointAnnotation = MKPointAnnotation()
        pointAnnotation.coordinate = coordinate
        pointAnnotation.title = place.place.name ?? "no name"
        
        mapView.removeAnnotations(mapView.annotations)
        mapView.addAnnotation(pointAnnotation)
        
        //moving map to location
        let coorinateRegion = MKCoordinateRegion(center: coordinate, latitudinalMeters: 1000, longitudinalMeters: 1000)
        mapView.setRegion(coorinateRegion, animated: true)
        self.mapView.setVisibleMapRect(self.mapView.visibleMapRect, animated: true)
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
        //save vitri 2
        self.vitri2 = location.coordinate
        
        self.region = MKCoordinateRegion(center: location.coordinate, latitudinalMeters: 1000, longitudinalMeters: 1000)
        self.mapView.setRegion(region, animated: true)
        self.mapView.setVisibleMapRect(self.mapView.visibleMapRect, animated: true)
    }
    
}
