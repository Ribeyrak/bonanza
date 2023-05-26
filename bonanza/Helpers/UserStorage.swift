//
//  UserStorage.swift
//  bonanza
//
//  Created by Evhen Lukhtan on 17.05.2023.
//

import Foundation

protocol UserStorage {
    var name: String? {get nonmutating set}
    var balance: Double {get nonmutating set}
    var phoneNumber: String? {get nonmutating set}
    var userEmail: String? {get nonmutating set}
    var pasword: String? {get nonmutating set}
    var userID: String? {get nonmutating set}
}

extension UserDefaults: UserStorage {
    var name: String? {
        get {
            restoreData(fromKey: .nickName)
        }
        set {
            store(newValue, forKey: .nickName)
        }
    }
    
    var balance: Double {
        get {
            restoreDouble(forKey: .balance)
        }
        set {
            store(newValue, forKey: .balance)
        }
    }
    
    var phoneNumber: String? {
        get {
            restoreData(fromKey: .phone)
        }
        set {
            store(newValue, forKey: .phone)
        }
    }
    
    var userEmail: String? {
        get {
            restoreData(fromKey: .email)
        }
        set {
            store(newValue, forKey: .email)
        }
    }
    
    var pasword: String? {
        get {
            restoreData(fromKey: .pasword)
        }
        set {
            store(newValue, forKey: .pasword)
        }
    }
    
    var userID: String? {
        get {
            restoreData(fromKey: .userID)
        }
        set {
            store(newValue, forKey: .userID)
        }
    }
    
    
}
