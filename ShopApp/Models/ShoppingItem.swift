//
//  ShoppingItem.swift
//  ShopApp
//
//  Created by Nguyễn Đức Huy on 11/13/19.
//  Copyright © 2019 Nguyễn Đức Huy. All rights reserved.
//

import Foundation
import UIKit

class ShoppingItem: NSObject {
    var id: String
    var image: UIImage
    var designer: String
    var name: String
    var size: String
    var color: String
    var price: NSNumber
    var status: String
    var quantity: NSNumber
    
    init(id: String, image: UIImage, designer: String, name: String, size: String, color: String, price: NSNumber, status: String, quantity: NSNumber) {
        self.id = id
        self.image = image
        self.designer = designer
        self.name = name
        self.size = size
        self.color = color
        self.price = price
        self.status = status
        self.quantity = quantity
    }
}
