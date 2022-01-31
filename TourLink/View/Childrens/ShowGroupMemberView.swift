//
//  CustomActionSheet.swift
//  TourLink
//
//  Created by Luong Thuan Chung on 31/01/2022.
//

import Foundation
import SwiftUI

struct ShowGroupMemberView : View {
    var mapData : MapViewModel
    @Binding var showEnterGroupNameView:Bool
    @State var groupName  = ""
    
    var body: some View{
        VStack(alignment: .center, spacing: 15, content: {
            HStack
            {
                Text("Group: ")
                    .font(Font.system(size: 15, design: .default))
                TextField("Name of your group", text: $groupName)
                    .foregroundColor(.blue)
                    .font(Font.system(size: 15, design: .default))
                    .padding()
                    .frame( height: 30)
                    .overlay(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(Color.blue, lineWidth: 1)
                                
                    ).background(Color.white.opacity(0.9))
                    .cornerRadius(10)
                
                //nut show vi tri cac member
                Button {
                    mapData.getAllMemberDataFromDatabase(isZoomin: true)
                    showEnterGroupNameView = false
                } label: {
                    Image(systemName: "person.fill.questionmark")
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
        })
        .padding()
        .background(Color.blue.opacity(0.5))
        .cornerRadius(25)
       
    }
  
}
