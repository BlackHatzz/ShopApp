//
//  CheckoutController.swift
//  ShopApp
//
//  Created by Nguyễn Đức Huy on 12/12/19.
//  Copyright © 2019 Nguyễn Đức Huy. All rights reserved.
//

import UIKit

class CheckoutController: UIViewController {
    let procedureCollectionView: ProcedureCollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = UICollectionView.ScrollDirection.vertical
        let collectionView = ProcedureCollectionView(frame: CGRect.zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = UIColor.clear
        collectionView.showsVerticalScrollIndicator = false
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.alwaysBounceVertical = true
        return collectionView
    }()
    
    let verificationView = VerificationView(withTitle: "Purchase Now", style: VerificationView.Style.inactive
    )
    
//    let bottomContainerView: UIView = {
//        let view = UIView()
//        view.backgroundColor = UIColor.white
//        view.translatesAutoresizingMaskIntoConstraints = false
//        return view
//    }()
    
//    let purchaseButton: UIButton = {
//        let button = UIButton()
//        button.translatesAutoresizingMaskIntoConstraints = false
//        button.setTitle("Purchase Now", for: UIControl.State.normal)
//        button.setTitleColor(UIColor(white: 0.7, alpha: 1), for: UIControl.State.normal)
//        button.titleLabel?.font = UIFont.helvetica(ofsize: 14)
//        button.backgroundColor = UIColor(white: 0.9, alpha: 1)
//        return button
//    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(white: 0.875, alpha: 1)
        setupNavbar()
        setupViews()
        
        procedureCollectionView.didSelectItemAtIndexPath = {(indexPath: IndexPath) -> Void in
            switch indexPath.row {
            case 0:
                print("select")
                let viewController = ShoppingAddressFormController()
                let navController = UINavigationController(rootViewController: viewController)
                self.navigationController?.presentPushViewControllerFromRight(navController)
            default:
                print("no")
            }
            
            
        }
    }
    
    func setupViews() {
        verificationView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(procedureCollectionView)
        view.addSubview(verificationView)
//        view.addSubview(bottomContainerView)
        
//        bottomContainerView.addSubview(purchaseButton)
        
        // set up from bottom to top
        verificationView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        verificationView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        verificationView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        verificationView.heightAnchor.constraint(equalToConstant: 70).isActive = true
        
        procedureCollectionView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        procedureCollectionView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        procedureCollectionView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        procedureCollectionView.bottomAnchor.constraint(equalTo: verificationView.topAnchor).isActive = true
        
        // set up view in bottomContainerView
//        purchaseButton.centerXAnchor.constraint(equalTo: bottomContainerView.centerXAnchor).isActive = true
//        purchaseButton.centerYAnchor.constraint(equalTo: bottomContainerView.centerYAnchor).isActive = true
//        purchaseButton.widthAnchor.constraint(equalTo: bottomContainerView.widthAnchor, multiplier: 0.9).isActive = true
//        purchaseButton.heightAnchor.constraint(equalToConstant: 44).isActive = true
        
    }
    
    private func setupNavbar() {
        let cancelButton = UIBarButtonItem(title: "\u{2715}", style: UIBarButtonItem.Style.plain, target: self, action: #selector(handleCancelButton))
        
        navigationItem.rightBarButtonItem = cancelButton
        navigationItem.title = "Secure Checkout"
    }
    
    @objc func handleCancelButton() {
        self.dismiss(animated: true, completion: nil)
    }
    
}

class ProcedureCollectionView: UICollectionView, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    private static let cellId = "cellId"
    var didSelectItemAtIndexPath: (((_ indexPath: IndexPath) -> Void)?) = nil
    
    override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        super.init(frame: frame, collectionViewLayout: layout)
        register(ProcedureCollectionViewCell.self, forCellWithReuseIdentifier: ProcedureCollectionView.cellId)
        delegate = self
        dataSource = self
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 3
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ProcedureCollectionView.cellId, for: indexPath) as! ProcedureCollectionViewCell
        
        cell.transactionLabel.text = "\(indexPath.row + 1)"
        
        if indexPath.row == 0 {
            cell.titleLabel.text = "Shipping Address"
        } else if indexPath.row == 1 {
            cell.titleLabel.text = "Shipping Options"
        } else if indexPath.row == 2 {
            cell.titleLabel.text = "Payment"
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let handler = didSelectItemAtIndexPath {
            handler(indexPath)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: self.frame.width, height: 100)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 2
    }
}

class ProcedureCollectionViewCell: UICollectionViewCell {
    let transactionLabel = TransactionLabel(style: TransactionLabel.Style.default)
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.helvetica(ofsize: 18)
        label.text = "Shopping Address"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let addLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = NSTextAlignment.right
        
        typealias key = NSAttributedString.Key
        let attributedString = NSMutableAttributedString(string: "Add", attributes: [key.underlineStyle : NSUnderlineStyle.single.rawValue, key.font: UIFont.helveticaLight(ofsize: 14)])
        label.attributedText = attributedString
        
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor.white
        
        // set up views
        addSubview(transactionLabel)
        addSubview(titleLabel)
        addSubview(addLabel)
        
        transactionLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        transactionLabel.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 12).isActive = true
        transactionLabel.widthAnchor.constraint(equalToConstant: 40).isActive = true
        transactionLabel.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        addLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        addLabel.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -12).isActive = true
        addLabel.widthAnchor.constraint(equalToConstant: 50).isActive = true
        addLabel.heightAnchor.constraint(equalToConstant: 20).isActive = true
        
        titleLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        titleLabel.leftAnchor.constraint(equalTo: transactionLabel.rightAnchor, constant: 12).isActive = true
        titleLabel.rightAnchor.constraint(equalTo: addLabel.leftAnchor, constant: -12).isActive = true
        titleLabel.heightAnchor.constraint(equalToConstant: 30).isActive = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}

