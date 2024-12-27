//
//  ContentView.swift
//  TourLink
//
//  Created by Luong Thuan Chung on 13/01/2022.
//
import MapKit
import SwiftUI


struct ContentView: View {
    @ObservedObject var cardListViewModel: CardListViewModel = CardListViewModel()
    @EnvironmentObject var networkMonitor: NetworkMonitor
   
    @State private var showNetworkAlert = false
    
    //====BODY===//
    var body: some View {
        NavigationView {
                  //neu internet ok
                    if networkMonitor.isConnected {
                        Home(cardListViewModel: cardListViewModel ,isDisAble: false)
                    }
                    //neu khong co internet
                    else{
                        ZStack{
                            Home(cardListViewModel: cardListViewModel, isDisAble: true)
                            Text( "Network connection seems to be offline.")
                                .foregroundStyle(.white)
                                .font(.system(size: 12))
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
                    }
                }
        .onChange(of: networkMonitor.isConnected) { connection in
                  showNetworkAlert = connection == false
              }
        .alert("Network connection seems to be offline.",isPresented: $showNetworkAlert) {}
    }//end body
    
    
}//end struct

