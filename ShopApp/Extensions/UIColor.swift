//
//  UIColor.swift
//  ShopApp
//
//  Created by Nguyễn Đức Huy on 9/2/19.
//  Copyright © 2019 Nguyễn Đức Huy. All rights reserved.
//

import UIKit.UIColor
import Foundation

extension UIColor {
    static func rgb(_ r: CGFloat, _ g: CGFloat, _ b: CGFloat) -> UIColor {
        return self.init(red: r/255, green: g/255, blue: b/255, alpha: 1)
    }
    static func rgba(_ r: CGFloat, _ g: CGFloat, _ b: CGFloat, _ a: CGFloat) -> UIColor {
        return self.init(red: r/255, green: g/255, blue: b/255, alpha: a)
    }
    
    static func colorFrom(hexString: String) -> UIColor {
        var hex = hexString.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        
        if hex.hasPrefix("#") {
            hex.remove(at: hex.startIndex)
        }
        
        if hex.count != 6 {
            return UIColor.black
        }
//        self.init(r: CGFloat((hex >> 16) & 0xFF), g: CGFloat((hex >> 8) & 0xFF), b: CGFloat(hex & 0xFF))
        var rgb: UInt32 = 0
        Scanner(string: hex).scanHexInt32(&rgb)
        print("in", rgb)
        return UIColor.rgb(CGFloat((rgb & 0xFF0000) >> 16), CGFloat((rgb & 0x00FF00) >> 8), CGFloat(rgb & 0x0000FF))
    }
    
    
}
