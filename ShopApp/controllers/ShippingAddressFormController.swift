//
//  ShoppingAddressFormController.swift
//  ShopApp
//
//  Created by Nguyễn Đức Huy on 12/13/19.
//  Copyright © 2019 Nguyễn Đức Huy. All rights reserved.
//

import UIKit
import Firebase

class ShippingAddressFormController: UIViewController, UIScrollViewDelegate {
    var scrollViewBottomLayoutConstraint: NSLayoutConstraint? = nil
    let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.alwaysBounceVertical = true
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.showsVerticalScrollIndicator = true
        scrollView.backgroundColor = UIColor.clear
        scrollView.keyboardDismissMode = UIScrollView.KeyboardDismissMode.interactive
        return scrollView
    }()
    let containerView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.white
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let firstNameField = FieldCheckerView(title: "First Name", style: .bottomNotificationLabel)
    let lastNameField = FieldCheckerView(title: "Last Name", style: .bottomNotificationLabel)
    let addressField = FieldCheckerView(title: "Address", style: .bottomNotificationLabel)
    let cityField = FieldCheckerView(title: "City", style: .bottomNotificationLabel)
    let stateField = FieldCheckerView(title: "County/State/Province", style: .bottomNotificationLabel)
    let countryField = FieldCheckerView(title: "Country", style: .bottomNotificationLabel)
    let phoneField = FieldCheckerView(title: "Mobile Phone Number", style: .bottomNotificationLabel)
    
    let purchaseContainer = VerificationView(withTitle: "Continue", style: .active)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white
        
        setupNavbar()
        setupViews()
        
//        let tap: UITapGestureRecognizer = UITapGestureRecognizer(
//            target: self,
//            action: #selector(dismissKeyboard))
//
//        tap.cancelsTouchesInView = false
//        view.addGestureRecognizer(tap)
        scrollView.delegate = self
        
        setupEvents()
    }
    
    private func setupNavbar() {
        navigationItem.title = "Shopping Address"
        
        navigationItem.hidesBackButton = false
        
        
        let backButton = UIBarButtonItem(title: "Back", style: UIBarButtonItem.Style.plain, target: self, action: #selector(handleBackButton))
        
        navigationItem.leftBarButtonItem = backButton
    }
    
    @objc func handleBackButton() {
//        self.navigationController?.popViewController(animated: true)
        self.navigationController?.dismiss(animated: true, completion: nil)
    }
    
    private func setupViews() {
        firstNameField.translatesAutoresizingMaskIntoConstraints = false
        lastNameField.translatesAutoresizingMaskIntoConstraints = false
        addressField.translatesAutoresizingMaskIntoConstraints = false
        cityField.translatesAutoresizingMaskIntoConstraints = false
        stateField.translatesAutoresizingMaskIntoConstraints = false
        countryField.translatesAutoresizingMaskIntoConstraints = false
        phoneField.translatesAutoresizingMaskIntoConstraints = false
        purchaseContainer.translatesAutoresizingMaskIntoConstraints = false
        
        // set up scrollView
        view.addSubview(scrollView)
        view.addSubview(purchaseContainer)
        
        // setup from botttom to top
        purchaseContainer.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        purchaseContainer.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        purchaseContainer.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        purchaseContainer.heightAnchor.constraint(equalToConstant: 70).isActive = true
        
        scrollView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        scrollView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        scrollView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        scrollViewBottomLayoutConstraint = scrollView.bottomAnchor.constraint(equalTo: purchaseContainer.topAnchor, constant: 0)
        scrollViewBottomLayoutConstraint!.isActive = true
        
        // setup containerView
        scrollView.addSubview(containerView)
        
        containerView.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 12).isActive = true
        containerView.leftAnchor.constraint(equalTo: scrollView.leftAnchor, constant: 8).isActive = true
        containerView.widthAnchor.constraint(equalToConstant: view.frame.width - 16).isActive = true
//        containerView.heightAnchor.constraint(equalToConstant: view.frame.width - 12).isActive = true
        containerView.heightAnchor.constraint(equalToConstant: 800).isActive = true
        
        // setup views in containerView
        containerView.addSubview(firstNameField)
        containerView.addSubview(lastNameField)
        containerView.addSubview(addressField)
        containerView.addSubview(cityField)
        containerView.addSubview(stateField)
        containerView.addSubview(countryField)
        containerView.addSubview(phoneField)
        
        firstNameField.topAnchor.constraint(equalTo: containerView.topAnchor).isActive = true
        firstNameField.leftAnchor.constraint(equalTo: containerView.leftAnchor).isActive = true
        firstNameField.rightAnchor.constraint(equalTo: containerView.rightAnchor).isActive = true
        firstNameField.heightAnchor.constraint(equalToConstant: 90).isActive = true

        lastNameField.topAnchor.constraint(equalTo: firstNameField.bottomAnchor, constant: 12).isActive = true
        lastNameField.leftAnchor.constraint(equalTo: containerView.leftAnchor).isActive = true
        lastNameField.rightAnchor.constraint(equalTo: containerView.rightAnchor).isActive = true
        lastNameField.heightAnchor.constraint(equalToConstant: 90).isActive = true

        addressField.topAnchor.constraint(equalTo: lastNameField.bottomAnchor).isActive = true
        addressField.leftAnchor.constraint(equalTo: containerView.leftAnchor).isActive = true
        addressField.rightAnchor.constraint(equalTo: containerView.rightAnchor).isActive = true
        addressField.heightAnchor.constraint(equalToConstant: 90).isActive = true
        
        cityField.topAnchor.constraint(equalTo: addressField.bottomAnchor, constant: 12).isActive = true
        cityField.leftAnchor.constraint(equalTo: containerView.leftAnchor).isActive = true
        cityField.rightAnchor.constraint(equalTo: containerView.rightAnchor).isActive = true
        cityField.heightAnchor.constraint(equalToConstant: 90).isActive = true
        
        stateField.topAnchor.constraint(equalTo: cityField.bottomAnchor, constant: 12).isActive = true
        stateField.leftAnchor.constraint(equalTo: containerView.leftAnchor).isActive = true
        stateField.rightAnchor.constraint(equalTo: containerView.rightAnchor).isActive = true
        stateField.heightAnchor.constraint(equalToConstant: 90).isActive = true
        
        countryField.topAnchor.constraint(equalTo: stateField.bottomAnchor, constant: 12).isActive = true
        countryField.leftAnchor.constraint(equalTo: containerView.leftAnchor).isActive = true
        countryField.rightAnchor.constraint(equalTo: containerView.rightAnchor).isActive = true
        countryField.heightAnchor.constraint(equalToConstant: 90).isActive = true
        
        phoneField.topAnchor.constraint(equalTo: countryField.bottomAnchor, constant: 12).isActive = true
        phoneField.leftAnchor.constraint(equalTo: containerView.leftAnchor).isActive = true
        phoneField.rightAnchor.constraint(equalTo: containerView.rightAnchor).isActive = true
        phoneField.heightAnchor.constraint(equalToConstant: 90).isActive = true
    }
    
    private func setupEvents() {
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
        
        countryField.textField.addTarget(self, action: #selector(textFieldEditingDidEnd(_:)), for: UIControl.Event.editingDidEnd)
        countryField.textField.addTarget(self, action: #selector(textFieldEditingDidBegin(_:)), for: UIControl.Event.editingDidBegin)
        
        phoneField.textField.addTarget(self, action: #selector(textFieldEditingDidEnd(_:)), for: UIControl.Event.editingDidEnd)
        phoneField.textField.addTarget(self, action: #selector(textFieldEditingDidBegin(_:)), for: UIControl.Event.editingDidBegin)
        
        purchaseContainer.handlerButton.addTarget(self, action: #selector(handlePurchase), for: UIControl.Event.touchUpInside)
        
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc private func handleKeyboardWillShow(_ notification: Notification) {
        guard let keyboardFrame = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as AnyObject).cgRectValue else { return }
        guard let keyboardDuration = (notification.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as AnyObject).doubleValue else { return }
        print("will show", keyboardFrame)
        scrollViewBottomLayoutConstraint?.isActive = false
        scrollViewBottomLayoutConstraint = scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -keyboardFrame.height)
        scrollViewBottomLayoutConstraint?.isActive = true
        
        UIView.animate(withDuration: keyboardDuration) {
            self.view.layoutIfNeeded()
        }
    }
    @objc private func handleKeyboardWillHide(_ notification: Notification) {
        guard let keyboardDuration = (notification.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as AnyObject).doubleValue else { return }
        print("will hide")
        scrollViewBottomLayoutConstraint?.isActive = false
        scrollViewBottomLayoutConstraint = scrollView.bottomAnchor.constraint(equalTo: purchaseContainer.topAnchor)
        scrollViewBottomLayoutConstraint?.constant = 0
        scrollViewBottomLayoutConstraint?.isActive = true
        
        UIView.animate(withDuration: keyboardDuration) {
            self.view.layoutIfNeeded()
        }
    }
    
    
//    @objc private func dismissKeyboard() {
//        view.endEditing(true)
//    }
//
//    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
//        view.endEditing(true)
//    }
    
    @objc private func textFieldEditingDidEnd(_ sender: UITextField) {
        print("sender", sender.text as Any)
        guard let superView = sender.superview?.superview as? FieldCheckerView else { return }
        guard let text = sender.text else { return }
        if text.isEmpty {
            superView.status = .invalid
        } else {
            superView.status = .default
        }
    }
    @objc private func textFieldEditingDidBegin(_ sender: UITextField) {
        print("begin")
        guard let superView = sender.superview?.superview as? FieldCheckerView else { return }
        superView.status = .focus
    }
    
    @objc func handlePurchase() {
        view.endEditing(true)
        
        var isValid = true
        for field in [firstNameField ,lastNameField, addressField, cityField, stateField, countryField, phoneField] {
            guard let text = field.textField.text else { return }
            if text.isEmpty {
                print("nope")
                field.status = .invalid
                isValid = false
            } else {
                field.status = .default
            }

        }
        
        if phoneField.status != .invalid {
            if !phoneField.textField.text!.isValidPhoneNumber() {
                phoneField.status = .invalid
                phoneField.notificationLabel?.text = "Phone Number must contains 10-11 digits"
                isValid = false
            }
        }
        
        if !isValid { return }
        
        
        
        
        // area is county/state/province
        
        let orderRef = Database.database().reference().child("order")
        var orderId: String? = nil
        orderRef.queryOrdered(byChild: "orderId").queryLimited(toLast: 1).observeSingleEvent(of: DataEventType.value, with: { (snapshot) in
            
            var lastId: String? = nil
            // get the last node
            if let lastOrder = (snapshot.value as? NSArray)?.lastObject as? [String: Any] {
                // when return a ns array
                lastId = lastOrder["orderId"] as? String
            } else if let lastOrder = ((snapshot.value as? [String: Any])?.first?.value) as? [String: Any] {
                // when return a dictionary
                lastId = lastOrder["orderId"] as? String
            }
            orderId = "\(Int(lastId!)! + 1)"
            
            
            let order: [String: Any] = [
                //            "customerId": customer.id!,
                "firstname": self.firstNameField.textField.text!,
                "lastname": self.lastNameField.textField.text!,
                "address": self.addressField.textField.text!,
                "city": self.cityField.textField.text!,
                "area": self.stateField.textField.text!,
                "country": self.countryField.textField.text!,
                "phone": self.phoneField.textField.text!,
                "orderId": orderId!
            ]
            
            let updateOrderRef = Database.database().reference().child("order").child(orderId!)
            updateOrderRef.updateChildValues(order) { (error, databaseRef) in
                if let error = error {
                    print("Cannot order. The error is", error)
                    return
                }
                orderRef.removeAllObservers()
                
                let processView = ProcessView(title: "Successed", type: ProcessView.NotiType.checked)
                if let windowView = UIApplication.shared.keyWindow {
                    windowView.addSubview(processView)
                }
                
                self.navigationController?.dismiss(animated: true, completion: nil)
            }
            
        }) { (error) in
            print(error.localizedDescription)
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        self.scrollView.setNeedsLayout()
        self.scrollView.layoutIfNeeded()
        self.containerView.setNeedsLayout()
        self.containerView.layoutIfNeeded()
            
        self.scrollView.contentSize.height = self.containerView.frame.height
    }
    
}
