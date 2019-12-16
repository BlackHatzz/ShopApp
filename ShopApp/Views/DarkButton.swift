//
//  DarkButton.swift
//  ShopApp
//
//  Created by Nguyễn Đức Huy on 12/16/19.
//  Copyright © 2019 Nguyễn Đức Huy. All rights reserved.
//

import UIKit.UIButton

class DarkButton: UIButton {
    enum Style {
        case active
        case inactive
    }
    
    var style: Style
    
    init(title: String?, style: Style) {
        self.style = style
        super.init(frame: CGRect.zero)
        setup()
        setTitle(title, for: UIControl.State.normal)
        switch self.style {
        case .active:
            setTitleColor(UIColor.white, for: UIControl.State.normal)
            backgroundColor = UIColor.black
        case .inactive:
            setTitleColor(UIColor(white: 0.5, alpha: 1), for: UIControl.State.normal)
            backgroundColor = UIColor(white: 0.875, alpha: 1)
        }
    }
    
    private func setup() {
        setTitleColor(UIColor(white: 0.7, alpha: 1), for: UIControl.State.normal)
        titleLabel?.font = UIFont.helvetica(ofsize: 14)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
