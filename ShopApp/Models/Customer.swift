//
//  Customer.swift
//  ShopApp
//
//  Created by Nguyễn Đức Huy on 11/13/19.
//  Copyright © 2019 Nguyễn Đức Huy. All rights reserved.
//

import Foundation

class Customer: NSObject {
    var id: String?
    var firstname: String?
    var lastname: String?
    var fullname: String? {
        if firstname == nil || lastname == nil {
            return nil
        }
        return firstname! + " " + lastname!
    }
    var email: String?
    
    
    var shoppingBag = [ShoppingItem]()
    var wishList = [ShoppingItem]()
    
    enum BagType {
        case shoppingBag
        case wishList
    }
    
    init(id: String?, firstname: String?, lastname: String?, email: String?) {
        self.id = id
        self.firstname = firstname
        self.lastname = lastname
        self.email = email
    }
    
    init(id: String, userInfo: [String: Any]) {
        typealias key = Customer.InfoKey
        
        self.id = id
        self.firstname = userInfo[key.firstname] as? String
        self.lastname = userInfo[key.lastname] as? String
        self.email = userInfo[key.email] as? String
    }
    
    struct InfoKey {
        static let firstname = "firstname"
        static let lastname = "lastname"
        static let email = "email"
    }
    
    
    func add(to bagType: BagType, withItem newItem: ShoppingItem) {
        switch bagType {
        case .shoppingBag:
            var isAddedItem = false // check item has been in bag or not
            for item in shoppingBag {
                if newItem.id == item.id {
                    if newItem.size == item.size && newItem.color == item.color {
                        // if id, size, color of new item == item. They are the same
                        // increase quantity by 1
                        item.quantity = NSNumber(value: Int(truncating: item.quantity) + 1)
                        isAddedItem = true
                        
                        // finished when the bag is updated
                        break
                    }
                }
            }
            if !isAddedItem {
                shoppingBag.append(newItem)
            }
        case .wishList:
            var isAddedItem = false // check item has been in bag or not
            for item in wishList {
                if newItem.id == item.id {
                    if newItem.size == item.size && newItem.color == item.color {
                        // if id, size, color of new item == item. They are the same
                        // increase quantity by 1
                        item.quantity = NSNumber(value: Int(truncating: item.quantity) + 1)
                        isAddedItem = true
                        
                        // finished when the bag is updated
                        break
                    }
                }
            }
            if !isAddedItem {
                wishList.append(newItem)
            }
        }
    }
    
    func getShoppingBagTotalPrice() -> NSNumber {
        // alway for shoppingBag
        // not wishlist
        var result: NSNumber = 0
        for item in shoppingBag {
            result = NSNumber(value: Float(truncating: result) + Float(truncating: item.discountPrice))
        }
        
        return result
    }
}
