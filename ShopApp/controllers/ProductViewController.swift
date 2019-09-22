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
    let loadingView = LoadingView()
    override func viewDidLoad() {
        super.viewDidLoad()
//        self.collectionView.delegate = self
//        self.collectionView.dataSource = self
        
        view.addSubview(loadingView)
        loadingView.frame = CGRect(x: 0, y: 0, width: 125, height: 125)
        loadingView.center = view.center
        
        self.collectionView!.register(ProductCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        
        collectionView!.backgroundColor = UIColor.white
        let backButton = UIBarButtonItem(title: "", style: UIBarButtonItem.Style.plain, target: self, action: nil)
        navigationItem.backBarButtonItem = backButton
        navigationController?.hidesBarsOnSwipe = true
        
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
                    for (index, product) in products.enumerated() {
//                        if let imageUrls = product.imageUrls {
                            if !product.imageUrls.isEmpty {
                                let imageUrlsList = product.imageUrls[0]
                                let firstUrlImage = imageUrlsList![0]
                                
                                Product.loadImageFromStorage(fromURLString: firstUrlImage, completion: { (result: UIImage?) in
                                    product.images[index] = [0: result!]
                                    self.collectionView.reloadData()
                                })
                            }
                        
//                        }
                        
                    }
                    
                }
            }
        }) { (error) in
            print(error.localizedDescription)
        }
        
    }


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
            let currentProductImagesList = images[indexPath.row]
            let firstImage = currentProductImagesList![0]

            cell.productImageView.image = firstImage
        }
//        cell.productImageView.image = nil
//        print("indi", cell.activityIndicatorView)
        
//        cell.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleViewProductDetail)))
        
        return cell
    }
    @objc func handleViewProductDetail() {
        print("handle")
//        let viewController = ProductDetailController(productId: "-LnSlvkbBc3agYof2M7g")
        let viewController = ProductDetailController(productId: "-LnaVumXnmOCsKvjQPnG")
//        let viewController = ProductDetailController(productId: id)
        self.navigationController?.pushViewController(viewController, animated: true)
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

        let id = products[indexPath.row].id
        print("select ", indexPath.row, id)
        let viewController = ProductDetailController(productId: id)
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
