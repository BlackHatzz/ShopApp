//
//  Product.swift
//  ShopApp
//
//  Created by Nguyễn Đức Huy on 7/18/19.
//  Copyright © 2019 Nguyễn Đức Huy. All rights reserved.
//

import Foundation
import UIKit

class Product {
    var id: String
    var name: String?
    var imageUrls: [Int: [String]]
    var sizes: [String]?
    var discountPrice: NSNumber? {
        get {
            if price == nil { return nil }
            if discount == nil { return nil }
            return NSNumber(value: round((price!.floatValue * discount!.floatValue / 100)*100) / 100)
        }
    }
    var price: NSNumber?
    var discount: NSNumber?
    var quantity: NSNumber
    var detail: String?
    var sizeAndFit: String?
    var category: String?
    var designer: String?
    var status: String?
    var composition: [String]?
    var hexColors: [String]?
    var textColors: [String]?
    var images = [Int: [Int: UIImage]]() // [indexOfImagesList Int: [indexImages Int: image UIImage]]?
    
    init(id: String, productInfo: [String: Any]) {
        assert(!id.isEmpty, "product id can not be empty")
        self.id = id
        
        typealias key = Product.InfoKey
        
        self.name = productInfo[key.name] as? String
        
        self.imageUrls = [Int: [String]]()
        for i in 0..<productInfo.count {
            if let imageUrl = productInfo["\(key.imageUrls)\(i)"] as? [String] {
                self.imageUrls[i] = imageUrl
            } else { break }
        }
//        if self.imageUrls!.isEmpty { self.imageUrls = nil }
        
        self.sizes = productInfo[key.sizes] as? [String]
//        self.discountPrice = productInfo[key.discountPrice] as? NSNumber
        self.price = productInfo[key.price] as? NSNumber
        self.discount = productInfo[key.discount] as? NSNumber
        self.quantity = productInfo[key.quantity] as! NSNumber
        self.detail = productInfo[key.detail] as? String
        self.sizeAndFit = productInfo[key.sizeAndFit] as? String
        self.category = productInfo[key.category] as? String
        self.designer = productInfo[key.designer] as? String
        self.status = productInfo[key.status] as? String
        self.composition = productInfo[key.composition] as? [String]
        self.hexColors = productInfo[key.hexColors] as? [String]
        self.textColors = productInfo[key.textColors] as? [String]
    }
    
    struct InfoKey {
        //static let id = "id"
        static let name = "name"
        static let imageUrls = "imageUrls"
        static let sizes = "sizes"
        static let discountPrice = "discountPrice"
        static let price = "price"
        static let quantity = "quantity"
        static let discount = "discount"
        static let detail = "detail"
        static let sizeAndFit = "sizeAndFit"
        static let category = "category"
        static let designer = "designer"
        static let status = "status"
        static let composition = "composition"
        static let hexColors = "hexColors"
        static let textColors = "textColors"
    }
    
    struct HexColor {
        static let black = "#0F0F0F"
        static let ivory = "#E2D9CD"
        static let brown = "#7A5848"
    }
    struct TextColor {
        static let black = "black"
        static let ivory = "ivory"
        static let brown = "brown"
    }
    
    static func loadImageFromStorage(fromURLString imageUrl: String, completion: ((_ result: UIImage?) -> Void)?) {
        if let url = URL(string: imageUrl) {
            URLSession.shared.dataTask(with: url) { (data, response, error) in
                if let error = error {
                    print("can not download image. Error is \(error)")
                }
                if let data = data {
                    DispatchQueue.main.async {
                        if let completion = completion {
                            completion(UIImage(data: data)) // can be nil
                        }
                    }
                }
            }.resume()
        }
        
    }
    
    static func loadImageFromStorage(fromURLStrings imageUrls: [String], handleEachResult: ((_ index: Int, _ result: UIImage) -> Void)?, completion: ((_ finalResult: [Int: UIImage]) -> Void)?) {
        var initialResult = [Int: UIImage]()
        var resultCounter = imageUrls.count
        
        //        productImages[currentIndexProductImages] = [Int: UIImage]()
        for (index, imageUrl) in imageUrls.enumerated() {
            
            if let url = URL(string: imageUrl) {
                URLSession.shared.dataTask(with: url, completionHandler: { (data, response,error) in
                    if let error = error {
                        print("can not download image. Error is \(error)")
                        // error while downloading
                        resultCounter -= 1
                    } else if let data = data {
                        DispatchQueue.main.async {
                            if let image = UIImage(data: data) {
                                initialResult[index] = image
                                
//                                temp[0]?[index] = image
//                                print("temp inside", temp)
                                print("inside", initialResult)
                                if let handler = handleEachResult {
                                    handler(index, image)
                                }
                                
                                if initialResult.count == resultCounter {
                                    if let completion = completion {
                                        completion(initialResult)
                                    }
                                }
                            } else {
                                // image is nil
                                resultCounter -= 1
                            }
                        }
                        
                    } else {
                        // data is nil
                        resultCounter -= 1
                    }
                }).resume()
            } // check whether url is nil or not
        } // iterate over imageUrls
        // ??? get data ref
    }
    
    static func loadImageFromStorage(fromURLStrings imageUrls: [String], completion: ((_ result: [Int: UIImage]) -> Void)?) {
        var initialResult = [Int: UIImage]()
        var resultCounter = imageUrls.count
//        productImages[currentIndexProductImages] = [Int: UIImage]()
        for (index, imageUrl) in imageUrls.enumerated() {
            
            if let url = URL(string: imageUrl) {
                URLSession.shared.dataTask(with: url, completionHandler: { (data, response,error) in
                    if let error = error {
                        print("can not download image. Error is \(error)")
                        // error while downloading
                        resultCounter -= 1
                    } else if let data = data {
                        DispatchQueue.main.async {
                            if let image = UIImage(data: data) {
                                initialResult[index] = image
                                if initialResult.count == resultCounter {
                                    if let completion = completion {
                                        completion(initialResult)
                                    }
                                }
                            } else {
                                // image is nil
                                resultCounter -= 1
                            }
                        }
                        
                    } else {
                        // data is nil
                        resultCounter -= 1
                    }
                }).resume()
            } // check whether url is nil or not
        } // iterate over imageUrls
        // ??? get data ref
    }
    
    
}
