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
    
    
    //vi tri hien tai 10.833404020168635, 106.78408553084277 la nha minh
    @State var region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 10.833404020168635, longitude: 106.78408553084277), span: MKCoordinateSpan(latitudeDelta: 0.009, longitudeDelta: 0.009))
    
    
    //====BODY===//
    var body: some View {
        Map(coordinateRegion: $region, showsUserLocation:true)
            .ignoresSafeArea()
            .onAppear(){
                myModel_QuanLyUserLocation1.kiemTraIphoneCoDichVuLocation()
            }
    
    }//end body
    
    
}//end struct

