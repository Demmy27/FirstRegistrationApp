//
//  SigningModel.swift
//  FirstRegistrationApp
//
//  Created by Demmy on 11/01/2019.
//  Copyright © 2019 Demmy. All rights reserved.
//

import Foundation

class SigningModel {
    var name: String = ""
    var email: String = ""
    var password: String = ""
    init(name: String, email: String, password: String) {
        self.name = name
        self.email = email
        self.password = password
    }
}
