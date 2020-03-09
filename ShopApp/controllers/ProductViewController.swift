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
    let loadingView = ProcessView(title: "Loading", type: ProcessView.NotiType.loading)
    
    let shoppingBagButton = ShoppingBagButton()
    
    init(category: String?) {
        super.init(collectionViewLayout: UICollectionViewFlowLayout())
        
        if category == nil {
            // get data from database
            let productRef = databaseRef.child("product")
            let productQuery = productRef.queryOrderedByKey().queryLimited(toFirst: 1000)
            
            productQuery.observeSingleEvent(of: DataEventType.value, with: { (snapshot) in
                if let dictionary = snapshot.value as? [String: Any] {
                    for (productId, productDictionary) in dictionary {
                        products.append(Product(id: productId, productInfo: productDictionary as! [String : Any]))
                    }
                    dump(products)
                    self.collectionView.reloadData()
                    
                    self.collectionView.performBatchUpdates({
                        products.sort(by: { (product1, product2) -> Bool in
                            return product1.id > product2.id
                        })
                    }, completion: { (_) in
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
                    })
                }
            }) { (error) in
                print(error.localizedDescription)
            }
        } else {
            let productRef = Database.database().reference().child("product")
            let productQuery = productRef.queryOrdered(byChild: "category").queryEqual(toValue: category!).queryLimited(toFirst: 1000)
            
            productQuery.observeSingleEvent(of: DataEventType.value, with: { (snapshot) in
                if let dictionary = snapshot.value as? [String: Any] {
                    for (productId, productDictionary) in dictionary {
                        products.append(Product(id: productId, productInfo: productDictionary as! [String : Any]))
                    }
                    dump(products)
                    self.collectionView.reloadData()
                    
                    self.collectionView.performBatchUpdates({
                        products.sort(by: { (product1, product2) -> Bool in
                            return product1.id > product2.id
                        })
                    }, completion: { (_) in
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
                    })
                }
            }) { (error) in
                print(error.localizedDescription)
            }
        }
    } // init search category if categoroy == nil -> search all
    
    init(designer: String) {
        super.init(collectionViewLayout: UICollectionViewFlowLayout())
        let productRef = databaseRef.child("product")
        let productQuery = productRef.queryOrdered(byChild: "designer").queryEqual(toValue: designer).queryLimited(toFirst: 1000)
        
        productQuery.observeSingleEvent(of: DataEventType.value, with: { (snapshot) in
            if let dictionary = snapshot.value as? [String: Any] {
                for (productId, productInfo) in dictionary {
                    if let productInfo = productInfo as? [String: Any] {
                        products.append(Product(id: productId, productInfo: productInfo))
                    }
                    
                    self.collectionView.reloadData()
                    
                    self.collectionView.performBatchUpdates({
                        products.sort(by: { (product1, product2) -> Bool in
                            return product1.id > product2.id
                        })
                    }, completion: { (_) in
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
                    })
                }
            }
        }) { (error) in
            print(error.localizedDescription)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "MIKI SHOP"
        setupNavBar()
        
        view.addSubview(loadingView)
        
        self.collectionView!.register(ProductCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        
        collectionView!.backgroundColor = UIColor.white
        
        
    } // viewDidLoad
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.hidesBarsOnSwipe = false
        navigationItem.backBarButtonItem = UIBarButtonItem(title: nil, style: .plain, target: nil, action: nil)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if !customer.shoppingBag.isEmpty {
            shoppingBagButton.quantityLabel.text = "\(customer.shoppingBag.count)"
        } else {
            shoppingBagButton.quantityLabel.text = nil
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        if self.isMovingFromParent {
            products.removeAll()
        }
    }
    
    private func setupNavBar() {
        
        // set back button
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: UIBarButtonItem.Style.plain, target: nil, action: nil)
        
        shoppingBagButton.frame = CGRect(x: 0, y: 5, width: 30, height: 25)
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
        
        navigationItem.rightBarButtonItems = [UIBarButtonItem(customView: shoppingBagButton), UIBarButtonItem(customView: searchButton)]
        
    }
    
    let searchButton = UIButton()
//    let shoppingBagButton = UIButton()
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
    
    override func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        let displayedCell = cell as! ProductCell
        if displayedCell.productImageView.image != nil {
            displayedCell.activityIndicatorView.stopAnimating()
        } else {
            displayedCell.activityIndicatorView.startAnimating()
        }
    }
    
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
