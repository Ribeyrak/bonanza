//
//  FileStorage.swift
//  bonanza
//
//  Created by Evhen Lukhtan on 17.05.2023.
//

import Foundation

class FileDataManager {
    
    enum Keys: String {
        case one
    }
    
    private static let encoder = JSONEncoder()
    private static let decoder = JSONDecoder()
    
    public func write<T>(data: T, key: Keys) where T: Encodable {
        if let encoded = try? FileDataManager.encoder.encode(data) {
            let path = createPath(key: key)
            try? encoded.write(to: path)
        }
    }
    
    public func read<T>(key: Keys) -> T? where T: Decodable {
        if let data = try? Data(contentsOf: createPath(key: key)),
           let decoded = try? FileDataManager.decoder.decode(T.self, from: data) {
            return decoded
        }
        return nil
    }
    
    private func createPath(key: Keys) -> URL {
        FileManager.default.urls(
            for: .documentDirectory,
            in: .userDomainMask
        )[0].appendingPathComponent(key.rawValue)
    }
}
