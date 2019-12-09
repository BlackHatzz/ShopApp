//
//  LoadingView.swift
//  ShopApp
//
//  Created by Nguyễn Đức Huy on 8/25/19.
//  Copyright © 2019 Nguyễn Đức Huy. All rights reserved.
//

import UIKit
import Foundation.NSTimer

class NotificationView: UIView {
    var activityIndicatorView: UIActivityIndicatorView! = nil
    var checkedImageView: UIImageView! = nil
    
    let label: UILabel = {
        let label = UILabel()
        label.font = UIFont.helveticaLight(ofsize: 14)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
//    private var timer: Timer = Timer()
    override func didMoveToSuperview() {
        super.didMoveToSuperview()
        self.frame = CGRect(x: 0, y: 0, width: 125, height: 125)
        if let superview = self.superview {
            self.center = superview.center
            if notiType == .checked {
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
    @objc func removeView() {
        
    }
    
    enum NotiType {
        case loading
        case checked
        case none
    }
    private var notiType: NotiType = NotiType.none
    
    convenience init(title: String?, type: NotiType) {
        self.init(frame: CGRect.zero)
        self.notiType = type
        self.layer.zPosition = 100
        self.backgroundColor = UIColor(white: 0.9, alpha: 1)
        self.layer.cornerRadius = 4
        
        label.text = title
        
        switch type {
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
        case .none:
            assertionFailure()
        }
        
        self.addSubview(label)
        label.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -12).isActive = true
        label.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        label.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
        label.heightAnchor.constraint(equalToConstant: 18).isActive = true
        
        
    }
}
