//
//  VerificationView.swift
//  ShopApp
//
//  Created by Nguyễn Đức Huy on 12/14/19.
//  Copyright © 2019 Nguyễn Đức Huy. All rights reserved.
//

import UIKit

class VerificationView: UIView {
    
    let handlerButton: DarkButton
    
    init(withTitle title: String?, style: DarkButton.Style) {
        self.handlerButton = DarkButton(title: title, style: style)
        super.init(frame: CGRect.zero)
        backgroundColor = UIColor.white
        layer.zPosition = 10
        handlerButton.setTitle(title, for: UIControl.State.normal)
        handlerButton.translatesAutoresizingMaskIntoConstraints = false
        
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
