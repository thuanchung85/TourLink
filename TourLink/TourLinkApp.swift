//
//  TourLinkApp.swift
//  TourLink
//
//  Created by Luong Thuan Chung on 13/01/2022.
//

import SwiftUI
import FirebaseCore


class AppDelegate: NSObject, UIApplicationDelegate {
  func application(_ application: UIApplication,
                   didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
    FirebaseApp.configure()

    return true
  }
}


@main
struct TourLinkApp: App {
    // register app delegate for Firebase setup
     @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate


    init()
    {
        
    }
    
    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
