//
//  String + Ext.swift
//  bonanza
//
//  Created by Evhen Lukhtan on 11.05.2023.
//

import Foundation

extension String {
    
    var isValidPassword: Bool {
        let passwordRegEx = "[A-Z0-9a-z]{2,20}"
        let passwordTest = NSPredicate(format: "SELF MATCHES %@", passwordRegEx)
        let result = passwordTest.evaluate(with: self)
        return result
    }
    
    var isValidEmail: Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}"
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        let result = emailTest.evaluate(with: self)
        return result
    }
}
