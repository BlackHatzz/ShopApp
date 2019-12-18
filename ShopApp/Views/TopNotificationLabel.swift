//
//  NotificationLabel.swift
//  ShopApp
//
//  Created by Nguyễn Đức Huy on 12/17/19.
//  Copyright © 2019 Nguyễn Đức Huy. All rights reserved.
//

import UIKit

class TopNotificationLabel: UILabel {
    
    enum Status {
        case hide
        case show
    }
    
    var status = Status.hide {
        didSet {
            switch status {
            case .hide:
                
                UIView.animate(withDuration: 0.25, animations: {
                    self.heightLayoutConstraint.constant = 1
                    self.superview?.layoutIfNeeded()
                }) { (_) in
                    self.isHidden = true
                    self.text = nil
                }
                
            case .show:
                isHidden = false
                UIView.animate(withDuration: 0.25, animations: {
                    self.heightLayoutConstraint.constant = 40
                    self.superview?.layoutIfNeeded()
                }) { (_) in
                    // completion
                }
                
            }
        }
    }
    
    var heightLayoutConstraint: NSLayoutConstraint!
    
    override func didMoveToSuperview() {
        super.didMoveToSuperview()
        
        if let superview = superview {
            self.topAnchor.constraint(equalTo: superview.topAnchor).isActive = true
            self.leftAnchor.constraint(equalTo: superview.leftAnchor).isActive = true
            self.rightAnchor.constraint(equalTo: superview.rightAnchor).isActive = true
            heightLayoutConstraint = self.heightAnchor.constraint(equalToConstant: 1)
            heightLayoutConstraint.isActive = true
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        isUserInteractionEnabled = true
        textAlignment = NSTextAlignment.center
        backgroundColor = UIColor.rgb(249, 214, 214)
        font = UIFont.helvetica(ofsize: 14)
        isHidden = true
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleTapGesture))
        tap.cancelsTouchesInView = false
        addGestureRecognizer(tap)
        
    }
    
    @objc private func handleTapGesture() {
        self.status = .hide
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}
