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
                
                //nut show vi tri cac member
                Button {
                    //mapData.getAllMemberDataFromDatabase(isZoomin: true)
                    showEnterGroupNameView = false
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
            
           
        })
        .padding()
        .background(Color.blue.opacity(0.8))
        .cornerRadius(25)
       
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
