//
//  DividerLineView.swift
//  ShopApp
//
//  Created by Nguyễn Đức Huy on 8/8/19.
//  Copyright © 2019 Nguyễn Đức Huy. All rights reserved.
//

import UIKit

class DividerLineView: UIView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.init(white: 0.7, alpha: 1)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
