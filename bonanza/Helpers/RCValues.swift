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

