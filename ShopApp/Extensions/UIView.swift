//
//  UIView.swift
//  ShopApp
//
//  Created by Nguyễn Đức Huy on 7/16/19.
//  Copyright © 2019 Nguyễn Đức Huy. All rights reserved.
//

import UIKit

extension UIView {
    
    func removeAllSubviews() {
        self.subviews.forEach { (subview) in
            subview.removeFromSuperview()
        }
    }
    
    func addConstraints(withFormat format: String, views: UIView...) {
        var viewsDictionary = [String: UIView]()
        for (index, view) in views.enumerated() {
            viewsDictionary["v\(index)"] = view
            view.translatesAutoresizingMaskIntoConstraints = false
        }
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: format, options: NSLayoutConstraint.FormatOptions(), metrics: nil, views: viewsDictionary))
    }
    func addConstraints(withFormat format: String, options: NSLayoutConstraint.FormatOptions, views: UIView...) {
        var viewsDictionary = [String: UIView]()
        for (index, view) in views.enumerated() {
            viewsDictionary["v\(index)"] = view
            view.translatesAutoresizingMaskIntoConstraints = false
        }
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: format, options: options, metrics: nil, views: viewsDictionary))
        
    }
    
    
    enum Direction {
        case horizontal
        case vertical
        case all
    }
    
    func autoResize(direction: Direction) {
        var contentSize = CGRect.zero
        
        switch direction {
        case .horizontal:
            for view in self.subviews {
                contentSize.size.width += view.frame.width
            }
        case .vertical:
            for view in self.subviews {
                contentSize.size.height += view.frame.height
            }
        case .all:
            for view in self.subviews {
                contentSize = contentSize.union(view.frame)
            }
        }
        print("contentSize:", contentSize)
        self.frame = contentSize
    }
}
