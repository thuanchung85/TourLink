//
//  Home.swift
//  TourLink
//
//  Created by Luong Thuan Chung on 14/01/2022.
//

import SwiftUI
import CoreLocation

struct Home: View {
    
    @StateObject var mapData = MapViewModel()
    @State var locationManager = CLLocationManager()
    
    
    var body: some View{
        ZStack{
            //MapView...
            MapView(mapData: mapData)
                .environmentObject(mapData)
                .ignoresSafeArea(.all, edges: .all)
        }.onAppear {
            locationManager.delegate = mapData
            locationManager.requestWhenInUseAuthorization()
        }
        .alert(isPresented: $mapData.permissionDenied) {
            Alert(title: Text("App cần cấp phép truy cập location"),
                  message: Text("Vui lòng kích hoạt location trong setting của điện thoại"),
                  dismissButton: .default(Text("Open Settings"), action: {
                    UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!)
                  }))
        }
    }
}
