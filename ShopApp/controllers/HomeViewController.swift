//
//  ViewController.swift
//  ShopApp
//
//  Created by Nguyễn Đức Huy on 7/16/19.
//  Copyright © 2019 Nguyễn Đức Huy. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    private let firstCellId = "firstCellId"
    private let cellId = "cellId"
    private let wishListCellId = "wishListCellId"
    
    var topIntroImageName = "home-1"
    var imageNames = ["home-2", "home-3", "home-4"]
    
    let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
        collectionView.backgroundColor = UIColor.clear
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        self.collectionView.register(HomeCell.self, forCellWithReuseIdentifier: cellId)
        view.addSubview(collectionView)
        view.backgroundColor = UIColor.white
        collectionView.delegate = self
        collectionView.dataSource = self
        setupViews()
        
        let backButton = UIBarButtonItem(title: "", style: UIBarButtonItem.Style.plain, target: self, action: nil)
        navigationItem.backBarButtonItem = backButton
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.hidesBarsOnSwipe = false
    }
    
    private func setupViews() {
        collectionView.backgroundColor = UIColor.red
        view.addConstraints(withFormat: "H:|[v0]|", views: collectionView)
        view.addConstraints(withFormat: "V:|[v0]|", views: collectionView)
    }

    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 4
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if section == 0 || section == 1 || section == 2 { return 1 }
        return imageNames.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! HomeCell
        var topCell: TopCell?
        var contentCell: HomeCell?
        var wisthListCell: HomeWishListCell?
        if indexPath.section == 0 {
            
            self.collectionView.register(TopCell.self, forCellWithReuseIdentifier: firstCellId)
            topCell = collectionView.dequeueReusableCell(withReuseIdentifier: firstCellId, for: indexPath) as? TopCell
        } else if indexPath.section == 2 {
            self.collectionView.register(HomeWishListCell.self, forCellWithReuseIdentifier: wishListCellId)
            wisthListCell = collectionView.dequeueReusableCell(withReuseIdentifier: wishListCellId, for: indexPath) as? HomeWishListCell
        } else {
            self.collectionView.register(HomeCell.self, forCellWithReuseIdentifier: cellId)
            contentCell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as? HomeCell
        }
        
//        cell.backgroundColor = UIColor.green
        if indexPath.section == 0 {
            topCell?.label.text = "Free Every Shipping"
        } else if indexPath.section == 2 {
            
        } else {
            if indexPath.section == 1 {
                if contentCell?.cardView == nil { contentCell?.cardView = HomeCardView() }
                contentCell?.cardView?.imageView.image = UIImage(named: self.topIntroImageName)
                contentCell?.cardView?.introLabel.text = "UP TO 60% OFF"
                contentCell?.cardView?.titleLabel.text = "SUMMER NOIR"
                contentCell?.cardView?.descriptionTextView.text = "Monochrome is chic all year-round, especially in the summer! Here's how..."
            } else {
                if contentCell?.cardView == nil { contentCell?.cardView = HomeCardView() }
                contentCell?.cardView?.imageView.image = UIImage(named: imageNames[indexPath.row])
                contentCell?.cardView?.introLabel.text = "UP TO 60% OFF"
                contentCell?.cardView?.titleLabel.text = "SUMMER NOIR"
                contentCell?.cardView?.descriptionTextView.text = "Monochrome is chic all year-round, especially in the summer! Here's how..."
            }
            contentCell?.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleTap)))
        }
        
        if indexPath.section == 0 { return topCell! }
        else if indexPath.section == 2 { return wisthListCell!}
        return contentCell!
    }
    
    @objc func handleTap() {
        let layout = UICollectionViewFlowLayout()
        let viewController = ProductViewController(collectionViewLayout: layout)
        self.navigationController?.pushViewController(viewController, animated: true)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 15
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if indexPath.section == 0 {
            return CGSize(width: self.view.frame.width, height: 70)
        } else if indexPath.section == 2 {
            return  CGSize(width: self.view.frame.width, height: 350)
        }
        return CGSize(width: self.view.frame.width, height: 400)
    }
    
}

class TopCell: UICollectionViewCell {
    override func prepareForReuse() {
        super.prepareForReuse()
//        label.text = nil
    }
    
    var label: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.helveticaLight(ofsize: 12)
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(label)
        addConstraints(withFormat: "H:|[v0]|", views: label)
        addConstraints(withFormat: "V:|[v0]|", views: label)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

