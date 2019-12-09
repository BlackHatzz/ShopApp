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
    
    let shoppingCollectionView: ShoppingCollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = UICollectionView.ScrollDirection.vertical
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        let shoppingCollectionView = ShoppingCollectionView(frame: CGRect.zero, collectionViewLayout: layout)
        shoppingCollectionView.backgroundColor = UIColor.clear
        shoppingCollectionView.showsHorizontalScrollIndicator = false
        shoppingCollectionView.showsVerticalScrollIndicator = true
        shoppingCollectionView.translatesAutoresizingMaskIntoConstraints = false
        return shoppingCollectionView
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white
        
        setupViews()
        
        // set dataList in collection view
        shoppingCollectionView.dataList = customer.shoppingBag
        
        // after remove an item of dataList in shoppingCollectionView
        // also remove an item in shoppingBag
        // and append the removed item to wishList
        shoppingCollectionView.didHandleMoveItem = {(movedItem: ShoppingItem, index: Int) -> Void in
            customer.shoppingBag.remove(at: index)
            customer.wishList.append(movedItem)
        }
        
        // after remove an item of dataList in shoppingCollectionView
        // also remove an item in shoppingBag
        shoppingCollectionView.didRemoveItem = {(index: Int) -> Void in
            customer.shoppingBag.remove(at: index)
        }
        
        // set handler for segmentedControl
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
        
        scrollView.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 12).isActive = true
        scrollView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true
        scrollView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive = true
        scrollView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
        
        scrollView.addSubview(containerView)
        
        containerView.topAnchor.constraint(equalTo: scrollView.topAnchor).isActive = true
        containerView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 12).isActive = true
        containerView.widthAnchor.constraint(equalTo: scrollView.widthAnchor, constant: -24).isActive = true
        containerView.heightAnchor.constraint(equalToConstant: 900).isActive = true
        
        view.addSubview(shoppingCollectionView)
        
        view.addConstraints(withFormat: "H:|[v0]|", views: shoppingCollectionView)
        view.addConstraints(withFormat: "V:|[v0]|", views: shoppingCollectionView)
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
            // shopping bag
            shoppingCollectionView.dataList = customer.shoppingBag
            
            // after remove an item of dataList in shoppingCollectionView
            // also remove an item in shoppingBag
            // and append the removed item to wishList
            shoppingCollectionView.didHandleMoveItem = {(movedItem: ShoppingItem, index: Int) -> Void in
                customer.shoppingBag.remove(at: index)
                customer.wishList.append(movedItem)
            }
            
            // after remove an item of dataList in shoppingCollectionView
            // also remove an item in shoppingBag
            shoppingCollectionView.didRemoveItem = {(index: Int) -> Void in
                customer.shoppingBag.remove(at: index)
            }
            
            // change button type
            shoppingCollectionView.moveToAnotherListButtonType = .shoppingBag
            
            // reload data when all done
            DispatchQueue.main.async {
                self.shoppingCollectionView.reloadData()
            }
        case 1:
            // wish list
            shoppingCollectionView.dataList = customer.wishList
            
            // after remove an item of dataList in shoppingCollectionView
            // also remove an item in shoppingBag
            // and append the removed item to wishList
            shoppingCollectionView.didHandleMoveItem = {(movedItem: ShoppingItem, index: Int) -> Void in
                customer.wishList.remove(at: index)
                customer.shoppingBag.append(movedItem)
            }
            
            // after remove an item of dataList in shoppingCollectionView
            // also remove an item in wishList
            shoppingCollectionView.didRemoveItem = {(index: Int) -> Void in
                customer.wishList.remove(at: index)
            }
            
            // change button type
            shoppingCollectionView.moveToAnotherListButtonType = .wishList
            
            // reload data when all done
            DispatchQueue.main.async {
                self.shoppingCollectionView.reloadData()
            }
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

class ShoppingCollectionView: UICollectionView, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    private static let cellId = "shoppingId"
    var dataList: [ShoppingItem] = [ShoppingItem]()
    
    var didHandleMoveItem: ((_ movedItem: ShoppingItem, _ index: Int) -> Void)? = nil
    var didRemoveItem: ((_ index: Int) -> Void)? = nil
    
    enum MoveToAnotherListButtonType {
        case shoppingBag
        case wishList
    }
    var moveToAnotherListButtonType = MoveToAnotherListButtonType.shoppingBag
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataList.count
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ShoppingCollectionView.cellId, for: indexPath) as! ShoppingItemCell
        
        let item = dataList[indexPath.row]
        cell.productImageView.image = item.image
        cell.designerLabel.text = item.designer
        cell.productNameLabel.text = item.name
        cell.sizeLabel.text = "Size: \(item.size)"
        cell.codeLabel.text = "Code: \(item.id)"
        cell.colorLabel.text = "Color: \(item.color)"
        cell.priceLabel.text = "$\(item.price)"
        cell.statusLabel.text = item.status.uppercased()
        cell.quantityLabel.text = "Quantity: \(item.quantity)"
        
        switch moveToAnotherListButtonType {
        case .shoppingBag:
            cell.moveToAnotherListButton.iconImageView.image = UIImage(named: "heart")
            cell.moveToAnotherListButton.label.text = "Move to Wish List"
        case .wishList:
            cell.moveToAnotherListButton.iconImageView.image = UIImage(named: "shopping-bag")
            cell.moveToAnotherListButton.label.text = "Move to Bag"
        }

        cell.moveToAnotherListButton.tag = indexPath.row
        cell.moveToAnotherListButton.addTarget(self, action: #selector(handlemoveToAnotherListButton(_:)), for: UIControl.Event.touchUpInside)

        cell.removeToAnotherListButton.tag = indexPath.row
        cell.removeToAnotherListButton.addTarget(self, action: #selector(handleRemoveItem), for: UIControl.Event.touchUpInside)
        
        return cell
    }
    
    @objc private func handlemoveToAnotherListButton(_ sender: UIButton) {
        // move to wishList and delete item in shoppingBag
        DispatchQueue.main.async {
            let movedItem = self.dataList.remove(at: sender.tag)
            if let handler = self.didHandleMoveItem {
                handler(movedItem, sender.tag)
            }
            self.performBatchUpdates({
                self.deleteItems(at: [IndexPath(item: sender.tag, section: 0)])
            }, completion: { (finished) in
                let checkedView = NotificationView(title: "Updated", type: NotificationView.NotiType.checked)
                self.superview?.addSubview(checkedView) // auto delete checkedView from superview after a while
                self.reloadItems(at: self.indexPathsForVisibleItems)
            })
        }
    }
    
    @objc func handleRemoveItem(_ sender: UIButton) {
        DispatchQueue.main.async {
            self.dataList.remove(at: sender.tag)
            if let handler = self.didRemoveItem {
                handler(sender.tag)
            }
            print("remove", self.dataList, customer.shoppingBag)
            self.performBatchUpdates({
                self.deleteItems(at: [IndexPath(item: sender.tag, section: 0)])
            }, completion: { (finished) in
                self.reloadItems(at: self.indexPathsForVisibleItems)
            })
        }
    }
    
    override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        super.init(frame: frame, collectionViewLayout: layout)
        register(ShoppingItemCell.self, forCellWithReuseIdentifier: ShoppingCollectionView.cellId)
        delegate = self
        dataSource = self
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: self.frame.width, height: 300)
    }

    
}


//------------------------------------------------------------------------------------------------
//------------------------------------------------------------------------------------------------

class ShoppingItemCell: UICollectionViewCell {
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
        if rightViewContent == RightViewContent.productInfoList {
            productInfoListView.center.x = panGestureXFlag!
            interactionContainerView.center.x = interactionContainerViewXFlag!
        }
    }
    
    let leftContainerView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.white
        view.layer.zPosition = 1
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let productImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = UIColor.clear
        imageView.image = UIImage(named: "searchImage")
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    let rightContainerView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.clear
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let productInfoListView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.clear
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
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
    
    let interactionContainerView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(white: 0.9, alpha: 1)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    fileprivate let moveToAnotherListButton: InteractionButton = {
        let button = InteractionButton(image: UIImage(named: "heart"), title: "Move to Wish List")
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = UIColor.clear
        return button
    }()
    fileprivate let removeToAnotherListButton: InteractionButton = {
        let button = InteractionButton(image: UIImage(named: "trash"), title: "Remove Item")
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = UIColor.clear
        return button
    }()
    
    let dividerLineView = DividerLineView()
    
    
    private var panGestureXFlag: CGFloat? = nil
    private var endPanGestureCenterXFlag: CGFloat = 0.0
    private var interactionContainerViewXFlag: CGFloat? = nil
    private enum RightViewContent {
        case productInfoList
        case interactionButton
    }
    private var rightViewContent = RightViewContent.productInfoList
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.clear
        setupViews()
        
        let panLeft: PanDirectionGestureRecognizer = PanDirectionGestureRecognizer(direction: PanDirectionGestureRecognizer.Direction.horizontal, target: self, action: #selector(handleProductInfoListViewGesture(_:)))
        productInfoListView.addGestureRecognizer(panLeft)
        
        let panRight: PanDirectionGestureRecognizer = PanDirectionGestureRecognizer(direction: PanDirectionGestureRecognizer.Direction.horizontal, target: self, action: #selector(handleInteractionContainerViewGesture(_:)))
        interactionContainerView.addGestureRecognizer(panRight)
        
        editButton.addTarget(self, action: #selector(handleEditButton), for: UIControl.Event.touchUpInside)
        
        // get center x of productInfoListView to pan guesture
        DispatchQueue.main.async {
            self.setNeedsDisplay()
            self.panGestureXFlag = self.productInfoListView.center.x
            self.interactionContainerViewXFlag = self.interactionContainerView.center.x
        }
    }
    
    @objc func handleEditButton() {
        UIView.animate(withDuration: 0.3, delay: 0.0, options: UIView.AnimationOptions.curveLinear, animations: {
            self.productInfoListView.center.x = -self.panGestureXFlag!
            self.interactionContainerView.center.x = self.panGestureXFlag!
        }, completion: nil)
    }
    
    @objc func handleProductInfoListViewGesture(_ gesture: UIPanGestureRecognizer) {
        
        // gesture.view is productInfoListView
        if gesture.state == .began || gesture.state == .changed {
            if gesture.view!.center.x <= self.panGestureXFlag! && gesture.view!.center.x > self.endPanGestureCenterXFlag {
                let translation = gesture.translation(in: self.productInfoListView)
                // note: 'view' is optional and need to be unwrapped
                // change guesture.view(productInfoListView) x to follows user's finger
                gesture.view!.center = CGPoint(x: gesture.view!.center.x + translation.x, y: gesture.view!.center.y)
                //  change interactionContainerView x to follow productInfoListView
                self.interactionContainerView.center = CGPoint(x: interactionContainerView.center.x + translation.x, y: interactionContainerView.center.y)
                
                // set translate of gesture
                gesture.setTranslation(CGPoint.zero, in: self.productInfoListView)
            } else if gesture.view!.center.x <= self.endPanGestureCenterXFlag {
                UIView.animate(withDuration: 0.3, delay: 0.0, options: UIView.AnimationOptions.curveLinear, animations: {
                    // push gesture.view(productInfoListView) to left
                    gesture.view!.center = CGPoint(x: -gesture.view!.frame.width / 2, y: gesture.view!.center.y)
                    
                    // show interactionContainerView
                    self.interactionContainerView.center.x = self.panGestureXFlag!
                }, completion: nil)
                
            }
            
            // if gesture state is began or changed
        } else if gesture.state == .ended {
            // push two component: productInfoListView & interactionContainerView to left
            if gesture.view!.center.x <= self.panGestureXFlag!/3 {
                UIView.animate(withDuration: 0.2, delay: 0.0, options: UIView.AnimationOptions.curveLinear, animations: {
                    self.interactionContainerView.center.x = self.panGestureXFlag!
                    self.productInfoListView.center.x = -self.panGestureXFlag!
                }, completion: nil)
                // change status when push content
                self.rightViewContent = RightViewContent.productInfoList
            } else {
                // push productInfoListView & interactionContainerView to previous position
                UIView.animate(withDuration: 0.2, delay: 0.0, options: UIView.AnimationOptions.curveLinear, animations: {
                    self.interactionContainerView.center.x = self.interactionContainerViewXFlag!
                    self.productInfoListView.center.x = self.panGestureXFlag!
                }, completion: nil)
            }
        } // if gesture state is ended
    } // end of handleProductInfoListViewGesture
    
    @objc func handleInteractionContainerViewGesture(_ gesture: UIPanGestureRecognizer) {
        // gesture is interactionContainerView
        if gesture.state == .began || gesture.state == .changed {
            if gesture.view!.center.x >= panGestureXFlag! && gesture.view!.center.x < gesture.view!.frame.width {
                let translation = gesture.translation(in: self.interactionContainerView)
                
                gesture.view!.center = CGPoint(x: gesture.view!.center.x + translation.x, y: gesture.view!.center.y)
                //  change productInfoListView x to follow interactionContainerView
                self.productInfoListView.center.x = productInfoListView.center.x + translation.x
                
                // set translate of gesture
                gesture.setTranslation(CGPoint.zero, in: interactionContainerView)
            } else if gesture.view!.center.x >= gesture.view!.frame.width {
                UIView.animate(withDuration: 0.3, delay: 0.0, options: UIView.AnimationOptions.curveLinear, animations: {
                    self.productInfoListView.center.x = -self.panGestureXFlag!
                    // here
                    self.interactionContainerView.center.x = self.panGestureXFlag!
                }, completion: nil)
            }
        
            // if gesture state is began or changed
        } else if gesture.state == .ended {
            // push two component: productInfoListView & interactionContainerView to right
            if gesture.view!.center.x >= panGestureXFlag!/3 + panGestureXFlag! && gesture.view!.center.x > self.panGestureXFlag! {
                UIView.animate(withDuration: 0.2, delay: 0.0, options: UIView.AnimationOptions.curveLinear, animations: {
                    self.interactionContainerView.center.x = self.interactionContainerViewXFlag!
                    self.productInfoListView.center.x = self.panGestureXFlag!
                }, completion: nil)
                // change status when push content
                self.rightViewContent = RightViewContent.interactionButton
                print("end", self.interactionContainerView.center.x, self.interactionContainerViewXFlag!)
            } else {
                // push productInfoListView & interactionContainerView to previous position
                UIView.animate(withDuration: 0.2, delay: 0.0, options: UIView.AnimationOptions.curveLinear, animations: {
                    self.interactionContainerView.center.x = self.panGestureXFlag!
                    self.productInfoListView.center.x = -self.productInfoListView.frame.width/2
                }, completion: nil)
            }
        } // if gesture state is ended
    } // end of handleInteractionContainerViewGesture
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        
        addSubview(leftContainerView)
        leftContainerView.addSubview(productImageView)
        
        addSubview(rightContainerView)
        
        rightContainerView.addSubview(productInfoListView)
        productInfoListView.addSubview(designerLabel)
        productInfoListView.addSubview(productNameLabel)
        productInfoListView.addSubview(sizeLabel)
        productInfoListView.addSubview(codeLabel)
        productInfoListView.addSubview(colorLabel)
        productInfoListView.addSubview(priceLabel)
        productInfoListView.addSubview(statusLabel)
        productInfoListView.addSubview(quantityLabel)
        productInfoListView.addSubview(editButton)
        
        rightContainerView.addSubview(interactionContainerView)
        interactionContainerView.addSubview(moveToAnotherListButton)
        interactionContainerView.addSubview(removeToAnotherListButton)
        
        addSubview(dividerLineView)
        
        dividerLineView.translatesAutoresizingMaskIntoConstraints = false
        [
         // from bottom to top
         dividerLineView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
         dividerLineView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 12),
         dividerLineView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: 12),
         dividerLineView.heightAnchor.constraint(equalToConstant: 1),
            
         // from top to bottom
         // left content
         leftContainerView.topAnchor.constraint(equalTo: self.topAnchor),
         leftContainerView.leftAnchor.constraint(equalTo: self.leftAnchor),
         leftContainerView.bottomAnchor.constraint(equalTo: dividerLineView.topAnchor),
         leftContainerView.widthAnchor.constraint(equalToConstant: 120 + 12),
            
            
         productImageView.topAnchor.constraint(equalTo: leftContainerView.topAnchor, constant: 16),
         productImageView.leftAnchor.constraint(equalTo: leftContainerView.leftAnchor, constant: 12),
         productImageView.rightAnchor.constraint(equalTo: leftContainerView.rightAnchor),
         productImageView.heightAnchor.constraint(equalToConstant: 200),
         
         // right content
         rightContainerView.topAnchor.constraint(equalTo: self.topAnchor),
         rightContainerView.rightAnchor.constraint(equalTo: self.rightAnchor),
         rightContainerView.bottomAnchor.constraint(equalTo: dividerLineView.topAnchor),
         rightContainerView.leftAnchor.constraint(equalTo: leftContainerView.rightAnchor),
         
         // container view contain all info of product
         productInfoListView.topAnchor.constraint(equalTo: rightContainerView.topAnchor),
         productInfoListView.leftAnchor.constraint(equalTo: rightContainerView.leftAnchor),
         productInfoListView.rightAnchor.constraint(equalTo: rightContainerView.rightAnchor),
         productInfoListView.bottomAnchor.constraint(equalTo: rightContainerView.bottomAnchor),
         
         designerLabel.leadingAnchor.constraint(equalTo: productInfoListView.leadingAnchor, constant: 12),
         designerLabel.trailingAnchor.constraint(equalTo: productInfoListView.trailingAnchor),
         designerLabel.topAnchor.constraint(equalTo: productInfoListView.topAnchor, constant: 12),
         designerLabel.heightAnchor.constraint(equalToConstant: 18),
         
         productNameLabel.leadingAnchor.constraint(equalTo: productInfoListView.leadingAnchor, constant: 12),
         productNameLabel.trailingAnchor.constraint(equalTo: productInfoListView.trailingAnchor),
         productNameLabel.topAnchor.constraint(equalTo: designerLabel.bottomAnchor, constant: 12),
         productNameLabel.heightAnchor.constraint(equalToConstant: 18),
         
         sizeLabel.leadingAnchor.constraint(equalTo: productInfoListView.leadingAnchor, constant: 12),
         sizeLabel.trailingAnchor.constraint(equalTo: productInfoListView.trailingAnchor),
         sizeLabel.topAnchor.constraint(equalTo: productNameLabel.bottomAnchor, constant: 12),
         sizeLabel.heightAnchor.constraint(equalToConstant: 18),
         
         codeLabel.leadingAnchor.constraint(equalTo: productInfoListView.leadingAnchor, constant: 12),
         codeLabel.trailingAnchor.constraint(equalTo: productInfoListView.trailingAnchor),
         codeLabel.topAnchor.constraint(equalTo: sizeLabel.bottomAnchor, constant: 12),
         codeLabel.heightAnchor.constraint(equalToConstant: 18),

         colorLabel.leadingAnchor.constraint(equalTo: productInfoListView.leadingAnchor, constant: 12),
         colorLabel.trailingAnchor.constraint(equalTo: productInfoListView.trailingAnchor),
         colorLabel.topAnchor.constraint(equalTo: codeLabel.bottomAnchor, constant: 12),
         colorLabel.heightAnchor.constraint(equalToConstant: 18),
         
         priceLabel.leadingAnchor.constraint(equalTo: productInfoListView.leadingAnchor, constant: 12),
         priceLabel.trailingAnchor.constraint(equalTo: productInfoListView.trailingAnchor),
         priceLabel.topAnchor.constraint(equalTo: colorLabel.bottomAnchor, constant: 12),
         priceLabel.heightAnchor.constraint(equalToConstant: 18),
         
         statusLabel.leadingAnchor.constraint(equalTo: productInfoListView.leadingAnchor, constant: 12),
         statusLabel.trailingAnchor.constraint(equalTo: productInfoListView.trailingAnchor),
         statusLabel.topAnchor.constraint(equalTo: priceLabel.bottomAnchor, constant: 8),
         statusLabel.heightAnchor.constraint(equalToConstant: 15),
         
         quantityLabel.leadingAnchor.constraint(equalTo: productInfoListView.leadingAnchor, constant: 12),
         quantityLabel.trailingAnchor.constraint(equalTo: productInfoListView.trailingAnchor),
         quantityLabel.topAnchor.constraint(equalTo: statusLabel.bottomAnchor, constant: 12),
         quantityLabel.heightAnchor.constraint(equalToConstant: 18),
         
         editButton.bottomAnchor.constraint(equalTo: productInfoListView.bottomAnchor, constant: -4),
         editButton.rightAnchor.constraint(equalTo: productInfoListView.rightAnchor, constant: -8),
         editButton.heightAnchor.constraint(equalToConstant: 20),
         editButton.widthAnchor.constraint(equalToConstant: 50),
         
         // container view contains buttons to interact with cell
         interactionContainerView.leftAnchor.constraint(equalTo: productInfoListView.rightAnchor),
         interactionContainerView.topAnchor.constraint(equalTo: rightContainerView.topAnchor),
         interactionContainerView.bottomAnchor.constraint(equalTo: rightContainerView.bottomAnchor),
         interactionContainerView.widthAnchor.constraint(equalTo: productInfoListView.widthAnchor),
         
         moveToAnotherListButton.leftAnchor.constraint(equalTo: interactionContainerView.leftAnchor),
         moveToAnotherListButton.topAnchor.constraint(equalTo: interactionContainerView.topAnchor),
         moveToAnotherListButton.bottomAnchor.constraint(equalTo: bottomAnchor),
         moveToAnotherListButton.widthAnchor.constraint(equalTo: interactionContainerView.widthAnchor, multiplier: 0.5),
         
         removeToAnotherListButton.rightAnchor.constraint(equalTo: interactionContainerView.rightAnchor),
         removeToAnotherListButton.topAnchor.constraint(equalTo: interactionContainerView.topAnchor),
         removeToAnotherListButton.bottomAnchor.constraint(equalTo: bottomAnchor),
         removeToAnotherListButton.widthAnchor.constraint(equalTo: interactionContainerView.widthAnchor, multiplier: 0.5)
         
            ].forEach { (constraint) in
            constraint.isActive = true
        }
    } // setupViews
}

fileprivate class InteractionButton: UIButton {
    let containerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor.clear
        view.isUserInteractionEnabled = false
        return view
    }()
    let iconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.backgroundColor = UIColor.clear
        return imageView
    }()
    let label: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.backgroundColor = UIColor.clear
        label.font = UIFont.helvetica(ofsize: 12)
        label.textAlignment = NSTextAlignment.center
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        // setupViews
        setupViews()
    }
    
    convenience init(image: UIImage?, title: String?) {
        self.init(frame: CGRect.zero)
        iconImageView.image = image
        label.text = title
    }
    
    private func setupViews() {
        addSubview(containerView)
        
        containerView.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        containerView.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        containerView.widthAnchor.constraint(equalTo: self.widthAnchor).isActive = true
        containerView.heightAnchor.constraint(equalToConstant: 56).isActive = true
        
        containerView.addSubview(iconImageView)
        containerView.addSubview(label)
        
        iconImageView.topAnchor.constraint(equalTo: containerView.topAnchor).isActive = true
        iconImageView.centerXAnchor.constraint(equalTo: containerView.centerXAnchor).isActive = true
        iconImageView.widthAnchor.constraint(equalToConstant: 24).isActive = true
        iconImageView.heightAnchor.constraint(equalToConstant: 24).isActive = true
        
        label.topAnchor.constraint(equalTo: iconImageView.bottomAnchor, constant: 16).isActive = true
        label.leadingAnchor.constraint(equalTo: containerView.leadingAnchor).isActive = true
        label.trailingAnchor.constraint(equalTo: containerView.trailingAnchor).isActive = true
        label.heightAnchor.constraint(equalToConstant: 16).isActive = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


