//
//  SignInController.swift
//  ShopApp
//
//  Created by Nguyễn Đức Huy on 12/16/19.
//  Copyright © 2019 Nguyễn Đức Huy. All rights reserved.
//

import UIKit
import Firebase

class SignInController: UIViewController {
    let topNotificationLabel = TopNotificationLabel()
    
    let containerFormView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor.white
        return view
    }()
    
    var loadingView = ProcessView(title: "SIGNING IN", type: .loading)
    
    let emailField = FieldCheckerView(title: "Enter email", style: .default)
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
        passwordField.textField.isSecureTextEntry = true
        
        view.addSubview(loadingView)
        loadingView.isHidden = true
        
        // add event
        emailField.textField.addTarget(self, action: #selector(textFieldEditingDidBegin), for: UIControl.Event.editingDidBegin)
        emailField.textField.addTarget(self, action: #selector(textFieldEditingDidEnd), for: UIControl.Event.editingDidEnd)
        
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
    
    @objc private func handleKeyboardWillShow(_ notification: Notification) {
        guard let keyboardFrame = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as AnyObject).cgRectValue else { return }
        guard let keyboardDuration = (notification.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as AnyObject).doubleValue else { return }
        
        self.loadingView.center.y -= keyboardFrame.height/2
        
        UIView.animate(withDuration: keyboardDuration) {
            self.view.layoutIfNeeded()
        }
        
    }
    
    @objc private func handleKeyboardWillHide(_ notification: Notification) {
        guard let keyboardDuration = (notification.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as AnyObject).doubleValue else { return }
        
        loadingView.center.y = view.center.y - 50
        
        UIView.animate(withDuration: keyboardDuration) {
            self.view.layoutIfNeeded()
        }
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
        guard let emailText = emailField.textField.text else { return }
        guard let passwordText = passwordField.textField.text else { return }
        
        if emailText.isEmpty {
            if topNotificationLabel.status == .hide {
                topNotificationLabel.status = .show
            }
            
            topNotificationLabel.text = "No email address entered"
            return
        } else if passwordText.count < 6 {
            if topNotificationLabel.status == .hide {
                topNotificationLabel.status = .show
            }
            
            topNotificationLabel.text = "Your password must be 6 characters long"
            return
        }
        
        loadingView.isHidden = false
        disenableFields()
        
        Auth.auth().signIn(withEmail: emailText, password: passwordText) { (authResult, error) in
            if let error = error {
                print("Cannot sign in. Error is", error)
                
                if error.localizedDescription.contains("password is invalid") {
                    if self.topNotificationLabel.status == .hide {
                        self.topNotificationLabel.status = .show
                    }
                    self.topNotificationLabel.text = "Incorrect password"
                } else if error.localizedDescription.contains("no user record") {
                    if self.topNotificationLabel.status == .hide {
                        self.topNotificationLabel.status = .show
                    }
                    self.topNotificationLabel.text = "Account hasn't been existed"
                } else if error.localizedDescription.contains("many unsuccessful login") {
                    if self.topNotificationLabel.status == .hide {
                        self.topNotificationLabel.status = .show
                    }
                    self.topNotificationLabel.text = "Too many unsuccessful login. Please try again later"
                }
                
                self.loadingView.isHidden = true
                self.enableFields()
                return
            }
            weak var pvc = self.presentingViewController
            // get uid from auth firebase
            if let uid = authResult?.user.uid {
                let ref = Database.database().reference().child("customer").child(uid)
                ref.observeSingleEvent(of: DataEventType.value, with: { (snapshot) in
                    if let customerInfo = snapshot.value as? [String: Any] {
                        // get customer info and dismiss current view controller
                        customer = Customer(id: uid, userInfo: customerInfo)
                        self.view.endEditing(true)
                        self.navigationController?.dismiss(animated: true, completion: {
                            if let topController = UIApplication.topViewController() {
                                if topController is BagController {
                                    let viewController = ShippingAddressMenuController()
                                    let navController = UINavigationController(rootViewController: viewController)
                                    
                                    pvc?.present(navController, animated: true, completion: nil)
                                }
                            }
                        })
                    }
                    self.enableFields()
                    self.loadingView.isHidden = true
                }, withCancel: { (error) in
                    print(error.localizedDescription)
                    self.enableFields()
                    self.loadingView.isHidden = true
                })
                
            } else {
                self.enableFields()
            }
            
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
        emailField.translatesAutoresizingMaskIntoConstraints = false
        passwordField.translatesAutoresizingMaskIntoConstraints = false
        signInButton.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(topNotificationLabel)
        view.addSubview(containerFormView)
        
        containerFormView.topAnchor.constraint(equalTo: topNotificationLabel.bottomAnchor, constant: 12).isActive = true
        containerFormView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        containerFormView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        containerFormView.heightAnchor.constraint(equalToConstant: 300).isActive = true
        
        containerFormView.addSubview(emailField)
        containerFormView.addSubview(passwordField)
        containerFormView.addSubview(signInButton)
        containerFormView.addSubview(registerLabel)
        
        emailField.topAnchor.constraint(equalTo: containerFormView.topAnchor, constant: 24).isActive = true
        emailField.leftAnchor.constraint(equalTo: containerFormView.leftAnchor, constant: 12).isActive = true
        emailField.rightAnchor.constraint(equalTo: containerFormView.rightAnchor, constant: -12).isActive = true
        emailField.heightAnchor.constraint(equalToConstant: 70).isActive = true
        
        passwordField.topAnchor.constraint(equalTo: emailField.bottomAnchor, constant: 12).isActive = true
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
    
    private func disenableFields() {
        emailField.isUserInteractionEnabled = false
        passwordField.isUserInteractionEnabled = false
    }
    
    private func enableFields() {
        emailField.isUserInteractionEnabled = true
        passwordField.isUserInteractionEnabled = true
    }
}

