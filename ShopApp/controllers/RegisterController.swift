//
//  RegisterController.swift
//  ShopApp
//
//  Created by Nguyễn Đức Huy on 12/17/19.
//  Copyright © 2019 Nguyễn Đức Huy. All rights reserved.
//

import UIKit
import Foundation

class RegisterController: UIViewController {
    
    let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.showsVerticalScrollIndicator = false
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.alwaysBounceVertical = true
        scrollView.backgroundColor = UIColor.white
        return scrollView
    }()
    
    let containerFormView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor.clear
        return view
    }()
    
    let firstnameField = FieldCheckerView(title: "Enter firstname", style: .default)
    let fullnameField = FieldCheckerView(title: "Enter fullname", style: .default)
    let emailField = FieldCheckerView(title: "Enter email", style: .default)
    let passwordField = FieldCheckerView(title: "Enter password", style: .default)
    let confirmPasswordField = FieldCheckerView(title: "Enter confirm password", style: .default)
    
    private var activeTextField: UITextField? = nil
    
    let registerButton = DarkButton(title: "Register", style: .active)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white
        
        // setup
        setupNavbar()
        setupViews()
        setupObserver()
        setupEvent()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        DispatchQueue.main.async {
            self.view.setNeedsDisplay()
            self.containerFormView.setNeedsDisplay()
            
            var contentSizeHeight: CGFloat = 0
            
            for subview in self.containerFormView.subviews {
                contentSizeHeight += subview.frame.height + 24
            }
            
            self.scrollView.contentSize.height = contentSizeHeight
            print("contentsize", self.containerFormView.frame.height, contentSizeHeight)
        }
    }
    
    private func setupNavbar() {
        let cancelButton = UIBarButtonItem(title: "\u{2715}", style: UIBarButtonItem.Style.plain, target: self, action: #selector(handleCancelButton))
        
        navigationItem.rightBarButtonItem = cancelButton
    }
    
    var scrollViewHeightConstraint: NSLayoutConstraint! = nil
    
    private func setupViews() {
        firstnameField.translatesAutoresizingMaskIntoConstraints = false
        fullnameField.translatesAutoresizingMaskIntoConstraints = false
        emailField.translatesAutoresizingMaskIntoConstraints = false
        passwordField.translatesAutoresizingMaskIntoConstraints = false
        confirmPasswordField.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(scrollView)
        
        scrollView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        scrollView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        scrollView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        scrollViewHeightConstraint = scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        scrollViewHeightConstraint.isActive = true
        
        scrollView.addSubview(containerFormView)
        
        containerFormView.topAnchor.constraint(equalTo: scrollView.topAnchor).isActive = true
        containerFormView.leftAnchor.constraint(equalTo: scrollView.leftAnchor).isActive = true
        containerFormView.widthAnchor.constraint(equalToConstant: view.frame.width).isActive = true
        containerFormView.heightAnchor.constraint(equalToConstant: 1000).isActive = true
        
        containerFormView.addSubview(firstnameField)
        containerFormView.addSubview(fullnameField)
        containerFormView.addSubview(emailField)
        containerFormView.addSubview(passwordField)
        containerFormView.addSubview(confirmPasswordField)
        
        firstnameField.topAnchor.constraint(equalTo: containerFormView.topAnchor, constant: 12).isActive = true
        firstnameField.leftAnchor.constraint(equalTo: containerFormView.leftAnchor, constant: 12).isActive = true
        firstnameField.rightAnchor.constraint(equalTo: containerFormView.rightAnchor, constant: -12).isActive = true
        firstnameField.heightAnchor.constraint(equalToConstant: 70).isActive = true
        
        fullnameField.topAnchor.constraint(equalTo: firstnameField.bottomAnchor, constant: 12).isActive = true
        fullnameField.leftAnchor.constraint(equalTo: containerFormView.leftAnchor, constant: 12).isActive = true
        fullnameField.rightAnchor.constraint(equalTo: containerFormView.rightAnchor, constant: -12).isActive = true
        fullnameField.heightAnchor.constraint(equalToConstant: 70).isActive = true
        
        emailField.topAnchor.constraint(equalTo: fullnameField.bottomAnchor, constant: 12).isActive = true
        emailField.leftAnchor.constraint(equalTo: containerFormView.leftAnchor, constant: 12).isActive = true
        emailField.rightAnchor.constraint(equalTo: containerFormView.rightAnchor, constant: -12).isActive = true
        emailField.heightAnchor.constraint(equalToConstant: 70).isActive = true
        
        passwordField.topAnchor.constraint(equalTo: emailField.bottomAnchor, constant: 12).isActive = true
        passwordField.leftAnchor.constraint(equalTo: containerFormView.leftAnchor, constant: 12).isActive = true
        passwordField.rightAnchor.constraint(equalTo: containerFormView.rightAnchor, constant: -12).isActive = true
        passwordField.heightAnchor.constraint(equalToConstant: 70).isActive = true
        
        confirmPasswordField.topAnchor.constraint(equalTo: passwordField.bottomAnchor, constant: 12).isActive = true
        confirmPasswordField.leftAnchor.constraint(equalTo: containerFormView.leftAnchor, constant: 12).isActive = true
        confirmPasswordField.rightAnchor.constraint(equalTo: containerFormView.rightAnchor, constant: -12).isActive = true
        confirmPasswordField.heightAnchor.constraint(equalToConstant: 70).isActive = true
    }
    
    private func setupObserver() {
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    private func setupEvent() {
        firstnameField.textField.addTarget(self, action: #selector(textFieldDidBeginEditing(_:)), for: UIControl.Event.editingDidBegin)
        fullnameField.textField.addTarget(self, action: #selector(textFieldDidBeginEditing(_:)), for: UIControl.Event.editingDidBegin)
        emailField.textField.addTarget(self, action: #selector(textFieldDidBeginEditing(_:)), for: UIControl.Event.editingDidBegin)
        passwordField.textField.addTarget(self, action: #selector(textFieldDidBeginEditing(_:)), for: UIControl.Event.editingDidBegin)
        confirmPasswordField.textField.addTarget(self, action: #selector(textFieldDidBeginEditing(_:)), for: UIControl.Event.editingDidBegin)
    }
    
    @objc private func textFieldDidBeginEditing(_ sender: UITextField) {
        self.activeTextField = sender
        sender.becomeFirstResponder()
    }
    
    @objc private func handleCancelButton() {
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc func handleKeyboardWillShow(_ notification: Notification) {
        guard let keyboardFrame = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as AnyObject).cgRectValue else { return }
        guard let keyboardDuration = (notification.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as AnyObject).doubleValue else { return }
        
        self.scrollViewHeightConstraint.constant = -keyboardFrame.height
        
        UIView.animate(withDuration: keyboardDuration) {
            self.view.layoutIfNeeded()
            if let activeTextField = self.activeTextField {
                // scroll to the top of the textfield(container of textfield)
                self.scrollView.setContentOffset(CGPoint(x: self.scrollView.contentOffset.x, y: min(activeTextField.superview!.superview!.frame.minY, self.scrollView.contentSize.height - self.scrollView.frame.height)), animated: false)
            }
        }
        
    }
    
    @objc private func handleKeyboardWillHide(_ notification: Notification) {
        guard let keyboardDuration = (notification.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as AnyObject).doubleValue else { return }
        
        scrollViewHeightConstraint.constant = 0
        
        UIView.animate(withDuration: keyboardDuration) {
            self.view.layoutIfNeeded()
        }
    }
}
