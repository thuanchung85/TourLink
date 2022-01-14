//
//  Home.swift
//  TourLink
//
//  Created by Luong Thuan Chung on 14/01/2022.
//

import SwiftUI
import CoreLocation

struct Home: View {
    
    //chua 1 environment object de update data mapData
    @StateObject var mapData = MapViewModel()
    
    //chua 1 locationManager
    @State var locationManager = CLLocationManager()
    
    
    var body: some View {
        ZStack{
            //MapView...
            MapView(mapData: mapData)
                .environmentObject(mapData)
                .ignoresSafeArea(.all, edges: .all)
            
            
            VStack{
                Spacer()
                VStack{
                    
                    //nut 1 zoom vao vitri user
                    Button {
                        mapData.focusLocation()
                        
                    } label: {
                        Image(systemName: "location.fill")
                            .font(.title2)
                            .padding(10)
                            .background(Color.primary)
                            .clipShape(Circle())
                    }
                    
                    //nut 2 thay doi dang map
                    Button {
                        mapData.updateMapType()
                        
                    } label: {
                        Image(systemName: mapData.mapType == .standard ? "network" : "map")
                            .font(.title2)
                            .padding(10)
                            .background(Color.primary)
                            .clipShape(Circle())
                    }

                }.frame(maxWidth: .infinity,  alignment: .trailing)
                .padding()
            }
        }.onAppear {
            //khi init home view xong thi khoi tao location manager
            locationManager.delegate = mapData
            locationManager.requestWhenInUseAuthorization()
        }
        //neu chua co cap phep thi alert xin phep truy cap location cua user
        .alert(isPresented: $mapData.permissionDenied) {
            Alert(title: Text("App cần cấp phép truy cập location"),
                  message: Text("Vui lòng kích hoạt location trong setting của điện thoại"),
                  dismissButton: .default(Text("Open Settings"), action: {
                    UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!)
                  }))
        }
    }
}
