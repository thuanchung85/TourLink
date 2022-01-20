//
//  TourLinkApp.swift
//  TourLink
//
//  Created by Luong Thuan Chung on 13/01/2022.
//

import SwiftUI
import Firebase

@main
struct TourLinkApp: App {
    //ket noi voi firebase google api
    init()
    {
        FirebaseApp.configure()
    }
    
    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
