//
//  ProducViewController.swift
//  ShopApp
//
//  Created by Nguyễn Đức Huy on 7/18/19.
//  Copyright © 2019 Nguyễn Đức Huy. All rights reserved.
//

import UIKit
import Firebase

private let reuseIdentifier = "Cell"
private var products = [Product]()

class ProductViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    let databaseRef = Database.database().reference()
    let loadingView = NotificationView(title: "Loading", type: NotificationView.NotiType.loading)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavBar()
//        self.collectionView.delegate = self
//        self.collectionView.dataSource = self
        
        view.addSubview(loadingView)
        
        self.collectionView!.register(ProductCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        
        collectionView!.backgroundColor = UIColor.white
        
        // get data from database
        let flag = Date().timeIntervalSince1970
        print("time flag", flag)
        let productRef = databaseRef.child("product")
        let productQuery = productRef.queryOrderedByKey().queryLimited(toFirst: 1000)
        
        productQuery.observeSingleEvent(of: DataEventType.value, with: { (snapshot) in
            if let dictionary = snapshot.value as? [String: Any] {
                for (productId, productDictionary) in dictionary {
                    products.append(Product(id: productId, productInfo: productDictionary as! [String : Any]))
                }
                dump(products)
                self.collectionView.reloadData()
                
                self.collectionView.performBatchUpdates(nil) { (_) in
                    self.loadingView.activityIndicatorView.stopAnimating()
                    self.loadingView.removeFromSuperview()
                    
                    for product in products {
                        product.loadFirstImage(completionHandler: {
                            // reload data of collection view when load one image
                            DispatchQueue.main.async {
                                self.collectionView.reloadData()
                            }
                        })
                    }
                    
//                    for (index, product) in products.enumerated() {
////                        if let imageUrls = product.imageUrls {
//                            if !product.imageUrls.isEmpty {
//                                let imageUrlsList = product.imageUrls[0]
//                                let firstUrlImage = imageUrlsList![0]
//
//                                Product.loadImageFromStorage(fromURLString: firstUrlImage, completion: { (result: UIImage?) in
////                                    product.images[index] = [0: result!]
//                                    products[index].images[0] = [0: result!]
//                                    self.collectionView.reloadData()
//                                })
//                            }
//
////                        }
//
//                    }
                    
                }
            }
        }) { (error) in
            print(error.localizedDescription)
        }
        
    } // viewDidLoad
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.hidesBarsOnSwipe = true
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        if self.isMovingFromParent {
            products.removeAll()
        }
    }
    
    private func setupNavBar() {
        
        // set back button
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "Back", style: UIBarButtonItem.Style.plain, target: nil, action: nil)
        
//        shoppingBagButton.backgroundColor = UIColor.red
//        shoppingBagButton.setImage(UIImage(named: "shopping-bag128")?.withRenderingMode(UIImage.RenderingMode.alwaysOriginal), for: UIControl.State.normal)
        
        let shoppingBagImageView = UIImageView()
        shoppingBagImageView.image = UIImage(named: "shopping-bag")?.withRenderingMode(.alwaysOriginal)
        shoppingBagImageView.isUserInteractionEnabled = false
        shoppingBagButton.addSubview(shoppingBagImageView)

        shoppingBagButton.frame = CGRect(x: 0, y: 0, width: 30, height: 25)
        shoppingBagImageView.frame = CGRect(x: 0, y: 5, width: 30, height: 25)
        
        shoppingBagButton.tag = 2
        shoppingBagButton.addTarget(self, action: #selector(handleRightNavBarItem(_:)), for: UIControl.Event.touchUpInside)
        
//        searchButton.backgroundColor = UIColor.green
        let searchImageView = UIImageView()
        searchImageView.image = UIImage(named: "search.png")
        searchImageView.isUserInteractionEnabled = false
        searchButton.addSubview(searchImageView)
        
        searchButton.frame = CGRect(x: 0, y: 0, width: 25, height: 20)
        searchImageView.frame = CGRect(x: 2, y: 8, width: 22, height: 22)
        
        searchButton.tag = 1
        
        searchButton.addTarget(self, action: #selector(handleRightNavBarItem(_:)), for: UIControl.Event.touchUpInside)
        
//        shoppingBagImageView.centerXAnchor.constraint(equalTo: shoppingBagButton.centerXAnchor).isActive = true
//        shoppingBagImageView.centerYAnchor.constraint(equalTo: shoppingBagButton.centerYAnchor).isActive = true
//        shoppingBagImageView.widthAnchor.constraint(equalTo: shoppingBagButton.widthAnchor).isActive = true
//        shoppingBagImageView.heightAnchor.constraint(equalTo: shoppingBagButton.heightAnchor).isActive = true
        
//        shoppingBagButton.setImage(UIImage(named: "shopping-bag")?.withRenderingMode(UIImage.RenderingMode.alwaysOriginal), for: UIControl.State.normal)
//        shoppingBagButton.imageRect(forContentRect: CGRect(x: 0, y: 0, width: 5, height: 5))
        
        
//        let shoppingBagButton = UIBarButtonItem(image: UIImage(named: "shopping-bag"), style: UIBarButtonItem.Style.plain, target: self, action: #selector(handleShoppingBagButton))
        
//        let searchButton = UIBarButtonItem(image: UIImage(named: "search"), style: UIBarButtonItem.Style.plain, target: self, action: #selector(handleShoppingBagButton))
        
//        searchButton.backgroundColor = UIColor.green
//        searchButton.setImage(UIImage(named: "search")?.withRenderingMode(UIImage.RenderingMode.alwaysOriginal), for: UIControl.State.normal)
        
        
        navigationItem.rightBarButtonItems = [UIBarButtonItem(customView: shoppingBagButton), UIBarButtonItem(customView: searchButton)]
        
    }
    
    let searchButton = UIButton()
    let shoppingBagButton = UIButton()
    override func viewDidLayoutSubviews() {
        print("search frame", searchButton.frame)
        print("shopping frame", shoppingBagButton.frame)
        
    }
    
    @objc func handleRightNavBarItem(_ sender: UIButton) {
        print("sender", sender.tag)
        
        switch sender.tag {
        case 1:
            // searchButton
            let viewController = SearchingController()
            let navigationController = UINavigationController(rootViewController: viewController)
            self.navigationController?.present(navigationController, animated: true, completion: nil)
        case 2:
            let viewController = BagController()
            let navigationController = UINavigationController(rootViewController: viewController)
            self.navigationController?.present(navigationController, animated: true, completion: nil)
        default:
            assertionFailure("Action is not supported")
        }
        
    }
    

// ----------------------------------------------------------------------
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return products.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! ProductCell
    
        // Configure the cell
        
        cell.designerLabel.text = products[indexPath.row].designer
        
        if let discountPrice = products[indexPath.row].discountPrice {
            cell.discountPriceLabel.text = "$\(discountPrice)"
        }
        
        if let price = products[indexPath.row].price {
            cell.priceLabel.text = "was $\(price)"
        }
        
        if let discount = products[indexPath.row].discount {
            cell.discountLabel.text = "\(discount)% off"
        }
        
        let images = products[indexPath.row].images
        
        if !images.isEmpty {
            let currentProductImagesList = images[0]
            let firstImage = currentProductImagesList![0]

            cell.productImageView.image = firstImage
        }
        
        return cell
    }
    
//    override func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
//        super.collectionView(collectionView, willDisplay: cell, forItemAt: indexPath)
//        let productCell = cell as! ProductCell
    
//        if productCell.productImageView.image == nil {
//            productCell.activityIndicatorView.isHidden = false
//            productCell.activityIndicatorView.startAnimating()
//        }
        
//    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {

        //        let viewController = ProductDetailController(productId: "-LnSlvkbBc3agYof2M7g")
        //        let viewController = ProductDetailController(productId: "-LnaVumXnmOCsKvjQPnG")
        let viewController = ProductDetailController(ofProduct: products[indexPath.row])
        self.navigationController?.pushViewController(viewController, animated: true)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 25
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 5)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width / 2 - 10, height: 350)
    }
}
