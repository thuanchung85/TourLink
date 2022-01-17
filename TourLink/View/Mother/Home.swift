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
    //@State var locationManager = CLLocationManager()
    
    
    var body: some View {
        ZStack{
            
            //đây là MapView la view con nam bên dưới zstack
            MapView(mapData: mapData)
                .environmentObject(mapData)
                .ignoresSafeArea(.all, edges: .all)
            
            
            //đây la khu cac nut bam va text search nam o tren zstack
            VStack(alignment: .leading, spacing: 0){
                //thanh text search dia chi nam ngang
                HStack (){
                    //khu nhap dia chi
                    TextField("Search", text: $mapData.searchTxt)
                        .foregroundColor(.blue)
                        .font(Font.system(size: 12, design: .default))
                        .padding(EdgeInsets(top: 0, leading: 6, bottom: 0, trailing: 6))
                        .frame(width: 270, height: 30)
                        .overlay(
                                RoundedRectangle(cornerRadius: 10)
                                    .stroke(Color.blue, lineWidth: 1)
                            )
                    //nut chi duong
                    Image(systemName: "scribble")
                        .foregroundColor(.blue)
                        .frame(width: 20, height: 20)
                        .onTapGesture {
                            
                            mapData.showDirection()
                        }
                    
                   
                }
                .padding(.vertical,5)
                .padding(.horizontal)
                .background(Color.white.opacity(0.8))
                .cornerRadius(15)
                
                Spacer()
                
                //hien ket qua tim dia chi, neu co data trong arrPlacesFound
                if (!mapData.arrPlacesFound.isEmpty && mapData.searchTxt != "") {
                    //tao 1 scroll view
                    ScrollView{
                        VStack (spacing: 20){
                            ForEach(mapData.arrPlacesFound, id: \.id) { item in
                                Text(item.place.name ?? "none")
                                    .foregroundColor(.black)
                                    .frame(maxWidth:.infinity, alignment: .leading)
                                    .foregroundColor(.blue)
                                    .font(Font.system(size: 12, design: .default))
                                    .padding(EdgeInsets(top: 0, leading: 10, bottom: 0, trailing: 10))
                                    .onTapGesture {
                                        mapData.selectPlace(place: item)
                                        self.endTextEditing()
                                    }
                                }
                            Divider()
                        }
                        .padding(EdgeInsets(top: 20, leading: 0, bottom: 0, trailing: 0))
                    }
                    .background(Color.white.opacity(0.8))
                    .cornerRadius(5)
                    .padding(.horizontal)
                    
                }
                
                
                //spacer de đẩy vùng HStack o tren va VStack o dưới ra xa nhau maximun
                Spacer()
                
                //vùng cac nut ben duoi mang hinh
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
            mapData.locationManager.delegate = mapData
            mapData.locationManager.requestWhenInUseAuthorization()
            //locationManager.startUpdatingLocation()
            mapData.locationManager.startUpdatingHeading()
        }
        //neu chua co cap phep thi alert xin phep truy cap location cua user
        .alert(isPresented: $mapData.permissionDenied) {
            Alert(title: Text("App cần cấp phép truy cập location"),
                  message: Text("Vui lòng kích hoạt location trong setting của điện thoại"),
                  dismissButton: .default(Text("Open Settings"), action: {
                    UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!)
                  }))
        }
        .onChange(of: mapData.searchTxt) { valueTextInputOnSearchText in
            //chay tim kiem dia chi, phai delay 1s de no khong bi nghet mang
            let delayTime = 1.0
            DispatchQueue.main.asyncAfter(deadline: .now() + delayTime) {
                if(valueTextInputOnSearchText == mapData.searchTxt)
                {
                    mapData.searchQuery()
                }
            }
        }
    }
}
