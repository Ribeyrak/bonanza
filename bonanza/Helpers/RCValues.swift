////
////  RCValues.swift
////  bonanza
////
////  Created by Evhen Lukhtan on 18.05.2023.
////
//
import Firebase
import FirebaseRemoteConfig


enum ValueKey: String {
    case link
    case flag
}

//class RCValues {
//    static let sharedInstance = RCValues()
//
//    init() {
//        loadDefaultValues()
//        fetchCloudValues()
//    }
//
//    func loadDefaultValues() {
//        let appDefaults: [String: Any?] = [
//            "DisplayTestScreen": "false",
//            "link": "bonanzabillion.fun",
//        ]
//        RemoteConfig.remoteConfig().setDefaults(appDefaults as? [String: NSObject])
//    }
//
//    func activateDebugMode() {
//        let settings = RemoteConfigSettings()
//        // WARNING: Don't actually do this in production!
//        settings.minimumFetchInterval = 0
//        RemoteConfig.remoteConfig().configSettings = settings
//        //RemoteConfig.remoteConfig().setDefaults(fromPlist: "remote_config_defaults")
//    }
//
//    func fetchCloudValues() {
//        // 1
//        activateDebugMode()
//        // 2
//        RemoteConfig.remoteConfig().fetch { status, error in
//            if let error = error {
//                print("OMG remoteCongig FETCH ERROR \(error)")
//                return
//            }
//            // 3
//            RemoteConfig.remoteConfig().activate { test1, test2 in
//                print("Retrieved values from the cloud!")
//                print("HHHHHHHHHH")
//                let appPrimaryColorString = RemoteConfig.remoteConfig()
//                    .configValue(forKey: "link")
//                    .stringValue ?? "undefined"
//                print("Our app's primary color is \(appPrimaryColorString)")
//                let tempFlag = RemoteConfig.remoteConfig().configValue(forKey: "DisplayTestScreen").boolValue
//                print("TEMP FLAG = \(tempFlag)")
//            }
//        }
//    }
//
//    func updateBalance(forKey key: ValueKey) -> String {
//        let balance = RemoteConfig.remoteConfig()[(key.rawValue)]
//            .stringValue ?? "0"
//        let convert = String(balance)
//        return convert
//    }
//
//    func updateLink(forKey key: ValueKey) -> String {
//        let tempLink = RemoteConfig.remoteConfig()[(key.rawValue)]
//            .stringValue ?? "404"
//        let link = String(tempLink)
//        return link
//    }
//
//    func updateFlag() -> Bool {
//        let tempFlag = RemoteConfig.remoteConfig().configValue(forKey: "DisplayTestScreen").boolValue
//        return tempFlag
//    }
//
//}

class RCValues {
    static let sharedInstance = RCValues()

    init() {
        loadDefaultValues()

    }

    func loadDefaultValues() {
        let appDefaults: [String: Any?] = [
            "DisplayTestScreen": "false",
            "link": "bonanzabillion.fun",
        ]
        RemoteConfig.remoteConfig().setDefaults(appDefaults as? [String: NSObject])
    }

    func fetchCloudValues(completion: @escaping (Bool) -> Void) {
        RemoteConfig.remoteConfig().fetch { [weak self] status, error in
            if let error = error {
                print("OMG remoteConfig FETCH ERROR \(error)")
                completion(false) // Notify completion with failure
                return
            }

            RemoteConfig.remoteConfig().fetchAndActivate { [weak self] _, error in
                if let error = error {
                    print("OMG remoteConfig ACTIVATE ERROR \(error)")
                    completion(false) // Notify completion with failure
                    return
                }

                print("Retrieved and activated values from the cloud!")
                completion(true) // Notify completion with success
            }
        }
    }

    func updateBalance(forKey key: ValueKey) -> String {
        let balance = RemoteConfig.remoteConfig()[key.rawValue].stringValue ?? "0"
        return balance
    }

    func updateLink(forKey key: ValueKey) -> String {
        let tempLink = RemoteConfig.remoteConfig()[key.rawValue].stringValue ?? "404"
        return tempLink
    }

    func updateFlag() -> Bool {
        let tempFlag = RemoteConfig.remoteConfig().configValue(forKey: "DisplayTestScreen").boolValue
        return tempFlag
    }
}

