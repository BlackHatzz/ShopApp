//
//  VerificationView.swift
//  ShopApp
//
//  Created by Nguyễn Đức Huy on 12/14/19.
//  Copyright © 2019 Nguyễn Đức Huy. All rights reserved.
//

import UIKit

class VerificationView: UIView {
    
    let handlerButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitleColor(UIColor(white: 0.7, alpha: 1), for: UIControl.State.normal)
        button.titleLabel?.font = UIFont.helvetica(ofsize: 14)
        button.backgroundColor = UIColor(white: 0.9, alpha: 1)
        return button
    }()
    
    enum Style {
        case active
        case inactive
    }
    
    var style: Style
    
    init(withTitle title: String?, style: Style) {
        self.style = style
        super.init(frame: CGRect.zero)
        backgroundColor = UIColor.white
        layer.zPosition = 10
        handlerButton.setTitle(title, for: UIControl.State.normal)
        
        switch self.style {
        case .active:
            handlerButton.setTitleColor(UIColor.white, for: UIControl.State.normal)
            handlerButton.backgroundColor = UIColor.black
        case .inactive:
            handlerButton.setTitleColor(UIColor(white: 0.5, alpha: 1), for: UIControl.State.normal)
            handlerButton.backgroundColor = UIColor(white: 0.875, alpha: 1)
        }
        
        setupViews()
    }
    
    private func setupViews() {
        addSubview(handlerButton)
        
        handlerButton.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        handlerButton.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        handlerButton.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0.9).isActive = true
        handlerButton.heightAnchor.constraint(equalToConstant: 44).isActive = true
        
        layer.shadowColor = UIColor.gray.cgColor
        layer.shadowOpacity = 1
        layer.shadowOffset = .zero
        layer.shadowRadius = 10
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}
