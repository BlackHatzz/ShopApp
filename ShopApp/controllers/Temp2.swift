//
//  Temp2.swift
//  ShopApp
//
//  Created by Nguyễn Đức Huy on 1/3/20.
//  Copyright © 2020 Nguyễn Đức Huy. All rights reserved.
//

import UIKit

class Temp2: UIViewController {
    let leftContainerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor.blue
        return view
    }()
    let rightContainerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor.green
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(leftContainerView)
        view.addSubview(rightContainerView)
        
        leftContainerView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        leftContainerView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        leftContainerView.widthAnchor.constraint(equalToConstant: 50).isActive = true
        leftContainerView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        
        rightContainerView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        rightContainerView.leftAnchor.constraint(equalTo: leftContainerView.rightAnchor).isActive = true
        rightContainerView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        rightContainerView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
    }
}
