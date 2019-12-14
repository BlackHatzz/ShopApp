//
//  TransactionLabel.swift
//  ShopApp
//
//  Created by Nguyễn Đức Huy on 12/13/19.
//  Copyright © 2019 Nguyễn Đức Huy. All rights reserved.
//

import UIKit

class TransactionLabel: UILabel {
    
    enum Style {
        case tick
        case done
        case `default`
    }
    
    var style: Style {
        didSet {
            print("didset")
            switch self.style {
            case .default:
                layer.borderWidth = 1
                layer.borderColor = UIColor.black.cgColor
                layer.masksToBounds = true
                print("it's default")
            case .done:
                layer.borderWidth = 0
                layer.masksToBounds = true
                backgroundColor = UIColor.rgb(115, 201, 132)
                textColor = UIColor.white
            case .tick:
                assertionFailure()
            }
        }
    }
    
    init(style: Style) {
        self.style = style
        super.init(frame: CGRect.zero)
        
        switch self.style {
        case .default:
            layer.borderWidth = 1
            layer.borderColor = UIColor.black.cgColor
            layer.masksToBounds = true
        case .done:
            layer.borderWidth = 0
            layer.masksToBounds = false
            backgroundColor = UIColor.rgb(115, 201, 132)
            textColor = UIColor.white
        case .tick:
            assertionFailure()
        }
        
        translatesAutoresizingMaskIntoConstraints = false
        font = UIFont.systemFont(ofSize: 14)
        textAlignment = NSTextAlignment.center
        
    }
    
    override func didMoveToSuperview() {
        super.didMoveToSuperview()
        print("frame", frame)
        DispatchQueue.main.async {
            self.setNeedsDisplay()
            self.layer.cornerRadius = self.frame.width / 2
        }
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
