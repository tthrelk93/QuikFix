//
//  AppDelegate.swift
//  QuikFix
//
//  Created by Thomas Threlkeld on 8/30/17.
//  Copyright © 2017 Thomas Threlkeld. All rights reserved.
//

import UIKit
import GooglePlaces
import GoogleMaps
import GooglePlacePicker
import FirebaseCore
import FirebaseAuth
import FirebaseMessaging
import UserNotifications
import Firebase
import Stripe
import IQKeyboardManagerSwift


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        FirebaseApp.configure()
        IQKeyboardManager.sharedManager().enable = true
        GMSPlacesClient.provideAPIKey("AIzaSyDvw0LOBxWRxlY56O3sbE5nCqs3T3K1u-M")
        GMSServices.provideAPIKey("AIzaSyADVDZNEDAirfuVo92hECXnvCvTay8gXqo")
        STPPaymentConfiguration.shared().publishableKey = "pk_live_F3qPhd7gnfCP6HP2gi1LTX41"
        
        
            // iOS 10 support
        if #available(iOS 10, *) {
            //UNUserNotificationCenter.current().delegate = (self as! UNUserNotificationCenterDelegate)
            // For iOS 10 data message (sent via FCM)
            //Messaging.messaging().remoteMessageDelegate = (self as! MessagingDelegate)
            UNUserNotificationCenter.current().requestAuthorization(options:[.badge, .alert, .sound]){ (granted, error) in }
            application.registerForRemoteNotifications()
        }
            // iOS 9 support
        else if #available(iOS 9, *) {
            UIApplication.shared.registerUserNotificationSettings(UIUserNotificationSettings(types: [.badge, .sound, .alert], categories: nil))
            UIApplication.shared.registerForRemoteNotifications()
        }
            // iOS 8 support
        else if #available(iOS 8, *) {
            UIApplication.shared.registerUserNotificationSettings(UIUserNotificationSettings(types: [.badge, .sound, .alert], categories: nil))
            UIApplication.shared.registerForRemoteNotifications()
        }
            // iOS 7 support
        else {
            application.registerForRemoteNotifications(matching: [.badge, .sound, .alert])
        }
        
        return true
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
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    var token: String?
    func connectToFBMessaging()
    {
        Messaging.messaging().shouldEstablishDirectChannel = true
        /*Messaging.messaging().connect { (error) in
         if (error != nil)
         {
         print("unable to connect lol \(error)")
         }
         else
         {
         print("connected to firebase")
         }
         }*/
    }
    
    func messaging(_ messaging: Messaging, didRefreshRegistrationToken fcmToken: String) {
        print("Firebase registration token: \(fcmToken)")
        self.token = Messaging.messaging().fcmToken
        
        //let refreshedToken = FIRInstanceID.instanceID().token()
        // print("InstanceID token: \(refreshedToken)")
        connectToFBMessaging()
        
    }
    
    func tokenRefreshNotification(notification: NSNotification)
    {
        self.token = Messaging.messaging().fcmToken
        //let refreshedToken = FIRInstanceID.instanceID().token()
        // print("InstanceID token: \(refreshedToken)")
        connectToFBMessaging()
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        print("MessageID: \(userInfo["gcm_message_id"]!)")
        
        if let aps = userInfo["aps"] as? NSDictionary {
            if let alert = aps["alert"] as? NSDictionary {
                if let message = alert["message"] as? NSString {
                    //Do stuff
                    var notifiAlert = UIAlertView()
                    //var NotificationMessage : AnyObject? =  userInfo["alert"]
                    notifiAlert.title = "One Night Band Invite"
                    notifiAlert.message = message as? String
                    notifiAlert.addButton(withTitle: "OK")
                    notifiAlert.show()
                }
            } else if let alert = aps["alert"] as? NSString {
                //Do stuff
                var notifiAlert = UIAlertView()
                //var NotificationMessage : AnyObject? =  userInfo["alert"]
                notifiAlert.title = "One Night Band Invite"
                notifiAlert.message = alert as? String
                notifiAlert.addButton(withTitle: "OK")
                notifiAlert.show()
            }
        }
        // NotificationCenter.
        
        print(userInfo)
    }
    var deviceToken: String?
    // Called when APNs has assigned the device a unique token
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        // Convert token to string
        Messaging.messaging().shouldEstablishDirectChannel = true
        let deviceTokenString = deviceToken.reduce("", {$0 + String(format: "%02X", $1)})
        self.deviceToken = deviceTokenString
        
        // Print it to console
        print("APNs device token: \(deviceTokenString)")
        
        // Persist it in your backend in case it's new
    }
    
    // Called when APNs failed to register the device for push notifications
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        // Print the error to console (you should alert the user that registration failed)
        print("APNs registration failed: \(error)")
    }
    
    // Push notification received
    //Make use of the data object which will contain any data that you send from your application backend, such as the chat ID, in the messenger app example.
    func application(_ application: UIApplication, didReceiveRemoteNotification data: [AnyHashable : Any]) {
        // Print notification payload data
        // let alert = UIAlertController(title: "Tapped the alert banner", message: "Popups are a terrible user experience, eh?", preferredStyle: .Alert)
        //self.showViewController(alert, sender: nil)
        print("Push notification received: \(data)")
        
    }


}

