//
//  CartViewController.swift
//  ShopApp
//
//  Created by Nguyễn Đức Huy on 7/16/19.
//  Copyright © 2019 Nguyễn Đức Huy. All rights reserved.
//

import UIKit

class CartViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UITextFieldDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "acb", for: indexPath)
        cell.backgroundColor = UIColor.red
        return cell
    }
    
    let searchResultCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 10
        layout.minimumInteritemSpacing = 50
        layout.scrollDirection = UICollectionView.ScrollDirection.vertical
        let collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
        collectionView.backgroundColor = UIColor.blue
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.alwaysBounceVertical = true
        return collectionView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.green
        searchResultCollectionView.delegate = self
        searchResultCollectionView.dataSource = self
        searchResultCollectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "acb")
        view.addSubview(searchResultCollectionView)
        searchResultCollectionView.translatesAutoresizingMaskIntoConstraints = false
        searchResultCollectionView.backgroundColor = UIColor.blue
        
        view.addConstraints(withFormat: "H:|[v0]|", views: searchResultCollectionView)
        view.addConstraints(withFormat: "V:|-20-[v0]-20-|", views: searchResultCollectionView)
        
//        tempView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
//        tempView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
//        tempView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 100).isActive = true
//        tempView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -400).isActive = true
    
    }

}

