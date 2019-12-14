//
//  InputInfoField.swift
//  ShopApp
//
//  Created by Nguyễn Đức Huy on 12/13/19.
//  Copyright © 2019 Nguyễn Đức Huy. All rights reserved.
//

import UIKit

class InputInfoField: UIView {
    let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 14, weight: .semibold)
        label.backgroundColor = UIColor.clear
        return label
    }()
    
    let inputContainerView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.clear
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.borderWidth = 1
        view.layer.borderColor = UIColor(white: 0.75, alpha: 1).cgColor
        view.layer.masksToBounds = true
        return view
    }()
    
    let textField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.backgroundColor = UIColor.clear
        textField.font = UIFont.helvetica(ofsize: 14)
        return textField
    }()
    
    let notificationLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.backgroundColor = UIColor.clear
        label.font = UIFont.helvetica(ofsize: 13)
        label.textColor = UIColor.rgb(255, 110, 120)
        return label
    }()
    
    enum Status {
        case `default`
        case invalid
        case focus
    }
    
    var status = Status.default {
        didSet {
            switch status {
            case .default:
                let caAnimation = CABasicAnimation(keyPath: "borderColor")
                caAnimation.fromValue = inputContainerView.layer.borderColor
                caAnimation.toValue = UIColor(white: 0.75, alpha: 1).cgColor
                caAnimation.duration = 0.1
                caAnimation.repeatCount = 1
                inputContainerView.layer.add(caAnimation, forKey: "borderColor")
                inputContainerView.layer.borderColor = UIColor(white: 0.75, alpha: 1).cgColor
                
                notificationLabel.text = nil
            case .focus:
                let caAnimation = CABasicAnimation(keyPath: "borderColor")
                caAnimation.fromValue = inputContainerView.layer.borderColor
                caAnimation.toValue = UIColor(white: 0.1, alpha: 1).cgColor
                caAnimation.duration = 0.1
                caAnimation.repeatCount = 1
                inputContainerView.layer.add(caAnimation, forKey: "borderColor")
                inputContainerView.layer.borderColor = UIColor(white: 0.1, alpha: 1).cgColor
            case .invalid:
                let caAnimation = CABasicAnimation(keyPath: "borderColor")
                caAnimation.fromValue = inputContainerView.layer.borderColor
                caAnimation.toValue = UIColor.rgb(255, 110, 120).cgColor
                caAnimation.duration = 0.1
                caAnimation.repeatCount = 1
                inputContainerView.layer.add(caAnimation, forKey: "borderColor")
                inputContainerView.layer.borderColor = UIColor.rgb(255, 110, 120).cgColor
                
                notificationLabel.text = "The \(titleLabel.text ?? "") field is required"
            }
        }
    }
    
    init(title: String?) {
        titleLabel.text = title
        
        
        super.init(frame: CGRect.zero)
        
        addSubview(titleLabel)
        addSubview(inputContainerView)
        addSubview(notificationLabel)
        inputContainerView.addSubview(textField)
        
        titleLabel.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        titleLabel.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        titleLabel.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
        titleLabel.heightAnchor.constraint(equalToConstant: 18).isActive = true
        
        inputContainerView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 4).isActive = true
        inputContainerView.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        inputContainerView.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
        inputContainerView.bottomAnchor.constraint(equalTo: notificationLabel.topAnchor, constant: -8).isActive = true
        
        
        textField.topAnchor.constraint(equalTo: inputContainerView.topAnchor).isActive = true
        textField.leftAnchor.constraint(equalTo: inputContainerView.leftAnchor, constant: 12).isActive = true
        textField.rightAnchor.constraint(equalTo: inputContainerView.rightAnchor, constant: -12).isActive = true
        textField.bottomAnchor.constraint(equalTo: inputContainerView.bottomAnchor).isActive = true
        
        notificationLabel.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        notificationLabel.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
        notificationLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        notificationLabel.heightAnchor.constraint(equalToConstant: 20).isActive = true
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
