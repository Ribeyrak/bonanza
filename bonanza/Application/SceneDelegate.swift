//
//  SceneDelegate.swift
//
//  Created by Evhen Lukhtan on 11.05.2023.
//

import UIKit
import AppsFlyerLib
import Alamofire
import AppTrackingTransparency
import AdSupport

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    
    var window: UIWindow?
    var appsFID: String = ""
    var utms: String = "organic"
    var campaign: String = ""
    var campID: String = ""
    var appDelegate: AppDelegate?
    var advertising_id: String = ""
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        window = UIWindow(windowScene: windowScene)
        appDelegate = UIApplication.shared.delegate as? AppDelegate
        appsFID = AppsFlyerLib.shared().getAppsFlyerUID()
        checkUser()
        continueSceneConfiguration()
    }
    
    func continueSceneConfiguration() {
        if let _: ProfileModel = FileDataManager().read(key: .one) {
            let viewController = UINavigationController(rootViewController: MainVC())
            window?.rootViewController = viewController
        } else {
            let viewController = UINavigationController(rootViewController: StartVC())
            window?.rootViewController = viewController
        }
        window?.makeKeyAndVisible()
    }
    
    func sceneDidBecomeActive(_ scene: UIScene) {
        //Retrieve IDFA if tracking is enabled
        if #available(iOS 14, *) {
            ATTrackingManager.requestTrackingAuthorization { [weak self] status in
                DispatchQueue.main.async {
                    if status == .authorized || status == .notDetermined {
                        self?.retrieveIDFA()
                        let idfa = ASIdentifierManager.shared().advertisingIdentifier.uuidString
                        print("status = \(status.rawValue), idfa = \(idfa)")
                    } else {
                        // Tracking is not authorized
                        self?.advertising_id = "Tracking Not Authorized"
                        // Handle accordingly
                    }
                }
            }
        } else {
            // For iOS versions prior to 14, use the deprecated method
            if ASIdentifierManager.shared().isAdvertisingTrackingEnabled {
                self.retrieveIDFA()
            } else {
                self.advertising_id = "Tracking Not Enabled"
            }
        }
        
        AppsFlyerLib.shared().start(completionHandler: { [weak self] (dictionary, error) in
            if let error = error {
                print(error)
                return
            } else {
                self?.checkUser()
                print(dictionary ?? "")
                return
            }
        })
    }
    
    func retrieveIDFA() {
        if #available(iOS 14, *) {
            self.advertising_id = ASIdentifierManager.shared().advertisingIdentifier.uuidString
        } else {
            self.advertising_id = ASIdentifierManager.shared().advertisingIdentifier.uuidString
        }
    }
    
    func checkUser() {
        // Your logic to retrieve CUID
        let customUserId = UserDefaults.standard.string(forKey: UserDefaultsKeys.userID.rawValue)
        if let customUserId = customUserId, !customUserId.isEmpty {
            // Set CUID in AppsFlyer SDK for this session
            AppsFlyerLib.shared().customerUserID = customUserId
            AppsFlyerLib.shared().start()
        } else {
            let uuid = UUID().uuidString
            UserDefaults.standard.set(uuid, forKey: UserDefaultsKeys.userID.rawValue)
            AppsFlyerLib.shared().customerUserID = uuid
            AppsFlyerLib.shared().start()
        }
    }
}

