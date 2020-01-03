//
//  BagButton.swift
//  ShopApp
//
//  Created by Nguyễn Đức Huy on 1/3/20.
//  Copyright © 2020 Nguyễn Đức Huy. All rights reserved.
//

import UIKit

class ShoppingBagButton: UIButton {
    
    let iconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "shopping-bag")?.withRenderingMode(UIImage.RenderingMode.alwaysOriginal)
        imageView.isUserInteractionEnabled = false
        return imageView
    }()
    
    let quantityLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12, weight: UIFont.Weight.heavy)
        label.textColor = UIColor.white
        label.textAlignment = NSTextAlignment.center
        label.layer.zPosition = 1
        return label
    }()
    
    override init(frame: CGRect = CGRect.zero) {
        super.init(frame: frame)
        addSubview(iconImageView)
        addSubview(quantityLabel)
        
        iconImageView.frame = CGRect(x: 0, y: 5, width: 30, height: 25)
        quantityLabel.frame = CGRect(x: 0, y: 11, width: 30, height: 20)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
