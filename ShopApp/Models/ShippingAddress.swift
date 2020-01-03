//
//  ShippingAddress.swift
//  ShopApp
//
//  Created by Nguyễn Đức Huy on 1/3/20.
//  Copyright © 2020 Nguyễn Đức Huy. All rights reserved.
//

import Foundation

class ShippingAddress: NSObject {
    var address: String
    var city: String
    var area: String
    var country: String
    var phone: String
    
    init(address: String, city: String, area: String, country: String, phone: String) {
        self.address = address
        self.city = city
        self.area = area
        self.country = country
        self.phone = phone
    }
}
