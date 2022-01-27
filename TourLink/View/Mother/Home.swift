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
    
   
    
    var body: some View {
        ZStack{
            
            //đây là MapView la view con nam bên dưới zstack
            MapView(mapData: mapData)
                .environmentObject(mapData)
                .ignoresSafeArea(.all, edges: .all)
            
            
            //đây la khu cac nut bam va text search nam o tren zstack
            VStack(alignment: .leading, spacing: 0)
            {
                //spacer de đẩy vùng HStack o tren va VStack o dưới ra xa nhau maximun
                Spacer()
                
                //vùng cac nut ben duoi mang hinh
                HStack{
                    //nut show vi tri cac member thay doi dang map
                    Button {
                        mapData.getAllMemberDataFromDatabase()
                        
                    } label: {
                        Image(systemName: mapData.mapType == .standard ? "person.2" : "map")
                            .font(.title2)
                            .padding(10)
                            .background(Color.primary.opacity(0.8))
                            .clipShape(Circle())
                    }
                    
                    Spacer()
                    
                    //nut 1 zoom vao vitri user
                    Button {
                        mapData.focusLocation()
                        
                    } label: {
                        Image(systemName: "figure.walk")
                            .font(.title2)
                            .padding(10)
                            .background(Color.primary.opacity(0.8))
                            .clipShape(Circle())
                    }
                    
                    //nut 1 zoom vao vitri dich den
                    Button {
                        mapData.focusDestination()
                        
                    } label: {
                        Image(systemName: "mappin")
                            .font(.title2)
                            .padding(10)
                            .background(Color.primary.opacity(0.8))
                            .clipShape(Circle())
                    }
                    
                    //nut 2 thay doi dang map
                    Button {
                        mapData.updateMapType()
                        
                    } label: {
                        Image(systemName: mapData.mapType == .standard ? "network" : "map")
                            .font(.title2)
                            .padding(10)
                            .background(Color.primary.opacity(0.8))
                            .clipShape(Circle())
                    }
                    
                    
                   
                   

                }.frame(maxWidth: .infinity,  alignment: .trailing)
                .padding(.horizontal)
                
                //thanh text search dia chi nam ngang
                HStack (){
                    //khu nhap dia chi
                    TextField("Search", text: $mapData.searchTxt)
                        //.background(Color.white.opacity(0.9))
                        .foregroundColor(.blue)
                        .font(Font.system(size: 15, design: .default))
                        .padding()
                        .frame( height: 30)
                        .overlay(
                                RoundedRectangle(cornerRadius: 10)
                                    .stroke(Color.blue, lineWidth: 1)
                                    
                        ).background(Color.white.opacity(0.9))
                        .cornerRadius(10)
                    
                    //so km
                    TextField("Km", text: $mapData.soKmorHour )
                        .multilineTextAlignment(.center)
                        //.background(Color.white.opacity(0.8))
                        .foregroundColor(.blue)
                        .font(Font.system(size: 15, design: .default))
                        .padding(.horizontal,5)
                        .minimumScaleFactor(0.01)
                        .frame(width: 80, height: 30)
                        .overlay(
                                RoundedRectangle(cornerRadius: 10)
                                    .stroke(Color.blue, lineWidth: 1)
                                    
                        ).background(Color.white.opacity(0.8))
                        .cornerRadius(10)
                        .disabled(true)
                        .onTapGesture {
                            if (mapData.soKmorHourToggle == true){
                                mapData.showSoHour()
                            }
                            else
                            {
                                mapData.showSoKM()
                            }
                            print(mapData.soHour)
                            print(mapData.soKm)
                        }
                    
                    //nut chi duong
                    Button {
                        mapData.showDirection()
                        
                    } label: {
                        Image(systemName: "scribble")
                            .padding()
                    }
                    .frame(width: 40, height: 40, alignment: .center)
                    .background(Color.primary.opacity(0.8))
                    .cornerRadius(20)
                    .overlay(
                            RoundedRectangle(cornerRadius: 20)
                                .stroke(Color.blue, lineWidth: 1)
                                
                    )
                    .padding(.horizontal,5)
                    
                   
                }
                .padding(.vertical,5)
                .padding(.horizontal)
                
               
               
                
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
                
                
               
                
                
            }
        }.onAppear {
            //khi init home view xong thi khoi tao location manager
            mapData.locationManager.delegate = mapData
            mapData.locationManager.requestWhenInUseAuthorization()
            mapData.locationManager.startUpdatingHeading()
            
            //lam cho iphone chay hoai khong duoc off mang hinh
            UIApplication.shared.isIdleTimerDisabled = true
            
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
            let delayTime = 0.5
            DispatchQueue.main.asyncAfter(deadline: .now() + delayTime) {
                if(valueTextInputOnSearchText == mapData.searchTxt)
                {
                    mapData.searchQuery()
                }
            }
        }
        
        .onReceive(NotificationCenter.default.publisher(for: UIApplication.didEnterBackgroundNotification), perform: { output in
            //khi user turn off app thi save lai vi tri cuoi cung cua user
            guard (mapData.vitriCuaUserHienTai != nil) else {return}
            mapData.saveLocationData_ToFireStore(Location: mapData.vitriCuaUserHienTai!)
        })
    }
}
