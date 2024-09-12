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
    
    var body: some View{
        
        
        //form
        VStack(alignment: .center, spacing: 15, content: {
            HStack{
                Text("Enter your group name connect to members")
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
                    
                   
                
                //nut OK
                if(!mapData.groupName.isEmpty){
                    //nut OK
                    Button {
                        //mapData.getAllMemberDataFromDatabase(isZoomin: true)
                        showEnterGroupNameView = false
                        
                        //lấy thông tin toạ độ user khi mở view này lên
                        saveLocationOfUserToFireStore(pass: mapData.groupName,
                                                      mapData: mapData,
                                                      cardListViewModel: cardListViewModel)
                        
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
        
        
        
    }
    
        
}

//hàm save upload data vị trí của user lên fire store
func saveLocationOfUserToFireStore(pass:String,mapData :MapViewModel, cardListViewModel: CardListViewModel) -> Void
{
    if(mapData.vitriCuaUserHienTai != nil){
       
      
        let lat = mapData.vitriCuaUserHienTai?.latitude
        let long = mapData.vitriCuaUserHienTai?.longitude
        let timestamp = NSDate().timeIntervalSince1970

        let myCardData = Card(pass:pass,
                              latitude: lat ?? 0.0,
                              longitude: long ?? 0.0,
                              timeStamp: timestamp,
                              isAvaiable: true,
                              status:  "i am here",
                              userPhone: "0365413666")
        print(myCardData)
          
        cardListViewModel.add(myCardData)
    }
}
