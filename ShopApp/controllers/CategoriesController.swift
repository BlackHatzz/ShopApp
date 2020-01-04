//
//  Temp2.swift
//  ShopApp
//
//  Created by Nguyễn Đức Huy on 1/3/20.
//  Copyright © 2020 Nguyễn Đức Huy. All rights reserved.
//

import UIKit

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
        
        categoriesCollectionView.delegate = self
        categoriesCollectionView.dataSource = self
        categoriesCollectionView.register(CategoryCell.self, forCellWithReuseIdentifier: "abc")
        
        setupViews()
    }
    
    private func setupViews() {
        view.addSubview(categoriesCollectionView)
        
        categoriesCollectionView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        categoriesCollectionView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        categoriesCollectionView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        categoriesCollectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        
        
    }
// ------------------------------------------------------------------------------
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "abc", for: indexPath) as! CategoryCell
        
        if indexPath.row == 0 {
            cell.imageView.image = UIImage(named: "cate-shoes")
        } else if indexPath.row == 1 {
            cell.imageView.image = UIImage(named: "cate-bag")
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: self.view.frame.width, height: 210)
    }
}

class CategoryCell: UICollectionViewCell {
    override func prepareForReuse() {
        super.prepareForReuse()
        imageView.image = nil
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
        imageView.backgroundColor = UIColor.lightGray
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
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        // setup views
        addSubview(imageView)
        addSubview(titleLabel)
        
        imageView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        imageView.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        imageView.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
        imageView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        
        titleLabel.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        titleLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -12).isActive = true
        titleLabel.heightAnchor.constraint(equalToConstant: 35).isActive = true
//        titleLabel.widthAnchor.constraint(equalToConstant: 50).isActive = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
