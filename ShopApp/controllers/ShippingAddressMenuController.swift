//
//  ShippingAddressMenuController.swift
//  ShopApp
//
//  Created by Nguyễn Đức Huy on 1/2/20.
//  Copyright © 2020 Nguyễn Đức Huy. All rights reserved.
//

import UIKit

class ShippingAddressMenuController: UIViewController {
    
//    var shippingAddressList
//
//    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        <#code#>
//    }
//
//    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//        <#code#>
//    }
    
    let addNewAddressView = AddNewAddressView()
    
    let shippingAddressMenuCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = UICollectionView.ScrollDirection.vertical
        layout.minimumLineSpacing = 4
        let collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
        collectionView.alwaysBounceVertical = true
        collectionView.showsVerticalScrollIndicator = false
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = UIColor.white
        return collectionView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(white: 0.9, alpha: 1)
        
        setupNavbar()
        setupViews()
        setupEvents()
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
        
        addNewAddressView.topAnchor.constraint(equalTo: view.topAnchor, constant: 12).isActive = true
        addNewAddressView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        addNewAddressView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        addNewAddressView.heightAnchor.constraint(equalToConstant: 90).isActive = true
    }
    
    private func setupEvents() {
        addNewAddressView.button.addTarget(self, action: #selector(handleAddNewAddress), for: UIControl.Event.touchUpInside)
    }
    
    @objc private func handleAddNewAddress() {
        let viewController = ShippingAddressFormController()
        navigationController?.pushViewController(viewController, animated: true)
    }
}

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
