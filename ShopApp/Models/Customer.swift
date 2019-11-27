//
//  Customer.swift
//  ShopApp
//
//  Created by Nguyễn Đức Huy on 11/13/19.
//  Copyright © 2019 Nguyễn Đức Huy. All rights reserved.
//

import Foundation

class Customer: NSObject {
    var firstName: String
    var lastName: String
    var fullName: String {
        return firstName + lastName
    }
    
    var shoppingBag: [ShoppingItem]
    
    init(firstName: String, lastName: String) {
        self.firstName = firstName
        self.lastName = lastName
        shoppingBag = [ShoppingItem]()
    }
}
