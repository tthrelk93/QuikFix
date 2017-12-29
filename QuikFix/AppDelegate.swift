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
//import HockeySDK


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, MessagingDelegate {

    var window: UIWindow?
    
    // 1) To get started with this demo, first head to https://dashboard.stripe.com/account/apikeys
    // and copy your "Test Publishable Key" (it looks like pk_test_abcdef) into the line below.
    let stripePublishableKey = "pk_test_cmqNsIYuyCchUdHAnaHOyiXp"//"pk_live_F3qPhd7gnfCP6HP2gi1LTX41"
    
    // 2) Next, optionally, to have this demo save your user's payment details, head to
    // https://github.com/stripe/example-ios-backend , click "Deploy to Heroku", and follow
    // the instructions (don't worry, it's free). Replace nil on the line below with your
    // Heroku URL (it looks like https://blazing-sunrise-1234.herokuapp.com ).
    let backendBaseURL: String? = "https://quikfix123.herokuapp.com"
    
    // 3) Optionally, to enable Apple Pay, follow the instructions at https://stripe.com/docs/mobile/apple-pay
    // to create an Apple Merchant ID. Replace nil on the line below with it (it looks like merchant.com.yourappname).
    let appleMerchantID: String? = nil
    
    // These values will be shown to the user when they purchase with Apple Pay.
    let companyName = "QuikFix"
    let paymentCurrency = "usd"


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        FirebaseApp.configure()
        /*BITHockeyManager.shared().configure(withIdentifier: "APP_IDENTIFIER")
        BITHockeyManager.shared().start()
        BITHockeyManager.shared().authenticator.authenticateInstallation() // This line is obsolete in the crash only builds*/
        IQKeyboardManager.sharedManager().enable = true
        GMSPlacesClient.provideAPIKey("AIzaSyDvw0LOBxWRxlY56O3sbE5nCqs3T3K1u-M")
        GMSServices.provideAPIKey("AIzaSyADVDZNEDAirfuVo92hECXnvCvTay8gXqo")
        
        STPPaymentConfiguration.shared().publishableKey = "pk_test_cmqNsIYuyCchUdHAnaHOyiXp"//"pk_live_F3qPhd7gnfCP6HP2gi1LTX41"
        MyAPIClient.sharedClient.baseURLString = self.backendBaseURL
        
        // This code is included here for the sake of readability, but in your application you should set up your configuration and theme earlier, preferably in your App Delegate.
        let config = STPPaymentConfiguration.shared()
        config.publishableKey = self.stripePublishableKey
        config.appleMerchantIdentifier = self.appleMerchantID
        config.companyName = self.companyName
       // config.requiredBillingAddressFields = settings.requiredBillingAddressFields
        //config.requiredShippingAddressFields = settings.requiredShippingAddressFields
        // config.shippingType = settings.shippingType
       // config.additionalPaymentMethods = settings.additionalPaymentMethods
        Messaging.messaging().delegate = self
        
        
            // iOS 10 support
       
        
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
        print("inRefresh")
        self.token = Messaging.messaging().fcmToken
        //let refreshedToken = FIRInstanceID.instanceID().token()
        // print("InstanceID token: \(refreshedToken)")
        connectToFBMessaging()
    }
    
  
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        /*print("MessageID: \(userInfo["gcm_message_id"]!)")
        
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
        
        print(userInfo)*/
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

