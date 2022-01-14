//
//  myModel.swift
//  TourLink
//
//  Created by Luong Thuan Chung on 13/01/2022.
//

import Foundation
import MapKit

enum MapDetails {
    static let startingLocation = CLLocationCoordinate2D(latitude: 1.833404020168635, longitude: 1.78408553084277)
    static let defaultSpan = MKCoordinateSpan(latitudeDelta: 0.009, longitudeDelta: 0.009)
}

class myModel_QuanLyUserLocation:NSObject, ObservableObject, CLLocationManagerDelegate {
    
    var locationManager: CLLocationManager?
    
    //vi tri hien tai 10.833404020168635, 106.78408553084277 la nha minh
    @Published var region = MKCoordinateRegion(center: MapDetails.startingLocation, span: MapDetails.defaultSpan)
    
    //data ban ra text field
    @Published var thongtinTrenTextField: String = ""
    
    //===ham kiem tra em co dich vu location tren iphone hay khong?===///
    func kiemTraIphoneCoDichVuLocation()
    {
        //neu co dich vu locaion chay tren iPhone
        if (CLLocationManager.locationServicesEnabled())
        {
            //khoi tao location manager, khi khởi tao CLLocation Manager thi no lap tuc goi ham locationManagerDidChangeAuthorization
            locationManager = CLLocationManager()
            locationManager!.delegate = self
            locationManager!.desiredAccuracy = kCLLocationAccuracyBest
           
        }
        //neu khong co dich vu location chay tren iPhone
        else
        {
            print("iphone hok co dich vu location")
        }
    }
    
    //==ham kiem tra co duoc phep truy cap location cua nguoi dung hay khong?==///
    private func kiemtraIphoneCoChoPhepTruyCapUserLocation()
    {
        guard self.locationManager != nil else {
            return
        }
        
        switch locationManager!.authorizationStatus
        {
            case .notDetermined:
                print("dich vu location chua xac dinh: \(locationManager!.authorizationStatus)")
                locationManager?.requestWhenInUseAuthorization()
                
            case.restricted:
                print("dich vu location bi han che: \(locationManager!.authorizationStatus)")
                
            case .denied:
                print("dich vu location bi cam: \(locationManager!.authorizationStatus)")
                
            case .authorizedAlways ,.authorizedWhenInUse:
                print("dich vu location duoc cap phep: \(locationManager!.authorizationStatus)")
                //trong truong hop duoc phep truy cap user location thi lay user location lam trung tam va show tren map
                //locationManager!.location!.coordinate chua thong tin vi tri toa do cua user
                if let vitriUser = locationManager?.location?.coordinate {
                    print("da co vi tri user: \(vitriUser)")
                    
                    thongtinTrenTextField = String(vitriUser.longitude) + " || " + String(vitriUser.latitude)
                    
                    region = MKCoordinateRegion(center: vitriUser, span:  MapDetails.defaultSpan)
                }
                else{
                    print("co loi: khong lay duoc toa do cua user")
                }
                
                
            
                
            @unknown default:
                print("dich vu location manager khong co authorizationStatus: \(locationManager!.authorizationStatus)")
                break
        }
        
    }
    
    //==neu user tat hay update chuc nang location tren iphone thi ta phai hỏi yeu cau cap phep lai lan nua===///
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        kiemtraIphoneCoChoPhepTruyCapUserLocation()
        
    }
}//end class
