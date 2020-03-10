//
//  RadioButton.swift
//  ShopApp
//
//  Created by Nguyễn Đức Huy on 3/9/20.
//  Copyright © 2020 Nguyễn Đức Huy. All rights reserved.
//

import UIKit

class RadioButton: UIButton {
    override func didMoveToSuperview() {
        super.didMoveToSuperview()
        DispatchQueue.main.async {
            self.superview?.setNeedsDisplay()
            self.setNeedsDisplay()
            self.outsideView.layer.cornerRadius = self.outsideView.frame.height / 2
            self.insideView.layer.cornerRadius = self.insideView.frame.height / 2
        }
    }
    
    enum State {
        case selected
        case unselected
    }
    
    var radioState = State.unselected {
        didSet {
            if radioState == .selected {
                self.insideView.isHidden = false
            } else {
                self.insideView.isHidden = true
            }
        }
    }
    
    let outsideView: UIView = {
        let view = UIView()
        view.isUserInteractionEnabled = false
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor.black
        return view
    }()
    
    let insideView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.isUserInteractionEnabled = false
        view.backgroundColor = UIColor.white
        view.isHidden = true
        view.layer.zPosition = 1
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        // setupViews
        addSubview(outsideView)
        
        outsideView.topAnchor.constraint(equalTo: self.topAnchor, constant: 4).isActive = true
        outsideView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 4).isActive = true
        outsideView.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -4).isActive = true
        outsideView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -4).isActive = true
        
        outsideView.addSubview(insideView)
        
        insideView.topAnchor.constraint(equalTo: outsideView.topAnchor, constant: 8).isActive = true
        insideView.leftAnchor.constraint(equalTo: outsideView.leftAnchor, constant: 8).isActive = true
        insideView.rightAnchor.constraint(equalTo: outsideView.rightAnchor, constant: -8).isActive = true
        insideView.bottomAnchor.constraint(equalTo: outsideView.bottomAnchor, constant: -8).isActive = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
