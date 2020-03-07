//
//  Temp2.swift
//  ShopApp
//
//  Created by Nguyễn Đức Huy on 1/3/20.
//  Copyright © 2020 Nguyễn Đức Huy. All rights reserved.
//

import UIKit
import Firebase

class CategoriesController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    let categoriesCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 8
        layout.scrollDirection = UICollectionView.ScrollDirection.vertical
        let collectionView = UICollectionView(frame: CGRect.zero
            , collectionViewLayout: layout)
        collectionView.showsVerticalScrollIndicator = false
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.alwaysBounceVertical = true
        collectionView.backgroundColor = UIColor.clear
        return collectionView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white
        navigationItem.title = "CATEGORIES"
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        
        categoriesCollectionView.delegate = self
        categoriesCollectionView.dataSource = self
        categoriesCollectionView.register(CategoryCell.self, forCellWithReuseIdentifier: CategoryCell.cellId)
        
        setupViews()
        
        // load data
        let ref = Database.database().reference().child("category")
        ref.queryOrdered(byChild: "title").observeSingleEvent(of: DataEventType.value, with: { (snapshot) in
            if let dictionary = snapshot.value as? [String: Any] {
                for (order, i) in dictionary.values.enumerated() {
                    if let category = i as? [String: Any] {
                        let title = category["title"] as? String
                        self.categories.append((title: title!, image: nil))
                        
                        
                        
                        DispatchQueue.main.async {
                            self.categoriesCollectionView.reloadData()
                        }
                        // get image url
                        if let imageUrl = category["imageUrl"] as? String {
                            if let url = URL(string: imageUrl) {
                                
                                // download image
                                URLSession.shared.dataTask(with: url, completionHandler: { (data, response, error) in
                                    if let error = error {
                                        print(error)
                                        return
                                    }
                                    
                                    // get data
                                    if let data = data {
                                        // bind image to categories and reload collection view
                                        let image = UIImage(data: data)
                                        self.categories[order].image = image
                                        
                                        DispatchQueue.main.async {
                                            self.categoriesCollectionView.reloadData()
                                        }
                                    }
                                    
                                }).resume() // session dataTask
                            }
                        }
                        
                    }
                }
            }
        }) { (error) in
            print(error.localizedDescription)
        } // ref to database
    }
    
    private func setupViews() {
        view.addSubview(categoriesCollectionView)
        
        categoriesCollectionView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        categoriesCollectionView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        categoriesCollectionView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        categoriesCollectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
    }
// ------------------------------------------------------------------------------
    
    var categories = [(title: String, image: UIImage?)]()
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return categories.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CategoryCell.cellId, for: indexPath) as! CategoryCell
        
        cell.imageView.image = categories[indexPath.row].image
        cell.titleLabel.text = categories[indexPath.row].title.uppercased()
        
        if cell.imageView.image == nil {
            cell.activityIndicatorView.startAnimating()
        } else {
            cell.activityIndicatorView.stopAnimating()
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: self.view.frame.width, height: 210)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let viewController = ProductViewController(category: categories[indexPath.row].title)
        self.navigationController?.pushViewController(viewController, animated: true)
    }
}

// ------------------------------------------------------------------------------
// ------------------------------------------------------------------------------
// ------------------------------------------------------------------------------

class CategoryCell: UICollectionViewCell {
    static let cellId = "categoryCellId"
    
    override func prepareForReuse() {
        super.prepareForReuse()
        imageView.image = nil
        DispatchQueue.main.async {
            self.setNeedsDisplay()
            self.titleLabel.setNeedsDisplay()
            let estimatedSize = self.titleLabel.sizeThatFits(CGSize(width: self.frame.width, height: 35))
            self.titleLabel.frame.size.width = estimatedSize.width + 34
        }
    }
    
    override func didMoveToSuperview() {
        super.didMoveToSuperview()
        DispatchQueue.main.async {
            self.setNeedsDisplay()
            self.titleLabel.setNeedsDisplay()
            let estimatedSize = self.titleLabel.sizeThatFits(CGSize(width: self.frame.width, height: 35))
            self.titleLabel.frame.size.width = estimatedSize.width + 34
        }
    }
    
    let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.backgroundColor = UIColor.clear
        return imageView
    }()
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = NSTextAlignment.center
        label.font = UIFont.systemFont(ofSize: 16)
        label.text = "SHOES"
        label.backgroundColor = UIColor.black
        label.textColor = UIColor.white
        return label
    }()
    
    let activityIndicatorView: UIActivityIndicatorView = {
        let activityIndicatorView = UIActivityIndicatorView(style: UIActivityIndicatorView.Style.whiteLarge)
        activityIndicatorView.translatesAutoresizingMaskIntoConstraints = false
        activityIndicatorView.isUserInteractionEnabled = false
        activityIndicatorView.layer.zPosition = 2
        activityIndicatorView.color = UIColor.black
        activityIndicatorView.hidesWhenStopped = true
        return activityIndicatorView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        // setup views
        addSubview(imageView)
        addSubview(titleLabel)
        addSubview(activityIndicatorView)
        
        imageView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        imageView.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        imageView.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
        imageView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        
        titleLabel.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        titleLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -12).isActive = true
        titleLabel.heightAnchor.constraint(equalToConstant: 35).isActive = true
        // titleLabel set width in didMoveToSuperView() function
        
        activityIndicatorView.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        activityIndicatorView.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        activityIndicatorView.widthAnchor.constraint(equalToConstant: 20).isActive = true
        activityIndicatorView.heightAnchor.constraint(equalToConstant: 20).isActive = true
//        titleLabel.widthAnchor.constraint(equalToConstant: 50).isActive = true
        
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
