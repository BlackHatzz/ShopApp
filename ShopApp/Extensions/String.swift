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
}
