//
//  ProfileModel.swift
//  bonanza
//
//  Created by Evhen Lukhtan on 11.05.2023.
//

import Foundation

struct ProfileModel: Codable {
    var firstName: String
    var balance: Int
    var phoneNumber: String
    var userEmail: String
    var pasword: String
    
    static var `default`: ProfileModel = .init(
        firstName: "enter Name",
        balance: 500,
        phoneNumber: "+1234567890",
        userEmail: "example@mail.com",
        pasword: "1111"
    )
}
