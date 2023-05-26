//
//  UserDefaultsStorage.swift
//  bonanza
//
//  Created by Evhen Lukhtan on 17.05.2023.
//

import Foundation

extension UserDefaults {
    private static let encoder = JSONEncoder()
    private static let decoder = JSONDecoder()

    func store<T: Codable>(_ data: T?, forKey key: UserDefaultsKeys) {
        if let option = data, let encoded = try? UserDefaults.encoder.encode(option) {
            set(encoded, forKey: key.rawValue)
        } else {
            set(nil, forKey: key.rawValue)
        }
    }

    func restoreData<T: Codable>(fromKey key: UserDefaultsKeys) -> T? {
        guard let option = data(forKey: key.rawValue) else {
            return nil
        }
        return try? UserDefaults.decoder.decode(T.self, from: option)
    }

    func store(_ double: Double, forKey key: UserDefaultsKeys) {
        set(double, forKey: key.rawValue)
    }

    func restoreDouble(forKey key: UserDefaultsKeys) -> Double {
        double(forKey: key.rawValue)
    }

    func store(_ bool: Bool, forKey key: UserDefaultsKeys) {
        set(bool, forKey: key.rawValue)
    }

    func restoreBool(forKey key: UserDefaultsKeys) -> Bool {
        bool(forKey: key.rawValue)
    }

    func removeObject(forKey key: UserDefaultsKeys) {
        removeObject(forKey: key.rawValue)
    }
}
