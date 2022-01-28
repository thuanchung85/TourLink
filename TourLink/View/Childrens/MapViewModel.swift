//
//  MapViewModel.swift
//  TourLink
//
//  Created by Luong Thuan Chung on 14/01/2022.
//

import SwiftUI
import MapKit
import CoreLocation
import Foundation
import Firebase

//all map data goes here

class MapViewModel: NSObject, ObservableObject, CLLocationManagerDelegate {
    
    @Published var mapView = MKMapView()
    @Published var region: MKCoordinateRegion!
    @Published var permissionDenied = false
    @Published var mapType = MKMapType.standard
   
    @Published var searchTxt = ""
    
    //bien bat tat show so km va so gio
    @Published var soKmorHourToggle = false
    @Published var soKmorHour = ""
    @Published var soHour = ""
    @Published var soKm = ""
    
    @Published var arrPlacesFound : [PlaceModel] = []
    
    @Published var vitriNoiCanDen: CLLocationCoordinate2D?
    
    @Published var vitriCuaUserHienTai:CLLocationCoordinate2D?
    
    //array cac diem tren map cua cac member trong tuor
    @Published var arrCacVitriMember : [(toado: CLLocationCoordinate2D, tenMember: String)]?
    @Published var arrHinhVeCacVitriMember = [MKPointAnnotation]()
    
    //chua 1 locationManager
    @Published var locationManager = CLLocationManager()
    
    //firestore database
    let db = Firestore.firestore()
    
    //ham lay het data tu firebase
    func getAllMemberDataFromDatabase(isZoomin:Bool? = false)
    {
        DispatchQueue.main.async { [weak self] in
            self!.db
                .collection("My_Location")
                .getDocuments{ data, error in
                    guard error == nil else {
                        print(error as Any)
                        return}
                    
                    if(data != nil)
                    {
                        print("so luong member: ",data?.documents.count as Any)
                        
                        //lay data vitri cac member roi covert qua dang arrCacVitriMember
                        self!.arrCacVitriMember =  data?.documents.map({ doc in
                            let pointAnnotation = MKPointAnnotation()
                            pointAnnotation.coordinate = CLLocationCoordinate2D.init(latitude: doc["latitude"] as! CLLocationDegrees,
                                                                                     longitude: doc["longitude"] as! CLLocationDegrees)
                            pointAnnotation.title = String(doc.documentID)
                            
                            return ( toado: pointAnnotation.coordinate, tenMember: pointAnnotation.title ?? "no name")
                        })
                        //loai tru vitri chinh user
                        .filter({ item in
                            let iphoneHardWareUniqueID = UIDevice.current.identifierForVendor!.uuidString
                            let name = "vitriHienTai-\(iphoneHardWareUniqueID)"
                            
                            if item.tenMember == name{
                                return false
                            }
                            else
                            {
                                return true
                            }
                        })
                        
                        if(isZoomin == true){
                            //ve hinh ngoi sao vi tri cac member
                            if(self!.arrCacVitriMember?.isEmpty == false){
                                self!.makeStarForMemberLocation(arrVitri:   self!.arrCacVitriMember!)
                            }
                        }
                    }
                }
        }
    }
    
    //ham gan ngoi sao vao vi tri cua cac member
    func makeStarForMemberLocation(arrVitri:[(toado : CLLocationCoordinate2D , tenMember : String)])
    {
        if(self.arrHinhVeCacVitriMember.isEmpty == false){
            mapView.removeAnnotations(self.arrHinhVeCacVitriMember)
            self.arrHinhVeCacVitriMember.removeAll()
        }
        
        arrVitri.forEach { vitri in
            let pointAnnotation = MKPointAnnotation()
            
            pointAnnotation.coordinate = vitri.toado
            pointAnnotation.title = "MEMBER @_@" + vitri.tenMember
            self.arrHinhVeCacVitriMember.append(pointAnnotation)
            mapView.addAnnotation(pointAnnotation)
        }
        
        //neu co 2 member tro len zoom vao toa do cac member
        if(arrVitri.count >= 2)
        {
            // these are your two lat/long coordinates
            let coordinate1 = CLLocationCoordinate2DMake((arrVitri.first?.toado.latitude)!,(arrVitri.first?.toado.longitude)!);
            let coordinate2 = CLLocationCoordinate2DMake((arrVitri.last?.toado.latitude)!,(arrVitri.last?.toado.longitude)!);
            
            // convert them to MKMapPoint
            let p1 = MKMapPoint (coordinate1);
            let p2 = MKMapPoint (coordinate2);
            
            // and make a MKMapRect using mins and spans
            let mapRect = MKMapRect(x: fmin(p1.x,p2.x), y: fmin(p1.y,p2.y), width: fabs(p1.x-p2.x), height: fabs(p1.y-p2.y));
            
            
            self.mapView.setVisibleMapRect(mapRect, edgePadding: UIEdgeInsets(top: 50, left: 50, bottom: 50, right: 50),animated: true)
            
            
        }
        else if (arrVitri.count == 1)
        {
            self.mapView.setRegion(MKCoordinateRegion(center: arrVitri.first!.toado, span: region.span), animated: true)
            //self.mapView.setVisibleMapRect(self.mapView.visibleMapRect, animated: true)
        }
    }
    
    //ham add data vao database firestore chay duoi background theard
    func saveLocationData_ToFireStore(Location:CLLocationCoordinate2D)  {
        DispatchQueue.main.async { [weak self] in
            
            //vi tri cu
            let vitricu = self!.vitriCuaUserHienTai
            
            //save vi tri cua user de update vi tri lien tuc vao database
            //tinh khoan cach voi vitri cua cua user neu di chuyen qua 100m thi ghi vao database
            if(vitricu != nil)
            {
                let khoanCach = self!.locationManager.location!.distance(from: CLLocation(latitude: vitricu!.latitude, longitude: vitricu!.longitude))
                //print(khoanCach)
                if(khoanCach >= 50.0)
                {
                    if( self!.vitriCuaUserHienTai != nil)
                    {
                        let iphoneHardWareUniqueID = UIDevice.current.identifierForVendor!.uuidString
                        self!.db
                            .collection("My_Location")
                            .document("vitriHienTai-\(iphoneHardWareUniqueID)")
                            .setData(["longitude" : Location.longitude, "latitude": Location.latitude])
                        
                        self!.vitriCuaUserHienTai = self!.locationManager.location!.coordinate
                    }
                    
                    //--test lay data vitri cac member het tu database---//
                    //self!.getAllMemberDataFromDatabase()
                }
                        
            }
            
        }
       
    }
    
    //show duong di
    func showDirection()
    {
       
        //--test lay data vitri cac member het tu database---//
        //self.getAllMemberDataFromDatabase()
        
        print("chi duong")
        //tao cot moc vi tri can den
        guard let p1 = vitriNoiCanDen else {return}
        let mark1 = MKPlacemark(coordinate: p1)
        
        //tao cot moc vi tri user hien tai
        guard let p2 = locationManager.location  else {return}
        vitriCuaUserHienTai = p2.coordinate
        let mark2 = MKPlacemark(coordinate: p2.coordinate)
       
        //TEST thu save lai vitri hien tai cua user vao database
        saveLocationData_ToFireStore(Location: vitriCuaUserHienTai!)
        
        
        
        //request direction
        let requestDirection = MKDirections.Request()
        //vi tri hien tai
        requestDirection.source = MKMapItem(placemark: mark2)
        //vitri can den
        requestDirection.destination = MKMapItem(placemark: mark1)
        requestDirection.transportType = .automobile
        
        self.mapView.removeOverlays(mapView.overlays)
        
        let directions = MKDirections(request: requestDirection)
        directions.calculate { [weak self] res, err in
            guard let route = res?.routes.first else {return}
           
            //tinh khoan cach bao nhieu km
            let distanceKM = (route.distance / 1000)
            if(distanceKM >= 1)
            {
                self!.soKm = String(distanceKM) + " Km"
            }
            else{
                self!.soKm = String(distanceKM * 1000) + " meter"
            }
            
            //tinh thoi gian = quang duong / van toc (50km/h)
            let tinhsoGio = Int(distanceKM / 50)
            
            var tinhsoPhut = (distanceKM / 50) - Double(tinhsoGio)
            if tinhsoPhut < 1 && tinhsoPhut > 0
            {
                tinhsoPhut = tinhsoPhut * 60
            }
            self!.soHour = String(tinhsoGio)  + " h " + String(Int(round(tinhsoPhut))) + " m"
            self!.showSoKM()
            
            self!.mapView.addOverlay(route.polyline)
            self!.mapView.setVisibleMapRect(route.polyline.boundingMapRect, edgePadding: UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20),animated: true)
        }
    }
    
   //ham hien so km khi user tap len text so km
    func showSoKM(){
        self.soKmorHour = self.soKm
        soKmorHourToggle = true
    }
    //ham hien so gio can phai chay khi user tap len text so km
     func showSoHour(){
         self.soKmorHour = self.soHour
        soKmorHourToggle = false
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
        self.vitriNoiCanDen = coordinate
        
        
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
        self.vitriCuaUserHienTai = locationManager.location?.coordinate
        
        self.mapView.setUserTrackingMode(MKUserTrackingMode.followWithHeading, animated: true)
       
        
    }
    //zoom vao vi tri cua dich den
    func focusDestination() {
        guard let _ = region else {
            return
        }
        if (self.vitriNoiCanDen != nil){
        
            self.mapView.setRegion(MKCoordinateRegion(center: self.vitriNoiCanDen!, span: region.span), animated: true)
            self.mapView.setVisibleMapRect(self.mapView.visibleMapRect, animated: true)
        }
        
    }
    
    //xin phep cap quyen lay data location
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        //check permissions...
        switch manager.authorizationStatus {
        case .denied:
            //show alert
            permissionDenied = true
            
        case .notDetermined:
            //get permission
            manager.requestWhenInUseAuthorization()
            
        case .authorizedWhenInUse:
            manager.requestLocation()
        case .authorizedAlways:
            manager.requestLocation()
        default:
            ()
        }
    }
    
    //co loi khi lay location
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error.localizedDescription)
    }
    
    //khi user update vi tri CAI HAM NAY AUTO CHAY 1 LAN KHI KHOI TAO LOCATION MANAGER
    //VA AUTO CHAY KHI USER THAY DOI VI TRI
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else {
            return
        }
        
        //save vitri cua user
        self.vitriCuaUserHienTai = location.coordinate
        
        self.region = MKCoordinateRegion(center: vitriCuaUserHienTai!, latitudinalMeters: 300, longitudinalMeters: 300)
        self.mapView.setUserTrackingMode(MKUserTrackingMode.followWithHeading, animated: true)
       
        self.mapView.setVisibleMapRect(self.mapView.visibleMapRect, animated: true)
        
        
    }
    
    //ghi nhan huong quay cua user, dong tay nam bac
    var userHeading: CLLocationDirection?
    func locationManager(_ manager: CLLocationManager, didUpdateHeading newHeading: CLHeading)
    {
        //khi user quay dau thi save vitri vao database
        guard vitriCuaUserHienTai != nil else {
            return
        }
        saveLocationData_ToFireStore(Location: vitriCuaUserHienTai!)
        
        
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
            annotationView.insertSubview(headingImageView!, at: 0)
        }
            
         
    }
    
    
    
    
}//end class
