//
//  RegisterController.swift
//  ShopApp
//
//  Created by Nguyễn Đức Huy on 12/17/19.
//  Copyright © 2019 Nguyễn Đức Huy. All rights reserved.
//

import UIKit
import Foundation
import Firebase

class RegisterController: UIViewController {
    let topNotificationLabel = TopNotificationLabel()
    
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
    
    var loadingView = NotificationView(title: "Loading", type: .loading)
    
    let firstnameField = FieldCheckerView(title: "Enter first name", style: .default)
    let lastnameField = FieldCheckerView(title: "Enter last name", style: .default)
    let emailField = FieldCheckerView(title: "Enter email", style: .default)
    let passwordField = FieldCheckerView(title: "Enter password", style: .default)
    let confirmPasswordField = FieldCheckerView(title: "Enter confirm password", style: .default)
    
    private var activeTextField: UITextField? = nil
    
    let registerButton = DarkButton(title: "Register", style: .active)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white
        
        passwordField.textField.isSecureTextEntry = true
        confirmPasswordField.textField.isSecureTextEntry = true
        
        loadingView.isHidden = true
        view.addSubview(loadingView)
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
        lastnameField.translatesAutoresizingMaskIntoConstraints = false
        emailField.translatesAutoresizingMaskIntoConstraints = false
        passwordField.translatesAutoresizingMaskIntoConstraints = false
        confirmPasswordField.translatesAutoresizingMaskIntoConstraints = false
        registerButton.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(topNotificationLabel)
        view.addSubview(scrollView)
        
        scrollView.topAnchor.constraint(equalTo: topNotificationLabel.bottomAnchor).isActive = true
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
        containerFormView.addSubview(lastnameField)
        containerFormView.addSubview(emailField)
        containerFormView.addSubview(passwordField)
        containerFormView.addSubview(confirmPasswordField)
        containerFormView.addSubview(registerButton)
        
        firstnameField.topAnchor.constraint(equalTo: containerFormView.topAnchor, constant: 12).isActive = true
        firstnameField.leftAnchor.constraint(equalTo: containerFormView.leftAnchor, constant: 12).isActive = true
        firstnameField.rightAnchor.constraint(equalTo: containerFormView.rightAnchor, constant: -12).isActive = true
        firstnameField.heightAnchor.constraint(equalToConstant: 70).isActive = true
        
        lastnameField.topAnchor.constraint(equalTo: firstnameField.bottomAnchor, constant: 12).isActive = true
        lastnameField.leftAnchor.constraint(equalTo: containerFormView.leftAnchor, constant: 12).isActive = true
        lastnameField.rightAnchor.constraint(equalTo: containerFormView.rightAnchor, constant: -12).isActive = true
        lastnameField.heightAnchor.constraint(equalToConstant: 70).isActive = true
        
        emailField.topAnchor.constraint(equalTo: lastnameField.bottomAnchor, constant: 12).isActive = true
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
        
        registerButton.topAnchor.constraint(equalTo: confirmPasswordField.bottomAnchor, constant: 36).isActive = true
        registerButton.leftAnchor.constraint(equalTo: containerFormView.leftAnchor, constant: 12).isActive = true
        registerButton.rightAnchor.constraint(equalTo: containerFormView.rightAnchor, constant: -12).isActive = true
        registerButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
    }
    
    private func setupObserver() {
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    private func setupEvent() {
        firstnameField.textField.addTarget(self, action: #selector(textFieldDidBeginEditing(_:)), for: UIControl.Event.editingDidBegin)
        lastnameField.textField.addTarget(self, action: #selector(textFieldDidBeginEditing(_:)), for: UIControl.Event.editingDidBegin)
        emailField.textField.addTarget(self, action: #selector(textFieldDidBeginEditing(_:)), for: UIControl.Event.editingDidBegin)
        passwordField.textField.addTarget(self, action: #selector(textFieldDidBeginEditing(_:)), for: UIControl.Event.editingDidBegin)
        confirmPasswordField.textField.addTarget(self, action: #selector(textFieldDidBeginEditing(_:)), for: UIControl.Event.editingDidBegin)
        
        registerButton.addTarget(self, action: #selector(handleRegisterButton), for: UIControl.Event.touchUpInside)
    }
    
    @objc private func textFieldDidBeginEditing(_ sender: UITextField) {
        self.activeTextField = sender
        sender.becomeFirstResponder()
    }
    
    @objc private func handleCancelButton() {
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc private func handleKeyboardWillShow(_ notification: Notification) {
        guard let keyboardFrame = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as AnyObject).cgRectValue else { return }
        guard let keyboardDuration = (notification.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as AnyObject).doubleValue else { return }
        
        self.scrollViewHeightConstraint.constant = -keyboardFrame.height
        self.loadingView.center.y -= keyboardFrame.height/2
        
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
        loadingView.center.y = view.center.y - 50
        
        UIView.animate(withDuration: keyboardDuration) {
            self.view.layoutIfNeeded()
        }
    }
    
    @objc private func handleRegisterButton() {
        print("text field", firstnameField, lastnameField, emailField, passwordField, confirmPasswordField, registerButton)
        
        guard let firstNameText = firstnameField.textField.text,
            let lastnameText = lastnameField.textField.text,
            let emailText = emailField.textField.text,
            let passwordText = passwordField.textField.text,
            let confirmPasswordText = confirmPasswordField.textField.text else {
                topNotificationLabel.status = .show
                topNotificationLabel.text = "Please fill all textfield"
            return
        }
        
        print("email", emailText.isValidEmail())
        
        if firstNameText.isEmpty || lastnameText.isEmpty || emailText.isEmpty ||
            passwordText.isEmpty || confirmPasswordText.isEmpty {
                topNotificationLabel.status = .show
                topNotificationLabel.text = "Please fill all textfields"
                return
        }
        
        
        if confirmPasswordText != passwordText {
            topNotificationLabel.status = .show
            topNotificationLabel.text = "Password must match"
            return
        }
        
        if !emailText.isValidEmail() {
            topNotificationLabel.status = .show
            topNotificationLabel.text = "Invalid email"
            return
        }
        
        let userDictionary: [String: Any] = [
            "firstname": firstNameText,
            "lastname": lastnameText,
            "emailText": emailText.lowercased(),
            "password": passwordText
        ]
        
        // show loading view
        loadingView.isHidden = false
        
        
        Auth.auth().createUser(withEmail: emailText, password: passwordText) { (authResult, error) in
            if let error = error {
                print("Can not create user. The error is", error)
                self.loadingView.isHidden = true
                return
            }
            
            guard let uid = authResult?.user.uid else { return }
            
            let databaseRef = Database.database().reference()
            let userRef = databaseRef.child("user").child(uid)
            
            userRef.updateChildValues(userDictionary, withCompletionBlock: { (updateError, ref) in
                if let updateError = updateError {
                    print("Can not update user. The error is", updateError)
                    self.loadingView.isHidden = true
                    return
                }
                
                print("registed")
                
            })
        }
        
        topNotificationLabel.status = .hide
    }
}
