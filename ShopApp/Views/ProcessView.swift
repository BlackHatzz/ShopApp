//
//  LoadingView.swift
//  ShopApp
//
//  Created by Nguyễn Đức Huy on 8/25/19.
//  Copyright © 2019 Nguyễn Đức Huy. All rights reserved.
//

import UIKit
import Foundation.NSTimer

class ProcessView: UIView {
    var activityIndicatorView: UIActivityIndicatorView! = nil
    var checkedImageView: UIImageView! = nil
    
    let label: UILabel = {
        let label = UILabel()
        label.font = UIFont.helveticaLight(ofsize: 14)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override func didMoveToSuperview() {
        super.didMoveToSuperview()
        self.frame = CGRect(x: 0, y: 0, width: 125, height: 125)
    
        if let superview = self.superview {
            self.center = CGPoint(x: superview.center.x, y: superview.center.y - 25)
            if self.notiType == .checked {
                DispatchQueue.main.async {
                    UIView.animate(withDuration: 1.5, animations: {
                        self.alpha = 0.0
                    }) { (_) in
                        self.removeFromSuperview()
                    }
                }
            }
        }
    }
    
    enum NotiType {
        case loading
        case checked
    }
    private var notiType: NotiType
    
    init(title: String?, type: NotiType) {
        self.notiType = type
        super.init(frame: CGRect.zero)
        
        self.layer.zPosition = 100
        self.backgroundColor = UIColor(white: 0.9, alpha: 1)
        self.layer.cornerRadius = 4
        self.isUserInteractionEnabled = false
        
        label.text = title
        
        setupViews()
    }
    
    private func setupViews() {
        switch notiType {
        case .loading:
            activityIndicatorView = UIActivityIndicatorView(style: UIActivityIndicatorView.Style.whiteLarge)
            activityIndicatorView.color = UIColor.black
            activityIndicatorView.translatesAutoresizingMaskIntoConstraints = false
            
            self.addSubview(activityIndicatorView)
            activityIndicatorView.centerXAnchor.constraint(equalTo: self.centerXAnchor, constant: 0).isActive = true
            activityIndicatorView.centerYAnchor.constraint(equalTo: self.centerYAnchor, constant: -10).isActive = true
            activityIndicatorView.widthAnchor.constraint(equalToConstant: 50).isActive = true
            activityIndicatorView.heightAnchor.constraint(equalToConstant: 50).isActive = true
            
            activityIndicatorView.startAnimating()
        case .checked:
            checkedImageView = UIImageView()
            checkedImageView.image = UIImage(named: "check-symbol")?.withRenderingMode(UIImage.RenderingMode.alwaysTemplate)
            checkedImageView.contentMode = UIView.ContentMode.scaleAspectFill
            checkedImageView.tintColor = UIColor.init(white: 0.5, alpha: 1)
            checkedImageView.translatesAutoresizingMaskIntoConstraints = false
            
            self.addSubview(checkedImageView)
            checkedImageView.centerXAnchor.constraint(equalTo: self.centerXAnchor, constant: 0).isActive = true
            checkedImageView.centerYAnchor.constraint(equalTo: self.centerYAnchor, constant: -10).isActive = true
            checkedImageView.widthAnchor.constraint(equalToConstant: 50).isActive = true
            checkedImageView.heightAnchor.constraint(equalToConstant: 50).isActive = true
        }
        
        self.addSubview(label)
        label.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -12).isActive = true
        label.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        label.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
        label.heightAnchor.constraint(equalToConstant: 18).isActive = true
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
