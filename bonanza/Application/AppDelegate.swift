//
//  AppDelegate.swift
//  bonanza
//
//  Created by Evhen Lukhtan on 11.05.2023.
//

import UIKit
import AppsFlyerLib
import FirebaseCore
import OneSignal

@main
class AppDelegate: UIResponder, UIApplicationDelegate, AppsFlyerLibDelegate {
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
                
        AppsFlyerLib.shared().appsFlyerDevKey = "8pqP5YmEPztUDwDK7HTjC5"
        AppsFlyerLib.shared().appleAppID = "6449024925"
//        AppsFlyerLib.shared().isDebug = true
//        AppsFlyerLib.shared().waitForATTUserAuthorization(timeoutInterval: 60)
        AppsFlyerLib.shared().delegate = self

        FirebaseApp.configure()
        _ = RCValues.sharedInstance
        
        // Remove this method to stop OneSignal Debugging
        OneSignal.setLogLevel(.LL_VERBOSE, visualLevel: .LL_NONE)
        // OneSignal initialization
        OneSignal.initWithLaunchOptions(launchOptions)
        OneSignal.setAppId("3528d54b-d71d-488d-8071-4cea4ffc96a4")
        OneSignal.promptForPushNotifications(userResponse: { accepted in
            print("User accepted notifications: \(accepted)")
        })
        
        // Set your customer userId
        // OneSignal.setExternalUserId("userId")
        
        return true
    }
    
    func onConversionDataSuccess(_ installData: [AnyHashable: Any]) {
        if let status = installData["af_status"] as? String {
            print("STATUS AppsFlyer \(status)")
            print("DATA \(installData)")
            
            if (status == "Non-organic") {
                // Business logic for Non-organic install scenario is invoked
                if let sourceID = installData["media_source"],
                   let campaign = installData["campaign"],
                   let campaignID = installData["campaign_id"] {
                    print("This is a Non-organic install. Media source: \(sourceID)  Campaign: \(campaign)")
                    if let window = UIApplication.shared.windows.first,
                       let sceneDelegate = window.windowScene?.delegate as? SceneDelegate {
                        sceneDelegate.utms = sourceID as! String
                        sceneDelegate.campaign = campaign as! String
                        sceneDelegate.campID = campaignID as! String
                    }
                }
                else {
                    // Business logic for organic install scenario is invoked
                    print("This is an organic install")
                    
                }
            }
        }
    }
    
    func onConversionDataFail(_ error: Error!) {
        if error != nil{
            print("error")
        }
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
    }
    
    // MARK: UISceneSession Lifecycle
    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }
    
    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
    }
}
