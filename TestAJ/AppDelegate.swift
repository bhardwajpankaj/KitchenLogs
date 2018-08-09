//
//  AppDelegate.swift
//  KitchenLogs
//
//  Created by Pankaj Bhardwaj on 12/04/17.
//  Copyright © 2017 . All rights reserved.
//

import UIKit
import UserNotifications
import Fabric
import Crashlytics
import Firebase




let myDeviceTokenKey = "device_token"
let myToken = "tokenRecived"
var notificationTitle = ""
@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate,UNUserNotificationCenterDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
       
        
        Fabric.with([Crashlytics.self])
        FirebaseApp.configure()

        let center  = UNUserNotificationCenter.current()
        center.delegate = self
        // set the type as sound or badge
        
        center.requestAuthorization(options: [.sound,.alert,.badge]) { (granted, error) in
            // Enable or disable features based on authorization
            if granted {
                print("Yay!")
            } else {
                print("D'oh")
            }
        }
        application.registerForRemoteNotifications()
        
        return true
    }


    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        //create the notificationCenter
        let center  = UNUserNotificationCenter.current()
        center.delegate = self
        // set the type as sound or badge
        center.requestAuthorization(options: [.sound,.alert,.badge]) { (granted, error) in
            // Enable or disable features based on authorization
            if granted {
                print("Yay!")
            } else {
                print("D'oh")
            }
        }
        
        let tokenParts = deviceToken.map { data -> String in
            return String(format: "%02.2hhx", data)
        }
        let token = tokenParts.joined()
        print(token)

        UserDefaults.standard.setValue(token, forKey: myDeviceTokenKey)
        
        let JWTtoken : String = UserDefaults.standard.value(forKey: "jwt_auth_token") as? String ?? ""

        if(token != "" && JWTtoken == ""){
        NotificationCenter.default.post(name: Notification.Name(rawValue: myDeviceTokenKey), object: self)
        }

    }
    
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print("Registration failed")
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter,  willPresent notification: UNNotification, withCompletionHandler   completionHandler: @escaping (_ options:   UNNotificationPresentationOptions) -> Void) {
        print("Handle push from foreground")
        
        if #available(iOS 10.0, *) {
            let center = UNUserNotificationCenter.current()
            center.requestAuthorization(options: [.alert, .sound]) { (granted, error) in
                // Enable or disable features based on authorization.
                if granted {
                    print("Yay!")
                } else {
                    print("D'oh")
                }
            }
        } else {
            // Fallback on earlier versions
        }
        // custom code to handle push while app is in the foreground
        print("\(notification.request.content.userInfo)")
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        print("Handle push from background or closed")
        // if you set a member variable in didReceiveRemoteNotification, you  will know if this is from closed or background
        print("\(response.notification.request.content.userInfo)")
        notificationTitle = response.notification.request.content.title
        UserDefaults.standard.setValue(notificationTitle, forKey: "notification")
        let sb = UIStoryboard(name: "Main", bundle: nil)

        let otherVC : ViewController? = sb.instantiateViewController(withIdentifier: "addNewLog") as? ViewController
        window?.rootViewController = otherVC;
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
        application.applicationIconBadgeNumber = 0;

    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

