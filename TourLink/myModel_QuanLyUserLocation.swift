//
//  myModel.swift
//  TourLink
//
//  Created by Luong Thuan Chung on 13/01/2022.
//

import Foundation
import MapKit

class myModel_QuanLyUserLocation:NSObject, ObservableObject, CLLocationManagerDelegate {
    
    var locationManager: CLLocationManager?
    
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
                
            case .authorizedAlways:
                print("dich vu location duoc cap phep vinh vien: \(locationManager!.authorizationStatus)")
                break
                
            case.authorizedWhenInUse:
                print("dich vu location duoc cap phep tam thoi: \(locationManager!.authorizationStatus)")
                break
                
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
