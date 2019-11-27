//
//  BagController.swift
//  ShopApp
//
//  Created by Nguyễn Đức Huy on 11/4/19.
//  Copyright © 2019 Nguyễn Đức Huy. All rights reserved.
//

import UIKit

private let cellId = "bagCellId"
var shoppingBag = [Product]()

class BagController: UIViewController {
    
    let segmentedControl: UISegmentedControl = {
        let segmentedControl = UISegmentedControl(items: ["Shopping Bag", "Wish List"])
        segmentedControl.selectedSegmentIndex = 0
        segmentedControl.tintColor = UIColor.black
        return segmentedControl
    }()
    
    let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.backgroundColor = UIColor.clear
        scrollView.alwaysBounceHorizontal = false
        scrollView.alwaysBounceVertical = true
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white
        
        setupViews()
        
        segmentedControl.addTarget(self, action: #selector(handleSegmentedControl(_:)), for: UIControl.Event.valueChanged)
    }
    
    private func setupNavbar() {
        let cancelButton = UIBarButtonItem(title: "\u{2715}", style: UIBarButtonItem.Style.plain, target: self, action: #selector(handleCancelButton))
        
        navigationItem.rightBarButtonItem = cancelButton
        
        navigationItem.titleView = segmentedControl
        segmentedControl.frame = CGRect(x: 0, y: 0, width: self.view.frame.width / 2, height: 20)
    }
    
    let containerView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.clear
        view.translatesAutoresizingMaskIntoConstraints = false
        view.isUserInteractionEnabled = false
        return view
    }()
    
//    var shoppingItemViews = [ShoppingItemView]()
    
    private func setupViews() {
        setupNavbar()
        
        view.addSubview(scrollView)
        
//        view.addConstraints(withFormat: "H:|-12-[v0]-12-|", views: scrollView)
//        view.addConstraints(withFormat: "V:|-12-[v0]-12-|", views: scrollView)
        
        scrollView.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 12).isActive = true
        scrollView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true
        scrollView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive = true
        scrollView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
//        scrollView.contentSize = CGSize(width: 1000, height: 1000)
        
//        let shoppingItemView = ShoppingItemView()
//        shoppingItemView.backgroundColor = UIColor.red
//
//        scrollView.addSubview(shoppingItemView)
//
        scrollView.addSubview(containerView)
        
        containerView.topAnchor.constraint(equalTo: scrollView.topAnchor).isActive = true
        containerView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 12).isActive = true
        containerView.widthAnchor.constraint(equalTo: scrollView.widthAnchor, constant: -24).isActive = true
        containerView.heightAnchor.constraint(equalToConstant: 900).isActive = true
        
        let shoppingTableView = ShoppingTableView()
        
        view.addSubview(shoppingTableView)
        
        view.addConstraints(withFormat: "H:|[v0]|", views: shoppingTableView)
        view.addConstraints(withFormat: "V:|[v0]|", views: shoppingTableView)
        
//        shoppingItemViews.append(ShoppingItemView())
//        shoppingItemViews.append(ShoppingItemView())
//        shoppingItemViews.append(ShoppingItemView())
//        containerView.addSubview(shoppingItemViews[0])
//        containerView.addSubview(shoppingItemViews[1])
//        containerView.addSubview(shoppingItemViews[2])
        
//        containerView.addConstraints(withFormat: "H:|[v0]|", views: shoppingItemViews[0])
//        containerView.addConstraints(withFormat: "H:|[v0]|", views: shoppingItemViews[1])
//        containerView.addConstraints(withFormat: "H:|[v0]|", views: shoppingItemViews[2])
//        containerView.addConstraints(withFormat: "V:|[v0(300)][v1(300)][v2(300)]", views: shoppingItemViews[0], shoppingItemViews[1], shoppingItemViews[2])
        
//        for item in customer.shoppingBag {
//            print("add item")
//            let item = ShoppingItemView(image: item.image, designer: item.designer, name: item.name, size: item.size, id: item.id, color: item.color, price: item.price, status: item.status, quantity: item.quantity)
//            shoppingItemViews.append(item)
//
//        }
        
//        for (index, item) in shoppingItemViews.enumerated() {
//            containerView.addSubview(item)
//            print("add view")
//            containerView.addConstraints(withFormat: "H:|[v0]|", views: item)
//            if index == 0 {
//                containerView.addConstraints(withFormat: "V:|[v0(300)]", views: item)
//            } else {
//                containerView.addConstraints(withFormat: "V:[v0][v1(300)]", views: shoppingItemViews[index - 1] , item)
//            }
//
//        }
    
//        let shoppingItemViews = Array(repeating: ShoppingItemView(), count: 5)
//
//        for i in 0..<shoppingItemViews.count {
//
//            scrollView.addSubview(shoppingItemViews[i])
//            shoppingItemViews[i].backgroundColor = UIColor.red
//            if i == 0 {
//                scrollView.addConstraints(withFormat: "V:|[v0(50)]", views: shoppingItemViews[i])
//            } else {
//                scrollView.addConstraints(withFormat: "V:[v0]-12-[v1(50)]", views: shoppingItemViews[i-1], shoppingItemViews[i])
//            }
//            scrollView.addConstraints(withFormat: "H:|[v0]|", views: shoppingItemViews[i])
//
//        }
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        scrollView.setNeedsLayout()
        scrollView.layoutIfNeeded()
        containerView.setNeedsLayout()
        containerView.layoutIfNeeded()
        // resize scroll view to fit content(containerView)
        scrollView.contentSize.height = containerView.frame.height
    }
    
    @objc private func handleSegmentedControl(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0:
            print("seg 1")
        case 1:
            print("seg 2")
        default:
            assertionFailure()
        }
    }
    
    @objc private func handleCancelButton() {
        navigationController?.dismiss(animated: true, completion: nil)
    }
    
//------------------------------------------------------------------------------------------------
    
    
}

//------------------------------------------------------------------------------------------------
//------------------------------------------------------------------------------------------------

class ShoppingTableView: UITableView, UITableViewDelegate, UITableViewDataSource {
    private static let cellId = "shoppingId"
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return customer.shoppingBag.count
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ShoppingTableView.cellId, for: indexPath) as! ShoppingItemTableViewCell
        cell.backgroundColor = UIColor.green
        
        
        let item = customer.shoppingBag[indexPath.row]
        cell.productImageView.image = item.image
        cell.designerLabel.text = item.designer
        cell.productNameLabel.text = item.name
        cell.sizeLabel.text = "Size: \(item.size)"
        cell.codeLabel.text = "Code: \(item.id)"
        cell.colorLabel.text = "Color: \(item.color)"
        cell.priceLabel.text = "$\(item.price)"
        cell.statusLabel.text = item.status.uppercased()
        cell.quantityLabel.text = "Quantity: \(item.quantity)"
        
        return cell
    }
    
    override init(frame: CGRect, style: UITableView.Style) {
        super.init(frame: frame, style: UITableView.Style.grouped)
        self.register(ShoppingItemTableViewCell.self, forCellReuseIdentifier: ShoppingTableView.cellId)
        delegate = self
        dataSource = self
        self.contentInset = UIEdgeInsets(top: -35, left: 0, bottom: -38, right: 0)
        
        self.backgroundColor = .red
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 300
    }
    func tableView(_ tableView: UITableView, estimatedHeightForFooterInSection section: Int) -> CGFloat {
        return 0
    }
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 300
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let delete = UIContextualAction(style: UIContextualAction.Style.destructive, title: "delete") { (action, view, completionHandler) in
            customer.shoppingBag.remove(at: indexPath.row)
            self.deleteRows(at: [indexPath], with: UITableView.RowAnimation.automatic)
            completionHandler(true)
        }
        
        
        return UISwipeActionsConfiguration(actions: [delete])
    }
    
//    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
//        if (editingStyle == .delete) {
//            data.remove(at: indexPath.row)
//            reloadData()
//            // handle delete (by removing the data from your array and updating the tableview)
//        }
//    }
    
}


//------------------------------------------------------------------------------------------------
//------------------------------------------------------------------------------------------------

class ShoppingItemTableViewCell: UITableViewCell {
    override func prepareForReuse() {
        super.prepareForReuse()
        productImageView.image = nil
        designerLabel.text = nil
        productNameLabel.text = nil
        sizeLabel.text = nil
        codeLabel.text = nil
        colorLabel.text = nil
        priceLabel.text = nil
        statusLabel.text = nil
        quantityLabel.text = nil
    }
    let productImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = UIColor.clear
        imageView.image = UIImage(named: "searchImage")
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    let designerLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.helvetica(ofsize: 14)
        label.text = "Reem acra"
        label.backgroundColor = UIColor.clear
        label.lineBreakMode = NSLineBreakMode.byWordWrapping
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let productNameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.helvetica(ofsize: 14)
        label.text = "Cotton-blend poplin blouse"
        label.backgroundColor = UIColor.clear
        label.lineBreakMode = NSLineBreakMode.byWordWrapping
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let sizeLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.helvetica(ofsize: 14)
        label.backgroundColor = UIColor.clear
        label.text = "Size: US 8"
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let codeLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.helvetica(ofsize: 14)
        label.text = "Product code: 123456789"
        label.backgroundColor = UIColor.clear
        label.lineBreakMode = NSLineBreakMode.byWordWrapping
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let colorLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.helvetica(ofsize: 14)
        label.text = "Color: Dark denim"
        label.backgroundColor = UIColor.clear
        label.lineBreakMode = NSLineBreakMode.byWordWrapping
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let priceLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.helvetica(ofsize: 14)
        label.text = "$1,318"
        label.backgroundColor = UIColor.clear
        label.textColor = UIColor.colorFrom(hexString: "#b90000")
        label.lineBreakMode = NSLineBreakMode.byWordWrapping
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let statusLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.helvetica(ofsize: 11)
        label.text = "just 1 left"
        label.text = label.text?.uppercased()
        label.backgroundColor = UIColor.clear
        label.lineBreakMode = NSLineBreakMode.byWordWrapping
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let quantityLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.helvetica(ofsize: 14)
        label.text = "Quantity: 1"
        label.backgroundColor = UIColor.clear
        label.lineBreakMode = NSLineBreakMode.byWordWrapping
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let editButton: UIButton = {
        let button = UIButton(type: UIButton.ButtonType.system)
        button.setTitle("Edit", for: UIControl.State.normal)
        button.setTitleColor(UIColor.gray, for: UIControl.State.normal)
        button.backgroundColor = UIColor.clear
        button.translatesAutoresizingMaskIntoConstraints = false
        button.contentHorizontalAlignment = UIControl.ContentHorizontalAlignment.trailing
        return button
    }()
    
    let dividerLineView = DividerLineView()
    
//    override init(frame: CGRect) {
//        super.init(frame: frame)
//        self.backgroundColor = UIColor.clear
//        setupViews()
//    }
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = .blue
        setupViews()
    }
//    convenience init(image: UIImage, designer: String, name: String, size: String, id: String, color: String, price: NSNumber, status: String, quantity: NSNumber) {
//
//        self.productImageView.image = image
//        self.designerLabel.text = designer
//        self.productNameLabel.text = name
//        self.sizeLabel.text = "Size: \(size)"
//        self.codeLabel.text = "\(id)"
//        self.colorLabel.text = "Color: \(color)"
//        self.priceLabel.text = "$\(price)"
//        self.statusLabel.text = status.uppercased()
//        self.quantityLabel.text = "Quantity: \(quantity)"
//        self.backgroundColor = UIColor.clear
//        setupViews()
//    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        addSubview(productImageView)
        addSubview(designerLabel)
        addSubview(productNameLabel)
        addSubview(sizeLabel)
        addSubview(codeLabel)
        addSubview(colorLabel)
        addSubview(priceLabel)
        addSubview(statusLabel)
        addSubview(quantityLabel)
        addSubview(editButton)
        addSubview(dividerLineView)
        
        dividerLineView.translatesAutoresizingMaskIntoConstraints = false
        [
         // from top to bottom
         productImageView.topAnchor.constraint(equalTo: self.topAnchor, constant: 16),
         productImageView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
         productImageView.heightAnchor.constraint(equalToConstant: 200),
         productImageView.widthAnchor.constraint(equalToConstant: 120),
         
         designerLabel.leadingAnchor.constraint(equalTo: productImageView.trailingAnchor, constant: 12),
         designerLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor),
         designerLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 12),
         designerLabel.heightAnchor.constraint(equalToConstant: 18),
         
         productNameLabel.leadingAnchor.constraint(equalTo: productImageView.trailingAnchor, constant: 12),
         productNameLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor),
         productNameLabel.topAnchor.constraint(equalTo: designerLabel.bottomAnchor, constant: 12),
         productNameLabel.heightAnchor.constraint(equalToConstant: 18),
         
         sizeLabel.leadingAnchor.constraint(equalTo: productImageView.trailingAnchor, constant: 12),
         sizeLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor),
         sizeLabel.topAnchor.constraint(equalTo: productNameLabel.bottomAnchor, constant: 12),
         sizeLabel.heightAnchor.constraint(equalToConstant: 18),
         
         codeLabel.leadingAnchor.constraint(equalTo: productImageView.trailingAnchor, constant: 12),
         codeLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor),
         codeLabel.topAnchor.constraint(equalTo: sizeLabel.bottomAnchor, constant: 12),
         codeLabel.heightAnchor.constraint(equalToConstant: 18),

         colorLabel.leadingAnchor.constraint(equalTo: productImageView.trailingAnchor, constant: 12),
         colorLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor),
         colorLabel.topAnchor.constraint(equalTo: codeLabel.bottomAnchor, constant: 12),
         colorLabel.heightAnchor.constraint(equalToConstant: 18),
         
         priceLabel.leadingAnchor.constraint(equalTo: productImageView.trailingAnchor, constant: 12),
         priceLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor),
         priceLabel.topAnchor.constraint(equalTo: colorLabel.bottomAnchor, constant: 12),
         priceLabel.heightAnchor.constraint(equalToConstant: 18),
         
         statusLabel.leadingAnchor.constraint(equalTo: productImageView.trailingAnchor, constant: 12),
         statusLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor),
         statusLabel.topAnchor.constraint(equalTo: priceLabel.bottomAnchor, constant: 8),
         statusLabel.heightAnchor.constraint(equalToConstant: 15),
         
         quantityLabel.leadingAnchor.constraint(equalTo: productImageView.trailingAnchor, constant: 12),
         quantityLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor),
         quantityLabel.topAnchor.constraint(equalTo: statusLabel.bottomAnchor, constant: 12),
         quantityLabel.heightAnchor.constraint(equalToConstant: 18),
         
         
         // from bottom to top
         dividerLineView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
         dividerLineView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
         dividerLineView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
         dividerLineView.heightAnchor.constraint(equalToConstant: 1),
         
         editButton.bottomAnchor.constraint(equalTo: dividerLineView.topAnchor, constant: -4),
         editButton.trailingAnchor.constraint(equalTo: self.trailingAnchor),
         editButton.heightAnchor.constraint(equalToConstant: 20),
         editButton.widthAnchor.constraint(equalToConstant: 50)
         
            ].forEach { (constraint) in
            constraint.isActive = true
        }
        
    }
    
}
