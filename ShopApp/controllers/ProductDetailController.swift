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
    let colorMenu = ColorMenu()
    
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
        self.colorMenu.collectionView.reloadData()
        
        product = currentProduct
        guard let product = product else {
            assertionFailure("product can not be nil")
            return
        }
        
        self.colorMenu.collectionView.performBatchUpdates(nil) { (_) in
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
        
        
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        currentIndexProductImages = 0
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.databaseRef?.removeAllObservers()
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
                
                
                self.colorMenu.collectionView.reloadData()
                
                self.colorMenu.collectionView.performBatchUpdates(nil) { (_) in
                    self.colorMenu.collectionView.selectItem(at: IndexPath(item: 0, section: 0), animated: false, scrollPosition: UICollectionView.ScrollPosition.left)
                    print("zz", self.colorMenu.collectionView.numberOfItems(inSection: 0))
                    let firstResponderCell = self.colorMenu.collectionView.cellForItem(at: IndexPath(item: 0, section: 0)) as? ColorMenu.ColorOption
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
        // set up main scroll view
        scrollView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        scrollView.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        scrollView.heightAnchor.constraint(equalTo: view.heightAnchor).isActive = true
        
        
        // set up product view
        scrollView.addSubview(productContainerView)
        productContainerView.topAnchor.constraint(equalTo: scrollView.topAnchor).isActive = true
        productContainerView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor).isActive = true
        productContainerView.widthAnchor.constraint(equalTo: scrollView.widthAnchor).isActive = true
        productContainerView.heightAnchor.constraint(equalToConstant: 1800).isActive = true
        
        productContainerView.addSubview(productNameLabel)
        productContainerView.addSubview(productCollectionView)
        productContainerView.addSubview(productPageControl)
        
        productContainerView.addSubview(colorMenu)
        
        productContainerView.addSubview(discountPriceLabel)
        productContainerView.addSubview(olddiscountPriceLabel)
        productContainerView.addSubview(discountLabel)
        productContainerView.addSubview(productStatusLabel)
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
        let estimatedSize1 = productDetailInfo.titleLabel.sizeThatFits(size) + productDetailInfo.detailTextView.sizeThatFits(size) + CGSize(width: 0, height: 24 + 2)
        let estimatedSize2 = productSizeAndFitInfo.titleLabel.sizeThatFits(size) + productSizeAndFitInfo.infoTextView.sizeThatFits(size) + CGSize(width: 0, height: 24 + 2)
        
        productContainerView.addConstraints(withFormat: "H:|[v0]|", views: productNameLabel)
        productContainerView.addConstraints(withFormat: "H:|[v0]|", views: productCollectionView)
        productContainerView.addConstraints(withFormat: "H:|-4-[v0]-4-|", views: productPageControl)
        productContainerView.addConstraints(withFormat: "H:|-4-[v0]-4-|", views: colorMenu)
        productContainerView.addConstraints(withFormat: "H:|-4-[v0]-4-|", views: discountPriceLabel)
        productContainerView.addConstraints(withFormat: "H:|-4-[v0(v1)]-20-[v1]-4-|", views: olddiscountPriceLabel, discountLabel)
        productContainerView.addConstraints(withFormat: "H:|-4-[v0]-4-|", views: productStatusLabel)
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
        
        productContainerView.addConstraints(withFormat: "V:|-8-[v0(20)]-8-[v1(400)]-4-[v2(14)]-12-[v3(40)]-14-[v4(22)]-8-[v5(20)]", views: productNameLabel, productCollectionView, productPageControl, colorMenu, discountPriceLabel, olddiscountPriceLabel)
        productContainerView.addConstraints(withFormat: "V:[v0]-8-[v1(20)]", views: discountPriceLabel, discountLabel)
        
        productContainerView.addConstraints(withFormat: "V:[v0]-18-[v1(16)]-18-[v2(44)]-12-[v3(44)]-24-[v4(\(estimatedSize1.height))]-36-[v5(18)]-12-[v6(18)]-12-[v7(18)]-24-[v8(\(estimatedSize2.height))]-36-[v9(1)][v10(80)][v11(1)]", views: olddiscountPriceLabel, productStatusLabel, addToBagButton, addToWishListButton, productDetailInfo, productCompositionLabel, productCodeLabel, productColorLabel, productSizeAndFitInfo, dividerLineView1, callUsButton, dividerLineView3)
        
        
        productContainerView.addConstraints(withFormat: "V:[v0][v1(80)]", views: dividerLineView1, emailUsButton)
        productContainerView.addConstraints(withFormat: "V:[v0]-12-[v1]-12-[v2]", views: dividerLineView1, dividerLineView2, dividerLineView3)
        
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        print("x")
        scrollView.setNeedsLayout()
        scrollView.layoutIfNeeded()
        
        scrollView.contentSize.height = productContainerView.frame.height
        
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
        textView.backgroundColor = UIColor.green
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


