//
//  ShowUserInfoEditView.swift
//  TourLink
//
//  Created by Luong Thuan Chung on 12/12/2024.
//

import Foundation
import SwiftUI

struct ShowUserInfoEditView : View {
    
    @Binding var userName:String
    @Binding var userPhone:String
    @Binding var showUserInfoEditView:Bool
    
    @FocusState private var nameIsFocused: Bool
    
    //=======BODY======//
    var body: some View{
        //form
        VStack(alignment: .center, spacing: 15, content: {
            
          
               
            
            HStack{
                Text(String(localized:"Enter you informations"))
                Spacer()
            }
            //form
            HStack
            {
                VStack{
                    //nhập tên nhóm
                    HStack{
                        Text( String(localized: "Name")  + ": ")
                            .font(Font.system(size: 15, design: .default))
                        TextField(String(localized: "Enter your name"), text:$userName)
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
                    HStack{
                        Text( String(localized: "Phone")  + ": ")
                            .font(Font.system(size: 15, design: .default))
                        TextField(String(localized: "Enter your phone"), text: $userPhone)
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
                }
                
           
                    //nut OK
                    Button {
                        
                        showUserInfoEditView.toggle()
                        print("SAVE you is : " + userName + " : " + userPhone)
                        UserDefaults.standard.set(userName, forKey: "userName_Save_Local")
                        UserDefaults.standard.set(userPhone, forKey: "userPhone_Save_Local")
                        
                    } label: {
                        
                        Text(String(localized:"Ok")).tint(Color.white)
                        
                    }
                    .frame(width: 60, height: 40, alignment: .center)
                    .background(Color.primary.opacity(0.8))
                    .cornerRadius(20)
                    .overlay(
                        RoundedRectangle(cornerRadius: 20)
                            .stroke(Color.white, lineWidth: 1)
                        
                    )
                    .padding(.horizontal,5)
                }
            
            
           
        })
        .padding()
        .background(Color.white.opacity(0.8))
        .cornerRadius(25)
        
    }
}
