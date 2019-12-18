//
//  SignInController.swift
//  ShopApp
//
//  Created by Nguyễn Đức Huy on 12/16/19.
//  Copyright © 2019 Nguyễn Đức Huy. All rights reserved.
//

import UIKit

class SignInController: UIViewController {
    let topNotificationLabel = TopNotificationLabel()
    
    let containerFormView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor.white
        return view
    }()
    
    let usernameField = FieldCheckerView(title: "Enter MIKI username/gmail", style: .default)
    let passwordField = FieldCheckerView(title: "Enter password", style: .default)
    let signInButton = DarkButton(title: "Sign in", style: .active)
    let registerLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.isUserInteractionEnabled = true
        label.textAlignment = NSTextAlignment.center
        
        typealias key = NSAttributedString.Key
        
        let attributedText = NSMutableAttributedString(string: "Register", attributes: [key.font: UIFont.helveticaLight(ofsize: 12), key.underlineStyle: NSUnderlineStyle.single.rawValue])
        label.attributedText = attributedText
        
        return label
    }()
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.navigationItem.title = "SIGN IN"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(white: 0.875, alpha: 1)
        
        
        // add event
        usernameField.textField.addTarget(self, action: #selector(textFieldEditingDidBegin), for: UIControl.Event.editingDidBegin)
        usernameField.textField.addTarget(self, action: #selector(textFieldEditingDidEnd), for: UIControl.Event.editingDidEnd)
        
        passwordField.textField.addTarget(self, action: #selector(textFieldEditingDidBegin), for: UIControl.Event.editingDidBegin)
        passwordField.textField.addTarget(self, action: #selector(textFieldEditingDidEnd), for: UIControl.Event.editingDidEnd)
        
        signInButton.addTarget(self, action: #selector(handleSignIn), for: UIControl.Event.touchUpInside)
        
        let registerTap = UITapGestureRecognizer(target: self, action: #selector(handleTapRegister))
        registerTap.cancelsTouchesInView = false
        registerLabel.addGestureRecognizer(registerTap)
        
        // set up
        setupNavbar()
        setupViews()
    }
    
    @objc private func textFieldEditingDidBegin(_ sender: UITextField) {
        guard let superView = sender.superview?.superview as? FieldCheckerView else { return }
        superView.status = .focus
    }
    @objc private func textFieldEditingDidEnd(_ sender: UITextField) {
        guard let superView = sender.superview?.superview as? FieldCheckerView else { return }
        superView.status = .default
    }
    @objc private func handleSignIn() {
        guard let usernameText = usernameField.textField.text else { return }
        guard let passwordText = passwordField.textField.text else { return }
        
        if usernameText.isEmpty {
            if topNotificationLabel.status == .hide {
                topNotificationLabel.status = .show
            }
            
            topNotificationLabel.text = "No username/email address entered"
        } else if passwordText.count < 8 {
            if topNotificationLabel.status == .hide {
                topNotificationLabel.status = .show
            }
            
            topNotificationLabel.text = "Your password must be 8 characters long"
        } else {
            if topNotificationLabel.status == .hide {
                topNotificationLabel.status = .show
            }
            
            topNotificationLabel.text = "Incorrect login details entered."
        }
        
    }
    
    @objc private func handleTapRegister() {
        let viewController = RegisterController()
        self.navigationController?.pushViewController(viewController, animated: true)
    }
    
    
    private func setupNavbar() {
        let cancelButton = UIBarButtonItem(title: "\u{2715}", style: UIBarButtonItem.Style.plain, target: self, action: #selector(handleCancelButton))
        
        navigationItem.rightBarButtonItem = cancelButton
    }
    
    @objc private func handleCancelButton() {
        self.dismiss(animated: true, completion: nil)
    }
    
    private func setupViews() {
        topNotificationLabel.translatesAutoresizingMaskIntoConstraints = false
        usernameField.translatesAutoresizingMaskIntoConstraints = false
        passwordField.translatesAutoresizingMaskIntoConstraints = false
        signInButton.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(topNotificationLabel)
        view.addSubview(containerFormView)
        
        containerFormView.topAnchor.constraint(equalTo: topNotificationLabel.bottomAnchor, constant: 12).isActive = true
        containerFormView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        containerFormView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        containerFormView.heightAnchor.constraint(equalToConstant: 300).isActive = true
        
        containerFormView.addSubview(usernameField)
        containerFormView.addSubview(passwordField)
        containerFormView.addSubview(signInButton)
        containerFormView.addSubview(registerLabel)
        
        usernameField.topAnchor.constraint(equalTo: containerFormView.topAnchor, constant: 24).isActive = true
        usernameField.leftAnchor.constraint(equalTo: containerFormView.leftAnchor, constant: 12).isActive = true
        usernameField.rightAnchor.constraint(equalTo: containerFormView.rightAnchor, constant: -12).isActive = true
        usernameField.heightAnchor.constraint(equalToConstant: 70).isActive = true
        
        passwordField.topAnchor.constraint(equalTo: usernameField.bottomAnchor, constant: 12).isActive = true
        passwordField.leftAnchor.constraint(equalTo: containerFormView.leftAnchor, constant: 12).isActive = true
        passwordField.rightAnchor.constraint(equalTo: containerFormView.rightAnchor, constant: -12).isActive = true
        passwordField.heightAnchor.constraint(equalToConstant: 70).isActive = true
        
        
        signInButton.topAnchor.constraint(equalTo: passwordField.bottomAnchor, constant: 24).isActive = true
        signInButton.leftAnchor.constraint(equalTo: containerFormView.leftAnchor, constant: 12).isActive = true
        signInButton.rightAnchor.constraint(equalTo: containerFormView.rightAnchor, constant: -12).isActive = true
        signInButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        registerLabel.topAnchor.constraint(equalTo: signInButton.bottomAnchor, constant: 12).isActive = true
        registerLabel.centerXAnchor.constraint(equalTo: containerFormView.centerXAnchor).isActive = true
        registerLabel.widthAnchor.constraint(equalToConstant: 200).isActive = true
        registerLabel.heightAnchor.constraint(equalToConstant: 20).isActive = true
        
    }
}
