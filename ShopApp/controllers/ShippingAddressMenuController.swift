//
//  ShippingAddressMenuController.swift
//  ShopApp
//
//  Created by Nguyễn Đức Huy on 1/2/20.
//  Copyright © 2020 Nguyễn Đức Huy. All rights reserved.
//

import UIKit
import Firebase

class ShippingAddressMenuController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    var shippingAddressList = [ShippingAddress]()
    var selectedAddressRadioButton: UIButton! = nil
    
    let addNewAddressView = AddNewAddressView()
    
    let shippingAddressMenuCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = UICollectionView.ScrollDirection.vertical
        layout.minimumLineSpacing = 6
        layout.minimumInteritemSpacing = 0
        let collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.alwaysBounceVertical = true
        collectionView.showsVerticalScrollIndicator = false
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.backgroundColor = UIColor(white: 0.88, alpha: 1)
        return collectionView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(white: 0.88, alpha: 1)
        
        shippingAddressMenuCollectionView.delegate = self
        shippingAddressMenuCollectionView.dataSource = self
        shippingAddressMenuCollectionView.register(AddressCell.self, forCellWithReuseIdentifier: AddressCell.id)
        
        getData()
        setupNavbar()
        setupViews()
        setupEvents()
    }
    
    private func getData() {
        shippingAddressList = customer.shippingAddressList
        self.shippingAddressMenuCollectionView.reloadData()
    }
    
    private func setupNavbar() {
        navigationItem.title = "Shipping Address"
        let cancelButton = UIBarButtonItem(title: "\u{2715}", style: UIBarButtonItem.Style.plain, target: self, action: #selector(handleCancelButton))
        
        navigationItem.rightBarButtonItem = cancelButton
    }
    
    @objc private func handleCancelButton() {
        navigationController?.dismiss(animated: true, completion: nil)
    }
    
    private func setupViews() {
        addNewAddressView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(addNewAddressView)
        view.addSubview(shippingAddressMenuCollectionView)
        
        addNewAddressView.topAnchor.constraint(equalTo: view.topAnchor, constant: 12).isActive = true
        addNewAddressView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        addNewAddressView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        addNewAddressView.heightAnchor.constraint(equalToConstant: 90).isActive = true
        
        shippingAddressMenuCollectionView.topAnchor.constraint(equalTo: addNewAddressView.bottomAnchor, constant: 12).isActive = true
        shippingAddressMenuCollectionView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        shippingAddressMenuCollectionView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        shippingAddressMenuCollectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
    }
    
    private func setupEvents() {
        addNewAddressView.button.addTarget(self, action: #selector(handleAddNewAddress), for: UIControl.Event.touchUpInside)
    }
    
    @objc private func handleAddNewAddress() {
        let viewController = ShippingAddressFormController()
        navigationController?.pushViewController(viewController, animated: true)
    }
    
// ------------------------------------------------------------------------------
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return shippingAddressList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: AddressCell.id, for: indexPath) as! AddressCell
        
        if cell.radioButton === selectedAddressRadioButton {
            cell.radioButton.radioState = .selected
        } else {
            cell.radioButton.radioState = .unselected
        }
        
        let shippingAddress = shippingAddressList[indexPath.row]
        cell.nameLabel.text = "First name: " + shippingAddress.firstName! + " " + shippingAddress.lastName!
        cell.addressLabel.text = "Address: " + shippingAddress.address!
        cell.cityLabel.text = "City: " + shippingAddress.city!
        cell.stateLabel.text = "State: " + shippingAddress.state!
        cell.countryLabel.text = "Country: " + shippingAddress.country!
        cell.phoneNumberLabel.text = "Phone: " + shippingAddress.phoneNumber!
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath) as! AddressCell
        cell.radioButton.radioState = .selected
        selectedAddressRadioButton = cell.radioButton
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        collectionView.reloadItems(at: [indexPath])
        guard let cell = collectionView.cellForItem(at: indexPath) as? AddressCell else { return }
        cell.radioButton.radioState = .unselected
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: self.view.frame.width, height: 160)
    }
    
}

// ------------------------------------------------------------------------------
// ------------------------------------------------------------------------------

class AddNewAddressView: UIView {
    
    let button: UIButton = {
        let button = UIButton(type: UIButton.ButtonType.system)
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.lightGray.cgColor
        button.setTitle("Add New Address", for: UIControl.State.normal)
        button.titleLabel?.font = UIFont.helveticaLight(ofsize: 14)
        button.setTitleColor(UIColor.black, for: UIControl.State.normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor.white
        
        addSubview(button)
        
        button.topAnchor.constraint(equalTo: self.topAnchor, constant: 24).isActive = true
        button.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 24).isActive = true
        button.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -24).isActive = true
        button.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -24).isActive = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
// ------------------------------------------------------------------------------
// ------------------------------------------------------------------------------
class AddressCell: UICollectionViewCell {
    static let id = "addressCellId"
    
    let radioButton: RadioButton = {
        let button = RadioButton()
        button.backgroundColor = UIColor.clear
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    let containerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.isUserInteractionEnabled = false
        view.backgroundColor = UIColor.clear
        return view
    }()
    
    let nameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.isUserInteractionEnabled = false
        label.font = UIFont.systemFont(ofSize: 15, weight: UIFont.Weight.semibold)
        label.text = "Full name: Nguyen Duc Huy"
        label.backgroundColor = UIColor.clear
        return label
    }()
    
    let addressLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.isUserInteractionEnabled = false
        label.font = UIFont.systemFont(ofSize: 15, weight: UIFont.Weight.semibold)
        label.text = "Address: 123 Quang Trung"
        label.backgroundColor = UIColor.clear
        return label
    }()
    
    let cityLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.isUserInteractionEnabled = false
        label.font = UIFont.systemFont(ofSize: 15, weight: UIFont.Weight.semibold)
        label.text = "City: Ho Chi Minh"
        label.backgroundColor = UIColor.clear
        return label
    }()
    
    let stateLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.isUserInteractionEnabled = false
        label.font = UIFont.systemFont(ofSize: 15, weight: UIFont.Weight.semibold)
        label.text = "State: Nguyen Hue"
        label.backgroundColor = UIColor.clear
        return label
    }()
    
    let countryLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.isUserInteractionEnabled = false
        label.font = UIFont.systemFont(ofSize: 15, weight: UIFont.Weight.semibold)
        label.text = "Country: Vietnam"
        label.backgroundColor = UIColor.clear
        return label
    }()
    
    let phoneNumberLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.isUserInteractionEnabled = false
        label.font = UIFont.systemFont(ofSize: 15, weight: UIFont.Weight.semibold)
        label.text = "Phone: 1234567890"
        label.backgroundColor = UIColor.clear
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.white
//        ar address: String?
//        var city: String?
//        var state: String? // or county or province
//        var country: String?
//        var phoneNumber: String?
        setupViews()
    }
    
    private func setupViews() {
        // left content
        addSubview(radioButton)
        
        radioButton.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 8).isActive = true
        radioButton.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        radioButton.widthAnchor.constraint(equalToConstant: 32).isActive = true
        radioButton.heightAnchor.constraint(equalToConstant: 32).isActive = true
        
        // right content
        addSubview(containerView)
        
        containerView.topAnchor.constraint(equalTo: self.topAnchor, constant: 8).isActive = true
        containerView.leftAnchor.constraint(equalTo: radioButton.rightAnchor, constant: 12).isActive = true
        containerView.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -12).isActive = true
        containerView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -8).isActive = true
        
        containerView.addSubview(nameLabel)
        containerView.addSubview(addressLabel)
        containerView.addSubview(cityLabel)
        containerView.addSubview(stateLabel)
        containerView.addSubview(countryLabel)
        containerView.addSubview(phoneNumberLabel)
        // 1
        nameLabel.topAnchor.constraint(equalTo: containerView.topAnchor).isActive = true
        nameLabel.leftAnchor.constraint(equalTo: containerView.leftAnchor).isActive = true
        nameLabel.rightAnchor.constraint(equalTo: containerView.rightAnchor).isActive = true
        nameLabel.heightAnchor.constraint(equalToConstant: 20).isActive = true
        // 2
        addressLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 4).isActive = true
        addressLabel.leftAnchor.constraint(equalTo: containerView.leftAnchor).isActive = true
        addressLabel.rightAnchor.constraint(equalTo: containerView.rightAnchor).isActive = true
        addressLabel.heightAnchor.constraint(equalToConstant: 20).isActive = true
        // 3
        cityLabel.topAnchor.constraint(equalTo: addressLabel.bottomAnchor, constant: 4).isActive = true
        cityLabel.leftAnchor.constraint(equalTo: containerView.leftAnchor).isActive = true
        cityLabel.rightAnchor.constraint(equalTo: containerView.rightAnchor).isActive = true
        cityLabel.heightAnchor.constraint(equalToConstant: 20).isActive = true
        // 4
        stateLabel.topAnchor.constraint(equalTo: cityLabel.bottomAnchor, constant: 4).isActive = true
        stateLabel.leftAnchor.constraint(equalTo: containerView.leftAnchor).isActive = true
        stateLabel.rightAnchor.constraint(equalTo: containerView.rightAnchor).isActive = true
        stateLabel.heightAnchor.constraint(equalToConstant: 20).isActive = true
        // 5
        countryLabel.topAnchor.constraint(equalTo: stateLabel.bottomAnchor, constant: 4).isActive = true
        countryLabel.leftAnchor.constraint(equalTo: containerView.leftAnchor).isActive = true
        countryLabel.rightAnchor.constraint(equalTo: containerView.rightAnchor).isActive = true
        countryLabel.heightAnchor.constraint(equalToConstant: 20).isActive = true
        // 6
        phoneNumberLabel.topAnchor.constraint(equalTo: countryLabel.bottomAnchor, constant: 4).isActive = true
        phoneNumberLabel.leftAnchor.constraint(equalTo: containerView.leftAnchor).isActive = true
        phoneNumberLabel.rightAnchor.constraint(equalTo: containerView.rightAnchor).isActive = true
        phoneNumberLabel.heightAnchor.constraint(equalToConstant: 20).isActive = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
