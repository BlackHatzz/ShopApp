//
//  String.swift
//  ShopApp
//
//  Created by Nguyễn Đức Huy on 12/20/19.
//  Copyright © 2019 Nguyễn Đức Huy. All rights reserved.
//

import Foundation

extension String {
    func isValidEmail() -> Bool {
        let emailStr = self
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        
        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: emailStr)
    }
    func isValidPhoneNumber() -> Bool {
        if self.count != 10 && self.count != 11 { return false }
        
        let digitsSet: Set<Character> = ["0", "1", "2", "3", "4", "5", "6", "7", "8", "9"]
        for i in self {
            if !digitsSet.contains(i) { return false }
        }
        
        return true
    }
}
