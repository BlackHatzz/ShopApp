//
//  CartViewController.swift
//  ShopApp
//
//  Created by Nguyễn Đức Huy on 7/16/19.
//  Copyright © 2019 Nguyễn Đức Huy. All rights reserved.
//

import UIKit

class CartViewController: UIViewController {
    let tempView = UIView()
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.green
        
        view.addSubview(tempView)
        tempView.translatesAutoresizingMaskIntoConstraints = false
        tempView.backgroundColor = UIColor.blue
        
        view.addConstraints(withFormat: "H:|[v0]|", views: tempView)
        view.addConstraints(withFormat: "V:|-20-[v0]-20-|", views: tempView)
        
//        tempView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
//        tempView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
//        tempView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 100).isActive = true
//        tempView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -400).isActive = true
    
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        view.setNeedsLayout()
        tempView.setNeedsLayout()
        tempView.setNeedsUpdateConstraints()
        print("temp view")
        tempView.tag = 1
        //        case left 1
        //        case right 2
        //        case top 3
        //        case bottom 4
        //        case leading 5
        //        case trailing 6
        //        case width 7
        //        case height 8
        //        case centerX 9
        //        case centerY 10
        //        case lastBaseline 11
        
        
        
    }

}

