//
//  CGSize.swift
//  ShopApp
//
//  Created by Nguyễn Đức Huy on 9/1/19.
//  Copyright © 2019 Nguyễn Đức Huy. All rights reserved.
//

import UIKit

extension CGSize {
    static func +(_ lhs: CGSize, _ rhs: CGSize) -> CGSize {
        return CGSize(width: lhs.width + rhs.width, height: lhs.height + rhs.height)
    }
    static func -(_ lhs: CGSize, _ rhs: CGSize) -> CGSize {
        return CGSize(width: lhs.width - rhs.width, height: lhs.height - rhs.height)
    }
}
