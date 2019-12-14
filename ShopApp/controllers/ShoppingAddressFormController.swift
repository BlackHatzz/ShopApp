//
//  ShoppingAddressFormController.swift
//  ShopApp
//
//  Created by Nguyễn Đức Huy on 12/13/19.
//  Copyright © 2019 Nguyễn Đức Huy. All rights reserved.
//

import UIKit

class ShoppingAddressFormController: UIViewController {
    let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.alwaysBounceVertical = true
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.showsVerticalScrollIndicator = true
        return scrollView
    }()
    let containerView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.clear
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let firstNameField = InputInfoField(title: "First Name")
    let lastNameField = InputInfoField(title: "Last Name")
    let addressField = InputInfoField(title: "Address")
    let cityField = InputInfoField(title: "City")
    let stateField = InputInfoField(title: "County/State/Province")
    let phoneField = InputInfoField(title: "Mobile Phone Number")
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white
        
        setupNavbar()
        setupViews()
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(
            target: self,
            action: #selector(dismissKeyboard))
        
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
        
        // add event to textfield
        firstNameField.textField.addTarget(self, action: #selector(textFieldEditingDidEnd(_:)), for: UIControl.Event.editingDidEnd)
        firstNameField.textField.addTarget(self, action: #selector(textFieldEditingDidBegin(_:)), for: UIControl.Event.editingDidBegin)
        
        lastNameField.textField.addTarget(self, action: #selector(textFieldEditingDidEnd(_:)), for: UIControl.Event.editingDidEnd)
        lastNameField.textField.addTarget(self, action: #selector(textFieldEditingDidBegin(_:)), for: UIControl.Event.editingDidBegin)
        
        addressField.textField.addTarget(self, action: #selector(textFieldEditingDidEnd(_:)), for: UIControl.Event.editingDidEnd)
        addressField.textField.addTarget(self, action: #selector(textFieldEditingDidBegin(_:)), for: UIControl.Event.editingDidBegin)
        
        cityField.textField.addTarget(self, action: #selector(textFieldEditingDidEnd(_:)), for: UIControl.Event.editingDidEnd)
        cityField.textField.addTarget(self, action: #selector(textFieldEditingDidBegin(_:)), for: UIControl.Event.editingDidBegin)
        
        stateField.textField.addTarget(self, action: #selector(textFieldEditingDidEnd(_:)), for: UIControl.Event.editingDidEnd)
        stateField.textField.addTarget(self, action: #selector(textFieldEditingDidBegin(_:)), for: UIControl.Event.editingDidBegin)
        
        phoneField.textField.addTarget(self, action: #selector(textFieldEditingDidEnd(_:)), for: UIControl.Event.editingDidEnd)
        phoneField.textField.addTarget(self, action: #selector(textFieldEditingDidBegin(_:)), for: UIControl.Event.editingDidBegin)
    }
    
    private func setupNavbar() {
        navigationItem.title = "Shopping Address"
        
        navigationItem.hidesBackButton = false
        
        
        let backButton = UIBarButtonItem(title: "Back", style: UIBarButtonItem.Style.plain, target: self, action: #selector(handleBackButton))
        
        navigationItem.leftBarButtonItem = backButton
    }
    
    @objc func handleBackButton() {
        self.navigationController?.dismissPushViewControllerFromLeft()
    }
    
    private func setupViews() {
        firstNameField.translatesAutoresizingMaskIntoConstraints = false
        lastNameField.translatesAutoresizingMaskIntoConstraints = false
        addressField.translatesAutoresizingMaskIntoConstraints = false
        cityField.translatesAutoresizingMaskIntoConstraints = false
        stateField.translatesAutoresizingMaskIntoConstraints = false
        phoneField.translatesAutoresizingMaskIntoConstraints = false
        
        // set up scrollView
        view.addSubview(scrollView)
        
        scrollView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        scrollView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        scrollView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        
        // setup containerView
        scrollView.addSubview(containerView)
        
        containerView.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 12).isActive = true
        containerView.leftAnchor.constraint(equalTo: scrollView.leftAnchor, constant: 8).isActive = true
        containerView.widthAnchor.constraint(equalToConstant: view.frame.width - 16).isActive = true
        containerView.heightAnchor.constraint(equalToConstant: view.frame.width - 12).isActive = true
        
        // setup views in containerView
        containerView.addSubview(firstNameField)
        containerView.addSubview(lastNameField)
        containerView.addSubview(addressField)
        containerView.addSubview(cityField)
        containerView.addSubview(stateField)
        containerView.addSubview(phoneField)
        
        firstNameField.topAnchor.constraint(equalTo: containerView.topAnchor).isActive = true
        firstNameField.leftAnchor.constraint(equalTo: containerView.leftAnchor).isActive = true
        firstNameField.rightAnchor.constraint(equalTo: containerView.rightAnchor).isActive = true
        firstNameField.heightAnchor.constraint(equalToConstant: 70).isActive = true
        
        lastNameField.topAnchor.constraint(equalTo: firstNameField.bottomAnchor, constant: 12).isActive = true
        lastNameField.leftAnchor.constraint(equalTo: containerView.leftAnchor).isActive = true
        lastNameField.rightAnchor.constraint(equalTo: containerView.rightAnchor).isActive = true
        lastNameField.heightAnchor.constraint(equalToConstant: 70).isActive = true

        addressField.topAnchor.constraint(equalTo: lastNameField.bottomAnchor, constant: 12).isActive = true
        addressField.leftAnchor.constraint(equalTo: containerView.leftAnchor).isActive = true
        addressField.rightAnchor.constraint(equalTo: containerView.rightAnchor).isActive = true
        addressField.heightAnchor.constraint(equalToConstant: 70).isActive = true
        
        cityField.topAnchor.constraint(equalTo: addressField.bottomAnchor, constant: 12).isActive = true
        cityField.leftAnchor.constraint(equalTo: containerView.leftAnchor).isActive = true
        cityField.rightAnchor.constraint(equalTo: containerView.rightAnchor).isActive = true
        cityField.heightAnchor.constraint(equalToConstant: 70).isActive = true
        
        stateField.topAnchor.constraint(equalTo: cityField.bottomAnchor, constant: 12).isActive = true
        stateField.leftAnchor.constraint(equalTo: containerView.leftAnchor).isActive = true
        stateField.rightAnchor.constraint(equalTo: containerView.rightAnchor).isActive = true
        stateField.heightAnchor.constraint(equalToConstant: 70).isActive = true
        
        phoneField.topAnchor.constraint(equalTo: stateField.bottomAnchor, constant: 12).isActive = true
        phoneField.leftAnchor.constraint(equalTo: containerView.leftAnchor).isActive = true
        phoneField.rightAnchor.constraint(equalTo: containerView.rightAnchor).isActive = true
        phoneField.heightAnchor.constraint(equalToConstant: 70).isActive = true
    }
    
    @objc private func dismissKeyboard() {
        view.endEditing(true)
    }
    
    @objc private func textFieldEditingDidEnd(_ sender: UITextField) {
        print("sender", sender.text as Any)
        guard let superView = sender.superview?.superview as? InputInfoField else { return }
        guard let text = sender.text else { return }
        if text.isEmpty {
            superView.status = .invalid
        } else {
            superView.status = .default
        }
    }
    @objc private func textFieldEditingDidBegin(_ sender: UITextField) {
        print("begin")
        guard let superView = sender.superview?.superview as? InputInfoField else { return }
        superView.status = .focus
    }
    
}
