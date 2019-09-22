//
//  LoadingView.swift
//  ShopApp
//
//  Created by Nguyễn Đức Huy on 8/25/19.
//  Copyright © 2019 Nguyễn Đức Huy. All rights reserved.
//

import UIKit

class LoadingView: UIView {
    
    let activityIndicatorView: UIActivityIndicatorView = {
        let view = UIActivityIndicatorView(style: UIActivityIndicatorView.Style.whiteLarge)
        view.color = UIColor.black
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    let label: UILabel = {
        let label = UILabel()
        label.text = "Loading"
        label.font = UIFont.helveticaLight(ofsize: 14)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    convenience init() {
        self.init(frame: CGRect.zero)
        self.backgroundColor = UIColor(white: 0.9, alpha: 1)
        self.layer.cornerRadius = 4
        
        self.addSubview(activityIndicatorView)
        self.addSubview(label)
        
        activityIndicatorView.centerXAnchor.constraint(equalTo: self.centerXAnchor, constant: 0).isActive = true
        activityIndicatorView.centerYAnchor.constraint(equalTo: self.centerYAnchor, constant: -10).isActive = true
        activityIndicatorView.widthAnchor.constraint(equalToConstant: 50).isActive = true
        activityIndicatorView.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        label.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        label.topAnchor.constraint(equalTo: activityIndicatorView.bottomAnchor, constant: 4).isActive = true
        label.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0.9).isActive = true
        label.heightAnchor.constraint(equalToConstant: 18).isActive = true
        
        activityIndicatorView.startAnimating()
    }
}
