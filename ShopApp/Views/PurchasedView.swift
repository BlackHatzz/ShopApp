//
//  PurchasedView.swift
//  ShopApp
//
//  Created by Nguyễn Đức Huy on 1/4/20.
//  Copyright © 2020 Nguyễn Đức Huy. All rights reserved.
//

import UIKit

class PurchasedView: UIView {
    let containerView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.white
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 4
        view.layer.masksToBounds = true
        return view
    }()
    
    let checkedImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = UIImage(named: "checked")
        imageView.backgroundColor = UIColor.clear
        return imageView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor(white: 0.1, alpha: 0.6)
        layer.zPosition = 99
        addSubview(containerView)
        
    }
    
    override func didMoveToSuperview() {
        super.didMoveToSuperview()
        DispatchQueue.main.async {
            self.setNeedsDisplay()
            self.containerView.setNeedsDisplay()
            self.frame = self.superview!.bounds
            self.containerView.frame = CGRect(x: 0, y: 0, width: 280, height: 320)
            self.containerView.center = self.superview!.center
            self.setupViews()
        }
    }
    
    private func setupViews() {
        containerView.addSubview(checkedImageView)
        
        checkedImageView.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 12).isActive = true
        checkedImageView.centerXAnchor.constraint(equalTo: containerView.centerXAnchor).isActive = true
        checkedImageView.widthAnchor.constraint(equalToConstant: 50).isActive = true
        checkedImageView.heightAnchor.constraint(equalToConstant: 50).isActive = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
