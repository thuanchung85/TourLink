//
//  Home.swift
//  TourLink
//
//  Created by Luong Thuan Chung on 14/01/2022.
//

import SwiftUI
import CoreLocation


struct Home: View {
   
   @State var isDisAble = false
    
    //chua 1 environment object de update data mapData
    @StateObject var mapData = MapViewModel()
    
    //bien co show va hide action sheet
    @State var showEnterGroupNameView = false
    
    
    var body: some View {
        if(isDisAble == false){
            
            
            ZStack{
                
                //đây là MapView la view con nam bên dưới zstack
                MapView(mapData: mapData)
                    .environmentObject(mapData)
                    .ignoresSafeArea(.all, edges: .all)
                
                //text hiện đang tracking khi mở app
                if(mapData.vitriCuaUserHienTai == nil){
                    Text("TRACKING YOUR LOCATION...")
                        .foregroundStyle(.white)
                        .font(.system(size: 15))
                        .scaledToFill()
                        .lineLimit(1)
                        .minimumScaleFactor(0.15)
                        .frame(width: 340, height: 50, alignment: .center)
                        .background(Color.black.opacity(0.8))
                        .cornerRadius(20)
                        .overlay(
                            RoundedRectangle(cornerRadius: 20)
                                .stroke(Color.blue, lineWidth: 1)
                            
                        )
                    
                        .padding(5)
                }
                
                //đây la khu cac nut bam va text search nam o tren zstack
                VStack(alignment: .leading, spacing: 0)
                {
                    //spacer de đẩy vùng HStack o tren va VStack o dưới ra xa nhau maximun
                    Spacer()
                    
                    //vùng cac nut ben duoi man hinh
                    HStack{
                        //chỉ hiện khi mà user get đươc grps vi trí hiện tại.
                        //nut show vi tri cac member thay doi dang map
                        if(mapData.vitriCuaUserHienTai != nil){
                            Button {
                                self.showEnterGroupNameView.toggle()
                                //mapData.getAllMemberDataFromDatabase(isZoomin: true)
                                self.endTextEditing()
                            } label: {
                                Image(systemName: "person.2")
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
                        Spacer()
                        
                        
                        //nut 1 zoom vao vitri user
                        Button {
                            mapData.focusLocation()
                            self.endTextEditing()
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
                            .onTapGesture {
                                self.mapData.arrRouteOptionsFound.removeAll()
                                showEnterGroupNameView = false
                            }
                            .foregroundColor(.blue)
                            .font(Font.system(size: 15, design: .default))
                            .padding()
                            .frame( height: 40)
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
                            .frame(width: 80, height: 40)
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
                            //mapData.showDirection()
                            mapData.showRoutesOptionsTable()
                            
                        } label: {
                            //Image(systemName: "scribble")
                            //.padding()
                            Text("Go").tint(Color.white).padding()
                        }
                        .frame(width: 60, height: 40, alignment: .center)
                        .background(Color.blue.opacity(0.8))
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
                        VStack{
                            //tao 1 scroll view
                            ScrollView{
                                VStack (spacing: 20){
                                    ForEach(Array(mapData.arrPlacesFound.enumerated()), id: \.offset) { (index,item) in
                                        HStack{
                                            if(index % 2 == 1 ){
                                                HStack{
                                                    Text(item.place.name ?? "").fontWeight(.bold) .foregroundColor(.blue)
                                                    
                                                    Text(  makeAddress(place: item.place) )
                                                        .fontWeight(.thin)
                                                        .foregroundColor(.blue)
                                                        .frame(maxWidth:.infinity, alignment: .leading)
                                                        .padding(EdgeInsets(top: 0, leading: 10, bottom: 0, trailing: 10))
                                                    
                                                   
                                                }
                                                .padding()
                                                .background(Color.white.opacity(0.9))
                                                .cornerRadius(20)
                                            }
                                            else{
                                                HStack{
                                                Text(item.place.name ?? "").fontWeight(.bold).foregroundColor(Color.black)
                                                
                                                Text(  makeAddress(place: item.place) )
                                                    .fontWeight(.thin)
                                                    .foregroundColor(Color.black)
                                                    .frame(maxWidth:.infinity, alignment: .leading)
                                                    .padding(EdgeInsets(top: 0, leading: 10, bottom: 0, trailing: 10))
                                                    
                                               
                                                }
                                                .padding()
                                                .background(Color.gray.opacity(0.9))
                                                .cornerRadius(20)
                                            }
                                        }
                                        .onTapGesture {
                                            mapData.selectPlace(place: item)
                                            self.endTextEditing()
                                            self.mapData.isShowTableRouteOption = false
                                        }
                                    }
                                   
                                }
                                .padding(EdgeInsets(top: 20, leading: 0, bottom: 0, trailing: 0))
                            }
                            //.background(Color.white.opacity(0.8))
                            //.cornerRadius(5)
                            .padding(.horizontal)
                            
                            //nut cancel
                            HStack{
                                Button {
                                    mapData.arrPlacesFound.removeAll()
                                    mapData.searchTxt = ""
                                    self.endTextEditing()
                                } label: {
                                    Text("Back")
                                        .foregroundColor(.red)
                                        .padding(3)
                                }
                                .padding(10)
                                .background(.white.opacity(0.8))
                                .cornerRadius(5)
                            }
                        }
                        
                        
                    }
                    
                    
                    //hien table neu bam nut chi duong ma co nhieu option routes tra ra
                    if(mapData.isShowTableRouteOption == true)
                    {
                        VStack{
                            //tao 1 scroll view
                            ScrollView{
                                
                                
                                VStack (spacing: 20){
                                    ForEach(mapData.arrRouteOptionsFound, id: \.id) { item in
                                        HStack{
                                            //show ten duong di
                                            Text(item.route.name )
                                                .fontWeight(.bold)
                                                .frame(maxWidth:.infinity, alignment: .leading)
                                                .foregroundColor(.blue)
                                                .padding(EdgeInsets(top: 0, leading: 10, bottom: 0, trailing: 10))
                                            
                                            
                                            //show so km va so gio
                                            VStack{
                                                //show so gio
                                                Text(tinhSoGio(distanceKM: item.route.distance))//("\(Int(round(item.route.distance / 1000))) Km")
                                                    .foregroundColor(.white)
                                                    .font(Font.system(size: 16, design: .default))
                                                    .padding(EdgeInsets(top: 5, leading: 10, bottom: 0, trailing: 10))
                                                
                                                //show so km
                                                Text(tinhKhoanCach(route: item.route))//("\(Int(round(item.route.distance / 1000))) Km")
                                                    .fontWeight(.bold)
                                                    .foregroundColor(.white)
                                                    .font(Font.system(size: 16, design: .default))
                                                    .padding(EdgeInsets(top: 3, leading: 10, bottom: 5, trailing: 10))
                                                
                                            }
                                            .background(Color.blue)
                                            .cornerRadius(10)
                                            .padding(EdgeInsets(top: 0, leading: 10, bottom: 0, trailing: 10))
                                            
                                        }
                                        .onTapGesture {
                                            //khi tap vao row thi bat dau ve duong di
                                            mapData.drawRoute(route: item.route)
                                            mapData.isShowTableRouteOption = false
                                        }
                                    }
                                    Divider()
                                }
                                .padding(EdgeInsets(top: 20, leading: 0, bottom: 0, trailing: 0))
                            }
                            .background(Color.white.opacity(0.8))
                            .cornerRadius(5)
                            .padding(.horizontal)
                            
                            HStack(alignment: .center){
                                
                                Button {
                                    mapData.isShowTableRouteOption = false
                                    self.endTextEditing()
                                } label: {
                                    Text("Back")
                                        .foregroundColor(.red)
                                        .padding(3)
                                }
                                .padding(10)
                                .background(.white.opacity(0.8))
                                .cornerRadius(5)
                            }
                        }
                    }
                    
                    
                }
                
                //ACTION SHEET hien ra khi bam nut group view
                VStack{
                    if(self.showEnterGroupNameView == true)
                    {
                        ShowGroupMemberView(mapData: self.mapData,
                                            showEnterGroupNameView: $showEnterGroupNameView,
                                            cardListViewModel: CardListViewModel())
                        .padding(.horizontal)
                       
                    }
                }
                
            }
            .onAppear {
                //lay thong tin member co bao nhieu nguoi
                //mapData.getAllMemberDataFromDatabase()
                
                //khi init home view xong thi khoi tao location manager
                mapData.locationManager.delegate = mapData
                mapData.locationManager.desiredAccuracy = kCLLocationAccuracyBest
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
        
        else{
            //đây là MapView la view con nam bên dưới zstack
            MapView(mapData: mapData)
                .environmentObject(mapData)
                .ignoresSafeArea(.all, edges: .all)
            
        }
    }
}

//==============MAKE ADDRESS TEXT========//

func makeAddress(place: CLPlacemark) ->String
{
    let placeName      = place.name ?? ""
    let streetName     = place.thoroughfare ?? ""
    let streetNumber   = place.subThoroughfare ?? ""
    let city           = place.locality ?? ""
    let state          = place.administrativeArea ?? ""
    let zipCode        = place.postalCode ?? ""
    let country        = place.country ?? ""
    let isoCountryCode = place.isoCountryCode ?? ""
    
    print(placeName)
    print(streetName)
    print(streetNumber)
    print(city)
    print(state)
    print(zipCode)
    print(country)
    print(isoCountryCode)
    
  
     return //String(localized: "place name: ") + placeName + "\n" +
    String(localized:"street name: ") + streetName + "\n" +
    String(localized:"street number: ") + streetNumber + "\n" +
    String(localized:"city: ") + city + "\n" +
    String(localized:"state: ") + state
}
