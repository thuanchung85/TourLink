//
//  CustomActionSheet.swift
//  TourLink
//
//  Created by Luong Thuan Chung on 31/01/2022.
//
import FirebaseFirestore
import FirebaseFirestoreSwift
import Foundation
import SwiftUI

struct ShowGroupMemberView : View {
    @StateObject var mapData : MapViewModel
    @Binding var showEnterGroupNameView:Bool
     var cardListViewModel: CardListViewModel
    
    @State var arrUserSamePass = [Card]()
    @State var showListView = false;
    @State var showUserInfoEditView = false;
    @FocusState private var nameIsFocused: Bool
    
    @State private var showingAlert = false
    @State private var showingAlertInVaildSMSNumber = false
    @State var isDeleteAllDocumentFireStoreOK = ""
    
    //=======BODY======//
    var body: some View{
        //show form nhập tên nhóm
        if(showUserInfoEditView == false) && (showListView == false){
            HStack {
                
                
                Text(mapData.userName + "  " + mapData.userPhoneNumber) .foregroundStyle(.white)
                    .font(Font.system(size: 15, design: .default))
                    .frame(maxWidth: .infinity, maxHeight: 20)
                    .lineLimit(1)
                    .padding()
                    .background(Color.primary.opacity(0.7))
                    .cornerRadius(20)
                    .overlay(
                        RoundedRectangle(cornerRadius: 20)
                            .stroke(Color.blue, lineWidth: 1)
                        
                    )
                    .minimumScaleFactor(0.3)
                    .onAppear{
                        print(mapData.userName + ":" + mapData.userPhoneNumber)
                    }
                
                if(showListView == false){
                    Image(systemName: "square.and.pencil")
                        .foregroundColor(.white)
                        .frame(maxWidth: 50, maxHeight: 50)
                        .background(Color.primary.opacity(0.7))
                        .cornerRadius(20)
                        .overlay(
                            RoundedRectangle(cornerRadius: 20)
                                .stroke(Color.blue, lineWidth: 1)
                            
                        )
                        .onTapGesture {
                            print("SHOW USER INFO EDIT")
                            showUserInfoEditView.toggle()
                            
                        }
                }
                
                
                
            }
            //form
            VStack(alignment: .center, spacing: 15, content: {
                
                
                
                
                HStack{
                    Text("Enter your group name connect to members")
                    Spacer()
                }
                //form
                HStack
                {
                    VStack{
                        //nhập tên nhóm
                        HStack{
                            Text( String(localized: "Group")  + ": ")
                                .font(Font.system(size: 15, design: .default))
                            TextField(String(localized: "Name of your group"), text: $mapData.groupName)
                                .foregroundColor(.blue)
                                .font(Font.system(size: 15, design: .default))
                                .padding()
                                .frame( height: 40)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 10)
                                        .stroke(Color.blue, lineWidth: 1)
                                    
                                ).background(Color.white.opacity(0.9))
                                .cornerRadius(10)
                                .focused($nameIsFocused)
                            
                        }
                        
                        //nhập status của mình hiện tại
                        HStack {
                            VStack(alignment: .leading, content: {
                                Text( String(localized: "Status")  + ": ")
                                    .font(Font.system(size: 15, design: .default))
                                TextEditor( text: $mapData.statusString)
                                    .foregroundColor(.blue)
                                    .font(Font.system(size: 15, design: .default))
                                    .frame( height: 240)
                                    .border(Color.blue, width: 1)
                                    .cornerRadius(15)
                                    .lineSpacing(10)
                                    .autocapitalization(.words)
                                    .disableAutocorrection(true)
                                    .focused($nameIsFocused)
                            })
                               
                        }
                        
                        
                        
                        //nút huỷ, va ok
                        HStack{
                            //nut huỷ
                            Button {
                                removeWatchDocumentDataChange(cardListViewModel: cardListViewModel, pass: mapData.groupName)
                                showEnterGroupNameView.toggle()
                            } label: {
                                Text(String(localized:"Cancel")).tint(Color.white)
                            }
                            .frame(width: 80, height: 40, alignment: .center)
                            .background(Color.primary.opacity(0.8))
                            .cornerRadius(20)
                            
                           Spacer()
                            
                            //nut xoá hết data vị trí
                            Button {
                                isDeleteAllDocumentFireStoreOK =  deleteAllLocationOfuserFireStore(cardListViewModel: cardListViewModel)
                            } label: {
                                Text(String(localized:"Delete your data")).tint(Color.white)
                            }
                            .frame(width: 180, height: 40, alignment: .center)
                            .background(Color.primary.opacity(0.8))
                            .cornerRadius(20)
                            
                            Spacer()
                            
                            //nut OK
                            if(!mapData.groupName.isEmpty){
                                //nut OK
                                Button {
                                    
                                    
                                    //mapData.getAllMemberDataFromDatabase(isZoomin: true)
                                    //showEnterGroupNameView = false
                                    showListView = true
                                    nameIsFocused = false
                                    
                                    //lấy thông tin toạ độ user khi mở view này lên
                                    saveLocationOfUserToFireStore(
                                        name: mapData.userName, status: mapData.statusString,
                                        phone: mapData.userPhoneNumber,
                                        pass: mapData.groupName,
                                        mapData: mapData,
                                        cardListViewModel: cardListViewModel)
                                    
                                    //thu lay ra lai data
                                    getListOfUserSamePass(pass: mapData.groupName, cardListViewModel: cardListViewModel, completionHandler: {datas in
                                        
                                        //lấy ra vị trí cuối cùng của user trên map
                                        arrUserSamePass = getLastLocation(datas: datas)
                                        
                                    })
                                    
                                    //watch sự update của data của các document trong colecttion database
                                    removeWatchDocumentDataChange(cardListViewModel: cardListViewModel, pass: mapData.groupName)
                                    watchDocumentDataChange(cardListViewModel: cardListViewModel, pass: mapData.groupName)
                                    
                                } label: {
                                    
                                    Text(String(localized:"Ok")).tint(Color.white)
                                    
                                }
                                .frame(width: 60, height: 40, alignment: .center)
                                .background(Color.primary.opacity(0.8))
                                .cornerRadius(20)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 20)
                                        .stroke(Color.blue, lineWidth: 1)
                                    
                                )
                                .padding(.horizontal,5)
                            }
                        }
                    }
                    
                    
                }
                
                
            })
            .padding()
            .background(Color.blue.opacity(0.8))
            .cornerRadius(25)
            .onChange(of: mapData.groupName) { value in
                
            }
            .alert("Your location data have been delete!", isPresented: $showingAlert) {
                        Button("OK", role: .cancel) { }
                    }
            .onChange(of: isDeleteAllDocumentFireStoreOK) { value in
                if (value == "ok delete success"){
                    showingAlert.toggle()
                }
            }
            .onAppear(){
                removeWatchDocumentDataChange(cardListViewModel: cardListViewModel, pass: mapData.groupName)
            }
        }
       
       
        
        //show list of user theo arrUserSamePass lấy data từ firebase về
        if(showListView){
            VStack{
                List{
                    ForEach(arrUserSamePass, id: \.timeStamp) { card in
                        HStack{
                            VStack{
                                HStack{
                                    //user name
                                    Text(card.name)
                                        .foregroundStyle(.white)
                                        .font(.system(size: 25))
                                        .fontWeight(.bold)
                                        .frame(width: 340, height: 40, alignment: .center)
                                        .cornerRadius(25)
                                        .lineLimit(1)
                                        .minimumScaleFactor(0.3)
                                        .padding(.leading, 10)
                                }
                                //phone , time
                                HStack{
                                    //userPhone
                                    Text(card.userPhone)
                                        .foregroundStyle(.white)
                                        .font(.system(size: 15))
                                        .lineLimit(1)
                                        .minimumScaleFactor(0.1)
                                        .fontWeight(.bold)
                                        .frame(width: 160, height: 40, alignment: .center)
                                        .background(Color.blue.opacity(0.8))
                                        .cornerRadius(25)
                                    
                                        .padding(.leading, 10)
                                        .onTapGesture {
                                            print("MAKE A CALL: " , card.userPhone)
                                            makeACallPhone(numberString: card.userPhone)
                                        }
                                    
                                    //time
                                    Text(convertTimeStamp(timeResult: card.timeStamp))
                                        .foregroundStyle(.white)
                                        .font(.system(size: 10))
                                        .frame(width: 180, height: 30, alignment: .center)
                                        .background(Color.gray.opacity(0.2))
                                        .cornerRadius(25)
                                        .lineLimit(1)
                                        .minimumScaleFactor(0.1)
                                        .padding(.trailing, 10)
                                    
                                    
                                    
                                }
                                .padding(.horizontal, 10)
                                //vi tri
                                HStack{
                                    VStack{
                                        //nut send SMS to user
                                        Text(String(localized:"send SMS"))
                                            .foregroundStyle(.white)
                                            .font(.system(size: 15))
                                            .lineLimit(1)
                                            .minimumScaleFactor(0.1)
                                            .fontWeight(.bold)
                                            .frame(width: 120, height: 40, alignment: .center)
                                            .background(Color.blue.opacity(0.8))
                                            .cornerRadius(25)
                                        
                                            .padding(.leading, 10)
                                            .onTapGesture {
                                                print("SMS")
                                                let mPhoneNumber = card.userPhone;
                                                let mMessage = "";
                                                if let url = URL(string: "sms://" + mPhoneNumber + "&body="+mMessage) {
                                                    UIApplication.shared.open(url)
                                                }
                                                else{
                                                    showingAlertInVaildSMSNumber = true
                                                    print("phone number SMS invalid")
                                                }
                                                
                                            }
                                       
                                        
                                        Text(String(card.longitude))
                                            .foregroundStyle(.white)
                                            .font(.system(size: 10))
                                            .fontWeight(.bold)
                                            .frame(width: 140, height: 20, alignment: .center)
                                            .background(Color.green.opacity(0.2))
                                            .cornerRadius(25)
                                            .lineLimit(1)
                                            .minimumScaleFactor(0.3)
                                            .padding(.leading, 10)
                                        Text(String(card.latitude))
                                            .foregroundStyle(.white)
                                            .font(.system(size: 10))
                                            .fontWeight(.bold)
                                            .frame(width: 140, height: 20, alignment: .center)
                                            .background(Color.green.opacity(0.2))
                                            .cornerRadius(25)
                                            .lineLimit(1)
                                            .minimumScaleFactor(0.3)
                                            .padding(.leading, 10)
                                    }
                                    Spacer()
                                    
                                    //"GO TO USER LOCATION"
                                    Text(String(localized:"Location"))
                                        .foregroundStyle(.white)
                                        .font(.system(size: 15))
                                        .lineLimit(1)
                                        .minimumScaleFactor(0.1)
                                        .fontWeight(.bold)
                                        .frame(width: 120, height: 40, alignment: .center)
                                        .background(Color.green.opacity(0.8))
                                        .cornerRadius(25)
                                    
                                        .padding(.trailing, 10)
                                        .onTapGesture {
                                            print("GO TO USER LOCATION")
                                            //save name of this chosen member
                                            UserDefaults.standard.set(card.name, forKey: "nameOfWatchingUser")
                                            
                                            //show location of chosen user on map
                                            mapData.focusDestinationOfFriend(latitude: card.latitude,
                                                                              longitude: card.longitude,
                                                                              name: card.name ,status: card.status)
                                            //shut off this view
                                            showEnterGroupNameView = false
                                        }
                                   
                                }
                                .padding(.horizontal, 10)
                                
                                //user ghi chú status
                                HStack{
                                    Text(card.status)
                                        .foregroundStyle(.yellow)
                                        .frame(maxWidth: .infinity)
                                        .background(Color.primary.opacity(0.1))
                                        .padding()
                                }
                                .padding(.horizontal, 5)
                            }
                            
                        }
                        .listRowSeparatorTint(.blue)
                        .padding(.vertical,10)
                        
                        
                        
                    }
                    
                    .listRowBackground(Color.clear)
                    
                }
                .scrollContentBackground(.hidden)
                .background(Color.primary.opacity(0.8))
                .cornerRadius(15)
                
                //nut huỷ
                Button {
                    removeWatchDocumentDataChange(cardListViewModel: cardListViewModel, pass: mapData.groupName)
                    showEnterGroupNameView.toggle()
                } label: {
                    Text(String(localized:"Cancel")).tint(Color.white)
                }
                .frame(width: 80, height: 40, alignment: .center)
                .background(Color.primary.opacity(0.8))
                .cornerRadius(20)
            }
            .padding(.bottom,60)
            .alert("Phone number wrong so SMS disable!", isPresented: $showingAlertInVaildSMSNumber) {
                        Button("OK", role: .cancel) { }
                    }
        }
        
        //khi bấm nut edit user name và phone thì show ShowUserInfoEditView, cho user enter name và phone
        if(showUserInfoEditView){
            
            ShowUserInfoEditView(userName: $mapData.userName, userPhone: $mapData.userPhoneNumber, showUserInfoEditView: $showUserInfoEditView)
        }
        
       
    }
        
        
}

//hàm save upload data vị trí của user lên fire store
func saveLocationOfUserToFireStore(name : String,status:String, phone:String,pass:String,mapData :MapViewModel, cardListViewModel: CardListViewModel) -> Void
{
    if(mapData.vitriCuaUserHienTai != nil){
       
      
        let lat = mapData.vitriCuaUserHienTai?.latitude
        let long = mapData.vitriCuaUserHienTai?.longitude
        let timestamp = NSDate().timeIntervalSince1970
        
        let myCardData = Card(
            name: name,
            pass:pass,
            latitude: lat ?? 0.0,
            longitude: long ?? 0.0,
            timeStamp: timestamp,
            isAvaiable: true,
            status:  status,
            userPhone: phone)
        print(myCardData)
          
        cardListViewModel.add(myCardData, collectname: pass)
    }
}

//hàm xoá toàn bộ ví trí củ của user
func deleteAllLocationOfuserFireStore(cardListViewModel: CardListViewModel) ->String{
   return  cardListViewModel.delete()
}

//hàm lấy ra data các user củng pass trên firestore
func getListOfUserSamePass(pass:String, cardListViewModel: CardListViewModel,completionHandler:  @escaping ([Card]) -> Void){
  
    cardListViewModel.get(collectname: pass, completionHandler: { datas in
       
        completionHandler(datas)
      
    })
  
}

//hàm trả ra các vị trí cuối cùng theo tên user
func getLastLocation(datas:[Card]) -> [Card]
{
    var arrChuaItemLastTimeUpdate = [Card]()
 
    //lọc ra trong datas co bao nhieu name
    let arr_kiemRaCacNameKhacNhau = datas.removingDuplicates(withSame: \.name).map { item  in
        item.name
    }
    print(arr_kiemRaCacNameKhacNhau)
    
    //dùng qua các name khác nhau đó loop lọc array datas theo name
    //var arrOf_arrayCard = [[Card]]()
    
    for i in 0..<arr_kiemRaCacNameKhacNhau.count{
        print(arr_kiemRaCacNameKhacNhau[i])
        //lọc array x theo tên
        let x = datas.filter { item in
            item.name.contains(find: arr_kiemRaCacNameKhacNhau[i])
        }
        //kiem tra lai cac card trong arr x -> lọc ra ngày mới nhất
        //for z in 0..<x.count{
            //print(x[z])
        //}
        let xSort = x.sorted { c1, c2 in
            c1.timeStamp > c2.timeStamp
        }
        print(xSort)
        
        let lastestItem = xSort.first
        if(lastestItem != nil){
            arrChuaItemLastTimeUpdate.append(lastestItem!)
        }
    }
    
    return arrChuaItemLastTimeUpdate
}

//hàm theo dỏi update data của các document trong database
func watchDocumentDataChange(cardListViewModel: CardListViewModel,pass:String)  {
    print("WATCH -> run func watchDocumentDataChange")
     cardListViewModel.watch(collectname: pass)
}

//hàm ngưng theo dỏi
func removeWatchDocumentDataChange(cardListViewModel: CardListViewModel,pass:String)
{
    print("UN WATCH -> removeWatchDocumentDataChange")
    cardListViewModel.unWatch(collectname: pass)
    
}
