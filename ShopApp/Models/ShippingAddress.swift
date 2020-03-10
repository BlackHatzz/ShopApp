//
//  ShippingAddress.swift
//  ShopApp
//
//  Created by Nguyễn Đức Huy on 1/3/20.
//  Copyright © 2020 Nguyễn Đức Huy. All rights reserved.
//

import Foundation

class ShippingAddress: NSObject {
    var id: String?
    var firstName: String?
    var lastName: String?
    var address: String?
    var city: String?
    var state: String? // or county or province
    var country: String?
    var phoneNumber: String?
    
    init(id: String, dictionary: [String: Any]) {
        firstName = dictionary[InfoKey.firstName] as? String
        lastName = dictionary[InfoKey.lastName] as? String
        address = dictionary[InfoKey.address] as? String
        city = dictionary[InfoKey.city] as? String
        state = dictionary[InfoKey.state] as? String
        country = dictionary[InfoKey.country] as? String
        phoneNumber = dictionary[InfoKey.phoneNumber] as? String
    }
    
    struct InfoKey {
        static let key: String = "shippingAddress"
        static let firstName: String = "firstName"
        static let lastName: String = "lastName"
        static let address: String = "address"
        static let city: String = "city"
        static let state: String = "state"
        static let country: String = "country"
        static let phoneNumber: String = "phoneNumber"
    }
}
