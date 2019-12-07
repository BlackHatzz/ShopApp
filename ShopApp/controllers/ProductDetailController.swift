//
//  ProductDetailController.swift
//  ShopApp
//
//  Created by Nguyễn Đức Huy on 7/19/19.
//  Copyright © 2019 Nguyễn Đức Huy. All rights reserved.
//

import UIKit
import Firebase

//private var productImages = [Int: [Int: UIImage]]()
private var currentIndexProductImages: Int = 0
private var product: Product? = nil

class ProductDetailController: UIViewController, UIScrollViewDelegate, UICollectionViewDelegateFlowLayout, UICollectionViewDelegate, UICollectionViewDataSource {
    var databaseRef: DatabaseReference? = Database.database().reference(fromURL: "https://shopapp-96ec7.firebaseio.com/")
    
    let notificationLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = NSTextAlignment.center
        label.font = UIFont.helvetica(ofsize: 16)
        label.backgroundColor = UIColor.clear
        label.translatesAutoresizingMaskIntoConstraints = false
        label.isHidden = true
        return label
    }()
    var notificationLabelHeightConstraint: NSLayoutConstraint? = nil
    
    let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.alwaysBounceHorizontal = false
        scrollView.alwaysBounceVertical = true
        scrollView.isHidden = true
        return scrollView
    }()
    
    private let cellId = "productDetailCellId"
    let productContainerView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.white
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    let productNameLabel = ProductNameLabel()
    
    
    let productCollectionView: ProductCollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        let collectionView = ProductCollectionView(frame: CGRect.zero
            , collectionViewLayout: layout)
        collectionView.isPagingEnabled = true
        collectionView.backgroundColor = UIColor.white
        collectionView.showsVerticalScrollIndicator = false
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        
        return collectionView
    }()
    let productPageControl: UIPageControl = {
        let pageControl = UIPageControl()
        pageControl.currentPage = 0
        pageControl.currentPageIndicatorTintColor = UIColor.black
        pageControl.hidesForSinglePage = true
        pageControl.pageIndicatorTintColor = UIColor.lightGray
        pageControl.isUserInteractionEnabled = false
        return pageControl
    }()
    let colorTitleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.helveticaNeue(ofsize: 14)
        label.backgroundColor = UIColor.clear
//        label.contentMode = UIView.ContentMode.center
        label.text = "Colors: "
        return label
    }()
    let colorMenu: ColorMenu = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = UICollectionView.ScrollDirection.horizontal
        layout.minimumInteritemSpacing = 5
        let collectionView = ColorMenu(frame: CGRect.zero, collectionViewLayout: layout)
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.backgroundColor = UIColor.clear
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = UIColor.clear
        return collectionView
    }()
    
    let discountPriceLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = UIFont.helveticaNeue(ofsize: 18)
        label.textColor = UIColor.red
        label.text = "$1,009"
        return label
    }()
    let olddiscountPriceLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .right
        label.font = UIFont.helveticaNeue(ofsize: 16)
        label.text = "Was $1,683"
        return label
    }()
    let discountLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.helveticaNeue(ofsize: 16)
        label.text = "40% off"
        return label
    }()
    let productStatusLabel = ProductStatusLabel()
    
    let sizeCollectionView: SizeCollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = UICollectionView.ScrollDirection.horizontal
        layout.minimumInteritemSpacing = 10
        let collectionView = SizeCollectionView(frame: CGRect.zero, collectionViewLayout: layout)
        collectionView.backgroundColor = UIColor.clear
        collectionView.showsVerticalScrollIndicator = false
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()
    
    let addToBagButton: UIButton = {
        let button = UIButton(type: UIButton.ButtonType.system)
        button.setTitle("Add To Bag", for: UIControl.State.normal)
        button.backgroundColor = UIColor.black
        button.titleLabel?.font = UIFont.helveticaNeue(ofsize: 16)
        button.setTitleColor(UIColor.white, for: UIControl.State.normal)
        return button
    }()
    let addToWishListButton: UIButton = {
        let button = UIButton(type: UIButton.ButtonType.system)
        button.setTitle("Add To Wish List", for: UIControl.State.normal)
        button.setTitleColor(UIColor.black, for: UIControl.State.normal)
        button.titleLabel?.font = UIFont.helveticaNeue(ofsize: 16)
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.init(white: 0.75, alpha: 1).cgColor
        return button
    }()
    let productDetailInfo = ProductDetailInfo(withTitle: "Product Detail", infoText: "")
    
    let productCompositionLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.helveticaNeue(ofsize: 12)
        label.text = "Composition: "
        return label
    }()
    let productCodeLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.helveticaNeue(ofsize: 12)
        label.text = "Product code: "
        return label
    }()
    let productColorLabel: UILabel = {
        let label = UILabel()
        label.text = "Color: Black"
        label.font = UIFont.helveticaNeue(ofsize: 12)
        return label
    }()
    let productSizeAndFitInfo = ProductSizeAndFitInfo(withTitle: "Size and Fit")
    
    let callUsButton = ConnectionButton(image: UIImage(named: "phone"), labelText: "Call Us")
    let emailUsButton = ConnectionButton(image: UIImage(named: "email"), labelText: "Email Us")
    
// --------------------------------------------------------------------------------
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return product?.imageUrls[currentIndexProductImages]?.count ?? 0
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: self.view.frame.width, height: 400)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        productPageControl.currentPage = Int(scrollView.contentOffset.x) / Int(scrollView.frame.width)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! SlideProductCell
        
        cell.productImageView.image = product?.images[currentIndexProductImages]?[indexPath.row]
        
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        let productCell = cell as! SlideProductCell
        
        if self.productCollectionView.statusCell.count - 1 >= indexPath.row {
            if self.productCollectionView.statusCell[indexPath.row] == SlideProductCell.StatusCellKey.loading {
                productCell.productImageView.isHidden = true
                productCell.activityIndicatorView.startAnimating()
            } else {
                productCell.productImageView.isHidden = false
                productCell.activityIndicatorView.stopAnimating()
            }
        }

    }
    
// --------------------------------------------------------------------------------
    
    convenience init(ofProduct currentProduct: Product) {
        self.init()
        
        self.scrollView.isHidden = false
//        self.productCollectionView.backgroundColor = UIColor.black
        
////        self.databaseRef?.removeAllObservers()
////        self.databaseRef = nil
//
        
        
        self.productCollectionView.reloadData()
        self.colorMenu.reloadData()
        
        product = currentProduct
        guard let product = product else {
            assertionFailure("product can not be nil")
            return
        }
        
        self.colorMenu.performBatchUpdates(nil) { (_) in
            self.setContent()
        }
        
        self.productPageControl.numberOfPages = product.imageUrls[currentIndexProductImages]?.count ?? 0
        
        // download missed image of current product
        // get the quantity of images and imageUrls
        if let imagesCount = product.images[currentIndexProductImages]?.count, let imagesUrlCount = product.imageUrls[currentIndexProductImages]?.count {
            
            // get images of product
            if let imageUrls = product.imageUrls[currentIndexProductImages] {
                
                // get images of product
                if var temp = product.images[currentIndexProductImages] {
                    
                    // if the quantity images is smaller than the quantity is imageUrls
                    // download the remain images
                    if imagesCount < imagesUrlCount {
                        
                        for i in imagesCount..<imagesUrlCount {
                            Product.loadImageFromStorage(fromURLString: imageUrls[i]) { (result: UIImage?) in
                                temp[i] = result
                                product.images[currentIndexProductImages] = temp
                                
                                self.productCollectionView.reloadData()
                            }
                        } // loop over imageUrls
                    } // check condition imagesCount and imagesUrlCount
                }
                
            }
            
        }
    }
    
//    convenience init(productId: String) {
//        self.init()
//
//        if let temp = productCache.object(forKey: productId as AnyObject) {
//            product = temp
//
//            self.productPageControl.numberOfPages = product?.images[currentIndexProductImages]?.count ?? 0
//
//            self.scrollView.isHidden = false
//
//            self.productCollectionView.reloadData()
//            self.databaseRef?.removeAllObservers()
//            self.databaseRef = nil
//
//            productCollectionView.performBatchUpdates(nil) { (_) in
//                self.setContent()
//            }
//
////            self.setContent()
//
//            print("cache")
//            dump(productCache.object(forKey: productId as AnyObject))
//
//        } else {
//            // load product from product id
//            databaseRef?.child("product").child(productId).observeSingleEvent(of: DataEventType.value, with: { (snapshot) in
//                if let dictionary = snapshot.value as? [String: Any] {
//                    product = Product(id: productId, productInfo: dictionary)
//                    product!.id = snapshot.key
//
//                    productCache.setObject(product!, forKey: productId as AnyObject)
//
//                    dump(product!)
//
//                    Product.loadImageFromStorage(fromURLStrings: product!.imageUrls[currentIndexProductImages]!, completion: { (result: [Int: UIImage]) in
//                        product?.images[currentIndexProductImages] = result
//
//                        self.productPageControl.numberOfPages = result.count
//
//                        self.scrollView.isHidden = false
//
//                        self.productCollectionView.reloadData()
//                        self.databaseRef?.removeAllObservers()
//                        self.databaseRef = nil
//
//                        self.productCollectionView.performBatchUpdates(nil) { (_) in
//                            self.setContent()
//                        }
//                    })
////                    self.setContent()
//                }
//            })
//        }
//
//    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        typealias key = Product.InfoKey
        
        // when select a option in colorMenu
        self.colorMenu.didSelectItemHandler = {(_, indexPath) in
            currentIndexProductImages = indexPath.row
            
            // if selected element not in memory
            if product?.images[currentIndexProductImages] == nil {
                self.productCollectionView.statusCell = Array(repeating: ProductCollectionView.StatusCellKey.loading, count: product!.imageUrls[currentIndexProductImages]!.count)
                self.productCollectionView.reloadData()
                
                
                self.productCollectionView.performBatchUpdates(nil, completion: { (_) in
                    var temp = [Int: UIImage]()
                    for (index, imageUrl) in product!.imageUrls[currentIndexProductImages]!.enumerated() {
                        Product.loadImageFromStorage(fromURLString: imageUrl, completion: { (result: UIImage?) in
                            temp[index] = result
                            product!.images[currentIndexProductImages] = temp
                            
                            self.productCollectionView.statusCell[index] = ProductCollectionView.StatusCellKey.loaded
                            self.productCollectionView.reloadData()
                        })
                    }
                })
                
                
                
                
//                Product.loadImageFromStorage(fromURLStrings: product!.imageUrls![currentIndexProductImages]!, handleEachResult: { (index, result) in
//                    print("each result:", index, result)
//                    temp[0] = [index: result]
//                    print("each2", temp)
//                }, completion: { (finalResult: [Int : UIImage]) in
//                    print("final result", finalResult)
//                    print("each2", temp)
//                })
                
                
                // hide all image
//                self.productCollectionView.visibleCells.forEach({ (cell) in
//                    let productCell = cell as! SlideProductCell
//                    productCell.productImageView.isHidden = true
//                    productCell.activityIndicatorView.startAnimating()
//                })
                
                // indicator in productView start when chose another option not in memory
                
//                self.productCollectionView.activityIndicatorView.startAnimating()
//                Product.loadImageFromStorage(fromURLStrings: product!.imageUrls![currentIndexProductImages]!) { (result: [Int : UIImage]) in
//                    product?.images[currentIndexProductImages] = result // set new current index = new result(images from database)
//                    self.productCollectionView.reloadData() // reload when download images from database are all done
//
//                    // when collectionView is completed reload data
//                    self.productCollectionView.performBatchUpdates(nil, completion: { (_) in
//                        self.productCollectionView.activityIndicatorView.stopAnimating()
//                        self.productCollectionView.visibleCells.forEach({ (cell) in
//                            let productCell = cell as! SlideProductCell
//                            productCell.productImageView.isHidden = false
//                        })
//                    })
//                }
            } else {
                self.productCollectionView.reloadData()
            }
            
        }
        
        //        self.navigationItem.title = "ADIDAS"
        //        let detail = """
        //        ow-top sneakers
        //        Knitted
        //        Laminated effect
        //        Designer stamp
        //        Lace-up front
        //        Lined in fabric
        //        Rubber sole
        //        Pull tabs
        //        Imported
        //        """
        //        let url = [
        //        "https://firebasestorage.googleapis.com/v0/b/shopapp-96ec7.appspot.com/o/product-image-name%2F0%2F0-0.jpg?alt=media&token=ffb1613e-11df-4261-968c-00bca537f962",
        //        "https://firebasestorage.googleapis.com/v0/b/shopapp-96ec7.appspot.com/o/product-image-name%2F0%2F0-1.jpg?alt=media&token=edb77e7c-fe66-4c1b-9155-393b83224b34",
        //        "https://firebasestorage.googleapis.com/v0/b/shopapp-96ec7.appspot.com/o/product-image-name%2F0%2F0-2.jpg?alt=media&token=59536481-f5f2-48e8-878b-9423ea3bbbae",
        //        "https://firebasestorage.googleapis.com/v0/b/shopapp-96ec7.appspot.com/o/product-image-name%2F0%2F0-3.jpg?alt=media&token=7fa02635-83f0-47f7-bd10-a61dd2f879c6"
        //        ]
        
        //        let dictionary: [String: Any] = [
        //            key.name: "adidas original",
        //            key.designer: "Arkyn stretch-knit sneakers",
        //            key.discountPrice: 84,
        //            key.price: 130,
        //            key.status: "just in",
        //            key.hexColors: [Product.HexColor.black],
        //            key.sizes: ["UK 3.5", "UK 4", "UK 4.5", "UK 5", "UK 5.5", "UK 6", "UK 6.5", "UK 7"],
        //            key.detail: detail,
        //            key.composition: ["textile fibers", "rubber"],
        //            key.textColor: "black",
        //            key.imageUrls: url
        //            ]
        //        static let name = "name"
        //        static let imageUrls = "imageUrls"
        //        static let sizes = "sizes"
        //        static let discountPrice = "discountPrice"
        //        static let price = "price"
        //        static let quantity = "quantity"
        //        static let discount = "discount"
        //        static let description = "description"
        //        static let category = "category"
        //        static let designer = "designer"
        //        static let status = "status"
        //        static let composition = "composition"
        //        static let hexColors = "hexColors"
        
        //        databaseRef?.child("product").childByAutoId().updateChildValues(dictionary, withCompletionBlock: { (error, ref) in
        //            if let error = error {
        //                print(error)
        //            }
        //        })
        
        
        self.view.backgroundColor = UIColor.white
        productCollectionView.delegate = self
        productCollectionView.dataSource = self
        productCollectionView.register(SlideProductCell.self, forCellWithReuseIdentifier: cellId)
        
        setupViews()
        self.addToBagButton.addTarget(self, action: #selector(handleAddToBag), for: UIControl.Event.touchUpInside)
        sizeCollectionView.productSizes = ["UK 6", "UK 7", "UK 8", "UK 9", "UK 10", "UK 11", "UK 12", "UK 13"]
    }
    
    func changeNotificationLabelStatus(withContent content: String, isHidden: Bool) {
        notificationLabel.text = content
        if isHidden {
            // hide notification label
            
            notificationLabel.backgroundColor = UIColor.clear
            UIView.animate(withDuration: 0.2, animations: {
                self.notificationLabelHeightConstraint?.constant = 1
                self.view.layoutIfNeeded()
            }) { (_) in
                self.notificationLabel.isHidden = true
            }
        } else {
            // show notification label
            self.notificationLabel.isHidden = false
            notificationLabel.backgroundColor = UIColor.rgb(204, 152, 159)
            UIView.animate(withDuration: 0.2, animations: {
                self.notificationLabelHeightConstraint?.constant = 20
                self.view.layoutIfNeeded()
            })
        }
    }
    
    @objc func handleAddToBag(_ sender: UIButton) {
        print("add to bag")
        if self.sizeCollectionView.selectedSize == nil {
            print("no size")
            
//            notificationLabel.text = "Please select a size"
//            notificationLabel.backgroundColor = UIColor.rgb(204, 152, 159)
//            UIView.animate(withDuration: 0.2) {
//                self.notificationLabelHeightConstraint?.constant = 20
//                self.view.layoutIfNeeded()
//            }
            if notificationLabel.isHidden {
                changeNotificationLabelStatus(withContent: "Please select a size", isHidden: false)
            } else {
                notificationLabel.text = "Please select a size"
            }
            
        } else {
            print("size")
            
            
            if let product = product {
                // change notification label
                if notificationLabel.isHidden {
                    changeNotificationLabelStatus(withContent: "Added to bag", isHidden: false)
                } else {
                    notificationLabel.text = "Added to bag"
                }
                
                // get init values of product
                let id: String = product.id
                let image: UIImage = product.images[currentIndexProductImages]![0]!
                let designer: String = product.designer!
                let name: String = product.name!
                let size: String = self.sizeCollectionView.selectedSize!
                let color: String = product.textColors![currentIndexProductImages]
                let price: NSNumber = product.price!
                let status: String = product.status!
                let quantity: NSNumber = product.quantity
                
                let shoppingItem = ShoppingItem(id: id, image: image, designer: designer, name: name, size: size, color: color, price: price, status: status, quantity: quantity)
                customer.shoppingBag.append(shoppingItem)
                print("shoppingItem:")
                dump(shoppingItem)
//                self.id = id
//                self.designer = designer
//                self.name = name
//                self.size = size
//                self.color = color
//                self.price = price
//                self.status = status
//                self.quantity = quantity
            } else {
                assertionFailure("product cannot be nil")
            }
            
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.hidesBarsOnSwipe = true
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.databaseRef?.removeAllObservers()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        currentIndexProductImages = 0
    }
    
    
    private func setContent() {
        guard let product = product else {
            assertionFailure("product can not be nil")
            return
        }
        
        // set all info of product
        
        self.navigationItem.title = product.designer
        
        if let name = product.name {
            self.productNameLabel.customedText = name
        }
        
        if let hexColors = product.hexColors {
            if !hexColors.isEmpty {
                self.colorMenu.hexColorsList = hexColors
                
                
                self.colorMenu.reloadData()
                
                self.colorMenu.performBatchUpdates(nil) { (_) in
                    self.colorMenu.selectItem(at: IndexPath(item: 0, section: 0), animated: false, scrollPosition: UICollectionView.ScrollPosition.left)
                    print("zz", self.colorMenu.numberOfItems(inSection: 0))
                    let firstResponderCell = self.colorMenu.cellForItem(at: IndexPath(item: 0, section: 0)) as? ColorMenu.ColorOption
                    if let firstResponderCell = firstResponderCell {
                        firstResponderCell.bottomLineView.isHidden = false
                    }
                    
                }
            }
        }
        
        if let status = product.status {
            self.productStatusLabel.customedText = status
        }
        if let originalPrice = product.price {
            self.olddiscountPriceLabel.text = "Was $\(originalPrice)"
        }
        if let discount = product.discount {
            self.discountLabel.text = "\(discount)% off"
            
            var discountPrice: Float = product.price!.floatValue * discount.floatValue / 100
            discountPrice = round(discountPrice*100)/100
            self.discountPriceLabel.text = "$\(discountPrice)"
        }
        
        if let detail = product.detail {
            self.productDetailInfo.detailTextView.customedText = detail
        }
        
        self.productSizeAndFitInfo.infoTextView.customedText = product.sizeAndFit
        if self.productSizeAndFitInfo.infoTextView.customedText == nil {
            self.productSizeAndFitInfo.superview?.constraints.forEach({ (constraint) in
                if constraint.firstItem === self.productSizeAndFitInfo {
                    if constraint.secondItem == nil {
                        if constraint.firstAttribute == .height {
                            constraint.constant = 0
                            self.productSizeAndFitInfo.removeAllSubviews()
                        }
                    }
                }
            })
        }
        
        if let composition = product.composition {
            self.productCompositionLabel.text = "Composition: "
            for i in composition {
                self.productCompositionLabel.text?.append(contentsOf: "\(i.capitalized), ")
            }
            self.productCompositionLabel.text = String(self.productCompositionLabel.text!.dropLast(2))
        }
        
        if let textColors = product.textColors {
            if !textColors.isEmpty {
                self.productColorLabel.text = "Color: \(textColors[0].capitalized)"
            }
        }
        
        self.productCodeLabel.text = "Product code: \(product.id)"
        
    }
    
// --------------------------------------------------------------------------------------------------------
    private func setupViews() {
        view.addSubview(scrollView)
        self.view.addSubview(notificationLabel)
        
        // setup notification label
        notificationLabel.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        notificationLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        notificationLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        notificationLabelHeightConstraint = notificationLabel.heightAnchor.constraint(equalToConstant: 1)
        
        notificationLabelHeightConstraint?.isActive = true
        // set up main scroll view
        scrollView.topAnchor.constraint(equalTo: notificationLabel.bottomAnchor).isActive = true
        scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        scrollView.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        
        // set up product view
        scrollView.addSubview(productContainerView)
        productContainerView.topAnchor.constraint(equalTo: scrollView.topAnchor).isActive = true
        productContainerView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor).isActive = true
        productContainerView.widthAnchor.constraint(equalTo: scrollView.widthAnchor).isActive = true
        productContainerView.heightAnchor.constraint(equalToConstant: 1800).isActive = true
        
        productContainerView.addSubview(productNameLabel)
        productContainerView.addSubview(productCollectionView)
        productContainerView.addSubview(productPageControl)
        
        productContainerView.addSubview(colorTitleLabel)
        productContainerView.addSubview(colorMenu)
        
        productContainerView.addSubview(discountPriceLabel)
        productContainerView.addSubview(olddiscountPriceLabel)
        productContainerView.addSubview(discountLabel)
        productContainerView.addSubview(productStatusLabel)
        
        productContainerView.addSubview(sizeCollectionView)
        
        productContainerView.addSubview(addToBagButton)
        productContainerView.addSubview(addToWishListButton)
        productContainerView.addSubview(productDetailInfo)
        productContainerView.addSubview(productCompositionLabel)
        productContainerView.addSubview(productCodeLabel)
        productContainerView.addSubview(productColorLabel)
        productContainerView.addSubview(productSizeAndFitInfo)
        let dividerLineView1 = DividerLineView()
        let dividerLineView2 = DividerLineView()
        let dividerLineView3 = DividerLineView()
        productContainerView.addSubview(dividerLineView1)
        productContainerView.addSubview(callUsButton)
        productContainerView.addSubview(dividerLineView2)
        productContainerView.addSubview(emailUsButton)
        productContainerView.addSubview(dividerLineView3)
        
        // get estimated size of text view
        let size = CGSize(width: view.frame.width, height: CGFloat.infinity)
        let nameEstimatedSizeForNameLabel = productNameLabel.sizeThatFits(size)
        let estimatedSize1 = productDetailInfo.titleLabel.sizeThatFits(size) + productDetailInfo.detailTextView.sizeThatFits(size) + CGSize(width: 0, height: 24 + 2)
        let estimatedSize2 = productSizeAndFitInfo.titleLabel.sizeThatFits(size) + productSizeAndFitInfo.infoTextView.sizeThatFits(size) + CGSize(width: 0, height: 24 + 2)
        
        productContainerView.addConstraints(withFormat: "H:|[v0]|", views: productNameLabel)
        productContainerView.addConstraints(withFormat: "H:|[v0]|", views: productCollectionView)
        productContainerView.addConstraints(withFormat: "H:|-4-[v0]-4-|", views: productPageControl)
        productContainerView.addConstraints(withFormat: "H:|-4-[v0(50)][v1]-4-|", views: colorTitleLabel, colorMenu)
        productContainerView.addConstraints(withFormat: "H:|-4-[v0]-4-|", views: discountPriceLabel)
        productContainerView.addConstraints(withFormat: "H:|-4-[v0(v1)]-20-[v1]-4-|", views: olddiscountPriceLabel, discountLabel)
        productContainerView.addConstraints(withFormat: "H:|-4-[v0]-4-|", views: productStatusLabel)
        
        productContainerView.addConstraints(withFormat: "H:|-4-[v0]-4-|", views: sizeCollectionView)
        
        productContainerView.addConstraints(withFormat: "H:|-12-[v0]-12-|", views: addToBagButton)
        productContainerView.addConstraints(withFormat: "H:|-12-[v0]-12-|", views: addToWishListButton)
        productContainerView.addConstraints(withFormat: "H:|-12-[v0]-12-|", views: productDetailInfo)
        productContainerView.addConstraints(withFormat: "H:|-12-[v0]-12-|", views: productCompositionLabel)
        productContainerView.addConstraints(withFormat: "H:|-12-[v0]-12-|", views: productCodeLabel)
        productContainerView.addConstraints(withFormat: "H:|-12-[v0]-12-|", views: productColorLabel)
        productContainerView.addConstraints(withFormat: "H:|-12-[v0]-12-|", views: productSizeAndFitInfo)
        productContainerView.addConstraints(withFormat: "H:|[v0]|", views: dividerLineView1)
        productContainerView.addConstraints(withFormat: "H:|[v0(v2)][v1(1)][v2]|", views: callUsButton, dividerLineView2, emailUsButton)
        productContainerView.addConstraints(withFormat: "H:|[v0]|", views: dividerLineView3)
        
        productContainerView.addConstraints(withFormat: "V:|-8-[v0(\(nameEstimatedSizeForNameLabel.height))]-8-[v1(400)]-4-[v2(14)]-12-[v3(40)]-14-[v4(22)]-8-[v5(20)]", views: productNameLabel, productCollectionView, productPageControl, colorMenu, discountPriceLabel, olddiscountPriceLabel)
        productContainerView.addConstraints(withFormat: "V:[v0]-12-[v1(40)]", views: productPageControl, colorTitleLabel)
        productContainerView.addConstraints(withFormat: "V:[v0]-8-[v1(20)]", views: discountPriceLabel, discountLabel)
        
        productContainerView.addConstraints(withFormat: "V:[v0]-18-[v1(40)]-18-[v2(16)]-18-[v3(44)]-12-[v4(44)]-24-[v5(\(estimatedSize1.height))]-36-[v6(18)]-12-[v7(18)]-12-[v8(18)]-24-[v9(\(estimatedSize2.height))]-36-[v10(1)][v11(80)][v12(1)]", views: olddiscountPriceLabel, sizeCollectionView, productStatusLabel, addToBagButton, addToWishListButton, productDetailInfo, productCompositionLabel, productCodeLabel, productColorLabel, productSizeAndFitInfo, dividerLineView1, callUsButton, dividerLineView3)
//        productContainerView.addConstraints(withFormat: "V:[v0]-18-[v1(16)]-18-[v2(44)]-12-[v3(44)]-24-[v4(\(estimatedSize1.height))]-36-[v5(18)]-12-[v6(18)]-12-[v7(18)]-24-[v8(\(estimatedSize2.height))]-36-[v9(1)][v10(80)][v11(1)]", views: olddiscountPriceLabel, productStatusLabel, addToBagButton, addToWishListButton, productDetailInfo, productCompositionLabel, productCodeLabel, productColorLabel, productSizeAndFitInfo, dividerLineView1, callUsButton, dividerLineView3)
        
        
        
        productContainerView.addConstraints(withFormat: "V:[v0][v1(80)]", views: dividerLineView1, emailUsButton)
        productContainerView.addConstraints(withFormat: "V:[v0]-12-[v1]-12-[v2]", views: dividerLineView1, dividerLineView2, dividerLineView3)
        
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        print("x")
        scrollView.setNeedsLayout()
        scrollView.layoutIfNeeded()
        
        scrollView.contentSize.height = productContainerView.frame.height
        
        // dynamic set height of productNameLabel
        self.productNameLabel.superview?.constraints.forEach({ (constraint) in
            if let firstItem = constraint.firstItem {
                if firstItem === self.productNameLabel {
                    if constraint.secondItem == nil {
                        if constraint.firstAttribute == .height {
                            let size = CGSize(width: self.view.frame.width, height: CGFloat.infinity)
                            let estimatedSize = self.productNameLabel.sizeThatFits(size)
                            constraint.constant = estimatedSize.height
                        }
                    }
                }
            }
        })
        
        // dynamic set height of productDetailInfo
        self.productDetailInfo.superview?.constraints.forEach({ (constraint) in
            if let firstItem = constraint.firstItem {
                if firstItem === self.productDetailInfo {
                    if constraint.secondItem == nil {
                        if constraint.firstAttribute == .height {
                            let size = CGSize(width: self.view.frame.width, height: CGFloat.infinity)
                            let estimatedSize = productDetailInfo.titleLabel.sizeThatFits(size) + productDetailInfo.detailTextView.sizeThatFits(size) + CGSize(width: 0, height: 24 + 2)
                            constraint.constant = estimatedSize.height
                        }
                    }
                }
            }
        })
        
        // dynamic set height of productSizeAndFitInfo
        if productSizeAndFitInfo.infoTextView.customedText != nil {
            self.productSizeAndFitInfo.superview?.constraints.forEach { (constraint) in
                if let firstItem = constraint.firstItem {
                    if firstItem === self.productSizeAndFitInfo {
                        if constraint.secondItem == nil {
                            if constraint.firstAttribute == .height {
                                // dynamic set height of productSizeAndFitInfo
                                if self.productSizeAndFitInfo.infoTextView.customedText != nil {
                                    let size = CGSize(width: self.view.frame.width, height: CGFloat.infinity)
                                    let estimatedSize = self.productSizeAndFitInfo.titleLabel.sizeThatFits(size) + self.productSizeAndFitInfo.infoTextView.sizeThatFits(size) + CGSize(width: 0, height: 24 + 2)
                                    constraint.constant = estimatedSize.height
                                }
                            }
                        }
                    }
                }
            }
        }
        
        
    }
    
}

// ------------------------------------------------------------------------------------------------

final class ProductNameLabel: UILabel {
    
    var customedText: String! {
        didSet {
            guard let text = customedText else { return }
            typealias key = NSAttributedString.Key
            let attributedText = NSMutableAttributedString(string: text.uppercased(), attributes: [key.kern : 1.1, key.font: UIFont.helveticaNeue(ofsize: 14)])
            self.attributedText = attributedText
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.textAlignment = .center
        self.lineBreakMode = NSLineBreakMode.byWordWrapping
        self.numberOfLines = 0
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// ------------------------------------------------------------------------------------------------

final class ProductStatusLabel: UILabel {
    private typealias key = NSAttributedString.Key
    
    var customedText: String? {
        didSet {
            let attributedText = NSMutableAttributedString(string: self.customedText?.uppercased() ?? "", attributes: [key.kern : 1.1, key.font: UIFont.helveticaNeue(ofsize: 12)])
            self.attributedText = attributedText
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.textAlignment = .center
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// ------------------------------------------------------------------------------------------------

final class SizeCollectionView: UICollectionView, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    var productSizes = [String]() {
        didSet {
            self.reloadData()
        }
    }
    var selectedSize: String? = nil
    private var selectedIndex: Int? = nil
    private static let cellId = "sizeCellId"
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return productSizes.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SizeCollectionView.cellId, for: indexPath) as! SizeCollectionViewCell
        
        cell.sizeButton.setTitle(productSizes[indexPath.row], for: UIControl.State.normal)
        cell.sizeButton.titleLabel?.text = productSizes[indexPath.row]
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 70, height: self.frame.height)
    }
    
    override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        super.init(frame: frame, collectionViewLayout: layout)
        self.register(SizeCollectionViewCell.self, forCellWithReuseIdentifier: SizeCollectionView.cellId)
        self.delegate = self
        self.dataSource = self
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.selectedIndex = indexPath.row
        self.selectedSize = self.productSizes[indexPath.row]
        guard let selectedCell = collectionView.cellForItem(at: indexPath) as? SizeCollectionViewCell else { return }
        selectedCell.sizeButton.layer.borderWidth = 2
        selectedCell.sizeButton.layer.borderColor = UIColor.black.cgColor
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        guard let deselectedCell = collectionView.cellForItem(at: indexPath) as? SizeCollectionViewCell else { return }
        deselectedCell.sizeButton.layer.borderWidth = 1
        deselectedCell.sizeButton.layer.borderColor = UIColor.lightGray.cgColor
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        print("display")
        guard let willDisplayedCell = cell as? SizeCollectionViewCell else { return }
        print("display 2")
        if selectedIndex == indexPath.row {
            print("display show")
            willDisplayedCell.sizeButton.layer.borderWidth = 2
            willDisplayedCell.sizeButton.layer.borderColor = UIColor.black.cgColor
        } else {
            print("display hide")
            willDisplayedCell.sizeButton.layer.borderWidth = 1
            willDisplayedCell.sizeButton.layer.borderColor = UIColor.lightGray.cgColor
        }
    }
//    func collectionView(_ collectionView: UICollectionView, didEndDisplaying cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
//        guard let displayedCell = collectionView.cellForItem(at: indexPath) as? SizeCollectionViewCell else { return }
//        print("display 3")
//        if selectedIndex == indexPath.row {
//            print("display show 2")
//            displayedCell.sizeButton.layer.borderWidth = 2
//            displayedCell.sizeButton.layer.borderColor = UIColor.black.cgColor
//        } else {
//            print("display hide 2")
//            displayedCell.sizeButton.layer.borderWidth = 1
//            displayedCell.sizeButton.layer.borderColor = UIColor.lightGray.cgColor
//        }
//    }
    
    // ------------------------------------
    final class SizeCollectionViewCell: UICollectionViewCell {
        let sizeButton: UIButton = {
            let button = UIButton(type: UIButton.ButtonType.system)
            button.layer.borderWidth = 1
            button.layer.borderColor = UIColor.lightGray.cgColor
            button.backgroundColor = UIColor.white
            button.setTitleColor(UIColor.black, for: UIControl.State.normal)
            button.isUserInteractionEnabled = false
            return button
        }()
        
        override func prepareForReuse() {
            super.prepareForReuse()
            sizeButton.titleLabel?.text = nil
        }
        
        override init(frame: CGRect) {
            super.init(frame: frame)
            // set up views
            addSubview(sizeButton)
            
            addConstraints(withFormat: "V:|[v0]|", views: sizeButton)
            addConstraints(withFormat: "H:|[v0]|", views: sizeButton)
            
        }
        
        
        required init?(coder aDecoder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
    }
    // ------------------------------------
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


// ------------------------------------------------------------------------------------------------

final class ProductDetailInfo: UIView {
    let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Product details"
        label.font = UIFont.helveticaNeue(ofsize: 18)
        return label
    }()
    
    final class ProductDetailInfoTextView: UITextView {
        var customedText: String! {
            didSet {
                typealias key = NSAttributedString.Key
                let style = NSMutableParagraphStyle()
                style.lineSpacing = 8
                let attributedText = NSMutableAttributedString(string: customedText ?? "", attributes: [key.font: UIFont.helveticaNeue(ofsize: 14), key.paragraphStyle: style])
                self.attributedText = attributedText
            }
        }
    }
    
    let detailTextView: ProductDetailInfoTextView = ProductDetailInfoTextView()
    
    convenience init(withTitle title: String, infoText: String) {
        self.init()
        self.backgroundColor = UIColor.clear
        self.titleLabel.text = title
        self.detailTextView.customedText = infoText
        self.detailTextView.isScrollEnabled = false
        detailTextView.backgroundColor = UIColor.clear
        setupViews()
    }
    
    private func setupViews() {
        addSubview(titleLabel)
        addSubview(detailTextView)
        
        addConstraints(withFormat: "H:|[v0]|", views: titleLabel)
        addConstraints(withFormat: "H:|[v0]|", views: detailTextView)
        
        addConstraints(withFormat: "V:|[v0(22)]-24-[v1]|", views: titleLabel, detailTextView)
    }
}

// -------------------------------------------------------------------------------------------

final class ProductSizeAndFitInfo: UIView {
    let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Size and Fit"
        label.font = UIFont.helveticaNeue(ofsize: 18)
        return label
    }()
    
    final class ProductSizeAndFitInfoTextView: UITextView {
        var customedText: String! {
            didSet {
                //                let text = """
                //                - Height: 16cm / 6.3 in
                //                - Depth: 7.5 cm / 3 in
                //                - Maximum strap length: 90 cm / 35.4 in
                //                - Width: 17 cm / 6.7 in
                //                """
                guard let text = customedText else { return }
                typealias key = NSAttributedString.Key
                let style = NSMutableParagraphStyle()
                style.lineSpacing = 8
                let attributedText = NSMutableAttributedString(string: text, attributes: [key.font: UIFont.helveticaNeue(ofsize: 14), key.paragraphStyle: style])
                self.attributedText = attributedText
            }
        }
        
    }
    
    let infoTextView: ProductSizeAndFitInfoTextView = {
        let textView = ProductSizeAndFitInfoTextView()
        textView.isScrollEnabled = false
        return textView
    }()
    
    convenience init(withTitle title: String, infoText: String) {
        self.init()
        self.titleLabel.text = title
        self.infoTextView.customedText = infoText
        setupViews()
        self.backgroundColor = UIColor.clear
    }
    convenience init(withTitle title: String) {
        self.init()
        self.titleLabel.text = title
        self.infoTextView.customedText = nil
        setupViews()
        self.backgroundColor = UIColor.clear
    }
    
    private func setupViews() {
        addSubview(titleLabel)
        addSubview(infoTextView)
        
        addConstraints(withFormat: "H:|[v0]|", views: titleLabel)
        addConstraints(withFormat: "H:|[v0]|", views: infoTextView)
        
        addConstraints(withFormat: "V:|[v0(22)]-24-[v1]|", views: titleLabel, infoTextView)
    }
    
}


