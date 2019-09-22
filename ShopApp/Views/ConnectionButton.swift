//
//  ConnectionButton.swift
//  ShopApp
//
//  Created by Nguyễn Đức Huy on 8/8/19.
//  Copyright © 2019 Nguyễn Đức Huy. All rights reserved.
//

import UIKit

class ConnectionButton: UIButton {
    
    let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.alignment = .center
        stackView.spacing = 4
        stackView.axis = .vertical
        stackView.isUserInteractionEnabled = false
        return stackView
    }()
    
    let iconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    let label: UILabel = {
        let label = UILabel()
        label.font = UIFont.helveticaNeue(ofsize: 14)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    init() {
        super.init(frame: CGRect.zero)
        stackView.addArrangedSubview(iconImageView)
        stackView.addArrangedSubview(label)
        
        iconImageView.heightAnchor.constraint(equalTo: stackView.heightAnchor, multiplier: 0.45).isActive = true
        iconImageView.widthAnchor.constraint(equalTo: iconImageView.heightAnchor).isActive = true
//        label.heightAnchor.constraint(equalTo: stackView.heightAnchor, multiplier: 0.45).isActive = true
        label.widthAnchor.constraint(equalTo: stackView.widthAnchor).isActive = true
        
        addSubview(stackView)
        
        stackView.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        stackView.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        stackView.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0.7).isActive = true
        stackView.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: 0.7).isActive = true
    }
    
    convenience init(image: UIImage?, labelText: String) {
        self.init()
        iconImageView.image = image
        label.text = labelText
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
