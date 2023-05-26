//
//  MainVM.swift
//  bonanza
//
//  Created by Evhen Lukhtan on 17.05.2023.
//

import Foundation
import Combine

final class MainVM: ObservableObject {
    
    @Published var profile: ProfileModel {
        willSet {
            fileDataManager.write(data: newValue, key: .one)
        }
    }
    var fileDataManager = FileDataManager()
    
    init() {
        if let retrievedProfileModel: ProfileModel = fileDataManager.read(key: .one) {
            profile = retrievedProfileModel
        } else {
            profile = ProfileModel.default
        }
    }
}

