//
//  ContentView.swift
//  TourLink
//
//  Created by Luong Thuan Chung on 13/01/2022.
//
import MapKit
import SwiftUI

struct ContentView: View {
    
    //tao model
    @StateObject var myModel_QuanLyUserLocation1 = myModel_QuanLyUserLocation()
    
    
    
    
    //====BODY===//
    var body: some View {
        Map(coordinateRegion: $myModel_QuanLyUserLocation1.region, showsUserLocation:true)
            .ignoresSafeArea()
            .onAppear(){
                myModel_QuanLyUserLocation1.kiemTraIphoneCoDichVuLocation()
            }
    
    }//end body
    
    
}//end struct

