//
//  CustomActionSheet.swift
//  TourLink
//
//  Created by Luong Thuan Chung on 31/01/2022.
//

import Foundation
import SwiftUI

struct ShowGroupMemberView : View {
    @StateObject var mapData : MapViewModel
    @Binding var showEnterGroupNameView:Bool
    @ObservedObject var cardListViewModel: CardListViewModel
    
    @State var arrUserSamePass = [Card]()
    @State var showListView = false;
    @FocusState private var nameIsFocused: Bool
    
    
    //=======BODY======//
    var body: some View{
        
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
                            name: mapData.userName,
                            phone: mapData.userPhoneNumber,
                            pass: mapData.groupName,
                            mapData: mapData,
                            cardListViewModel: cardListViewModel)
                        
                        //thu lay ra lai data
                        getListOfUserSamePass(pass: mapData.groupName, cardListViewModel: cardListViewModel, completionHandler: {datas in
                            arrUserSamePass = datas
                        })
                        
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
            
           
        })
        .padding()
        .background(Color.blue.opacity(0.8))
        .cornerRadius(25)
        .onChange(of: mapData.groupName) { value in
            
        }
        
       
        //nút huỷ
        HStack{
            Button {
                showEnterGroupNameView.toggle()
            } label: {
                Text(String(localized:"Cancel")).tint(Color.white)
            }
            .frame(width: 80, height: 40, alignment: .center)
            .background(Color.primary.opacity(0.8))
            .cornerRadius(20)
        }
        
        //show list of user theo arrUserSamePass lấy data từ firebase về
        if(showListView){
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
                            }
                            .padding(.horizontal, 10)
                           
                        }
                        
                    }
                    .padding(.vertical,10)
                    .listRowSeparatorTint(.blue)
                   
                    
                }
              
                .listRowBackground(Color.clear)
               
            }
            .scrollContentBackground(.hidden)
            .background(Color.primary.opacity(0.8))
            .cornerRadius(15)
        }
        
        
        
    }
    
        
}

//hàm save upload data vị trí của user lên fire store
func saveLocationOfUserToFireStore(name : String, phone:String,pass:String,mapData :MapViewModel, cardListViewModel: CardListViewModel) -> Void
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
            status:  "i am here",
            userPhone: phone)
        print(myCardData)
          
        cardListViewModel.add(myCardData, collectname: pass)
    }
}

//hàm lấy ra data các user củng pass trên firestore
func getListOfUserSamePass(pass:String, cardListViewModel: CardListViewModel,completionHandler:  @escaping ([Card]) -> Void){
  
    cardListViewModel.get(collectname: pass, completionHandler: { datas in
       
        completionHandler(datas)
      
    })
  
}
