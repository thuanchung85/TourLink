//
//  TourLinkApp.swift
//  TourLink
//
//  Created by Luong Thuan Chung on 13/01/2022.
//

import SwiftUI
import FirebaseCore
import FirebaseFirestore
import FirebaseAuth
import FirebaseMessaging


//===FOR THE FIREBASE===//
class AppDelegate: NSObject, UIApplicationDelegate {
  
    func application(_ application: UIApplication,
                   didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool 
    {
        FirebaseApp.configure()

        Messaging.messaging().delegate = self
        UNUserNotificationCenter.current().delegate = self

        let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
        UNUserNotificationCenter.current().requestAuthorization(
          options: authOptions,
          completionHandler: { _, _ in }
        )

        application.registerForRemoteNotifications()
        
       
      
      
    return true
  }
    
   
   
    
}
extension AppDelegate: MessagingDelegate {
       
       func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
           print("Firebase registration token: \(String(describing: fcmToken))")
           
           let dataDict: [String: String] = ["token": fcmToken ?? ""]
           NotificationCenter.default.post(
               name: Notification.Name("FCMToken"),
               object: nil,
               userInfo: dataDict
           )
       }
    
   }

extension AppDelegate: UNUserNotificationCenterDelegate {
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        print("APNS token: \(deviceToken)")
        Messaging.messaging().apnsToken = deviceToken
        
        Messaging.messaging().token { token, error in
            if let error = error {
                print("Error fetching FCM registration token: \(error)")
            } else if let token = token {
                print("FCM registration token: \(token)")
            }
        }
    }
}
  

//=====MAIN APP====//
@main
struct TourLinkApp: App {
    // register app delegate for Firebase setup
     @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate

    //kiem tra network
    @StateObject var networkMonitor = NetworkMonitor()
    
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(networkMonitor)
            
        }
    }
}
