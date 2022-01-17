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
    @Published var isStartHanhTrinh = false
    @Published var searchTxt = ""
    @Published var arrPlacesFound : [PlaceModel] = []
    
    var vitri1: CLLocationCoordinate2D?
    var vitri2:CLLocationCoordinate2D?
    
    //chua 1 locationManager
    @Published var locationManager = CLLocationManager()
   
    
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
        
        //request direction
        let requestDirection = MKDirections.Request()
        requestDirection.source = MKMapItem(placemark: mark1)
        requestDirection.destination = MKMapItem(placemark: mark2)
        requestDirection.transportType = .automobile
        
        self.mapView.removeOverlays(mapView.overlays)
        
        let directions = MKDirections(request: requestDirection)
        directions.calculate { [weak self] res, err in
            guard let route = res?.routes.first else {return}
            
            //self!.mapView.addAnnotations([mark1,mark2])
            self!.mapView.addOverlay(route.polyline)
            self!.mapView.setVisibleMapRect(route.polyline.boundingMapRect, edgePadding: UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20),animated: true)
        }
    }
    
    //func start stop hanh trinh
    func startHanhTrinh()
    {
        self.isStartHanhTrinh.toggle()
        if(isStartHanhTrinh == true){
            self.locationManager.startUpdatingLocation()
        }
        else{
            self.locationManager.stopUpdatingLocation()
        }
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
        self.mapView.setUserTrackingMode(MKUserTrackingMode.followWithHeading, animated: true)
        //mapView.setRegion(region, animated: true)
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
        //save vitri cua user
        self.vitri2 = location.coordinate
        
       
        
        self.region = MKCoordinateRegion(center: vitri2!, latitudinalMeters: 300, longitudinalMeters: 300)
        self.mapView.setUserTrackingMode(MKUserTrackingMode.followWithHeading, animated: true)
        //self.mapView.setRegion(region, animated: true)
        self.mapView.setVisibleMapRect(self.mapView.visibleMapRect, animated: true)
       
        
        
    }
    
    //ghi nhan huong quay cua user, dong tay nam bac
    var userHeading: CLLocationDirection?
    func locationManager(_ manager: CLLocationManager, didUpdateHeading newHeading: CLHeading)
    {
        //print(newHeading)
       // if newHeading.headingAccuracy < 0 { return }

        //let heading = newHeading.trueHeading > 0 ? newHeading.trueHeading : newHeading.magneticHeading
        //userHeading = heading
        //if let i = headingImageView {
          //  i.transform = CGAffineTransform(rotationAngle: CGFloat(heading/180 * Double.pi))
       // }
        
    }
    
    
    //gan hinh mui ten vao gan vi tri user
    var headingImageView: UIImageView?
    func addHeadingView(toAnnotationView annotationView: MKAnnotationView) {
        
       
        if let image = UIImage.init(named: "BlueArrowIcon")
        {
            
            headingImageView = UIImageView(image: image)
            
            headingImageView!.frame = CGRect(x: (annotationView.frame.size.width - image.size.width)/2,
                                             y: (annotationView.frame.size.height - image.size.height)/2,
                                             width: image.size.width,
                                             height: image.size.height )
            //headingImageView?.backgroundColor = .red
            
            annotationView.insertSubview(headingImageView!, at: 0)
            //headingImageView!.isHidden = true
        }
            
         
    }
    
    
    
    
}//end class
