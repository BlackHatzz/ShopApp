//
//  ColorMenu.swift
//  ShopApp
//
//  Created by Nguyễn Đức Huy on 9/7/19.
//  Copyright © 2019 Nguyễn Đức Huy. All rights reserved.
//

import UIKit

final class ColorMenu: UIView, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return hexColorsList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ColorMenu.cellId, for: indexPath) as! ColorOption
        
        cell.colorPickerView.backgroundColor = UIColor.colorFrom(hexString: hexColorsList[indexPath.row])
        
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 30, height: 40)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath) as! ColorOption
        cell.bottomLineView.isHidden = false
//        currentIndexProductImages = indexPath.row
//        if productImages[currentIndexProductImages] == nil {
//            Product.loadImageFromStorage(fromURLStrings: product!.imageUrls![currentIndexProductImages]!) { (result: [Int : UIImage]) in
//                productImages[currentIndexProductImages] = result
//                //                self.collectionView.reloadInputViews()
//            }
//        }
        
        print("select", indexPath.row)
        if let handler = didSelectItemHandler {
            handler(collectionView, indexPath)
        }
    }
    
    var didSelectItemHandler: ((_ collectionView: UICollectionView, _ indexPath: IndexPath) -> Void)? = nil
    
//    func didSelectItem(withCompletionHandler completion: (() -> Void)?) {
//        
//        if let completion = completion {
//            completion()
//        }
//    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath) as! ColorOption
        cell.bottomLineView.isHidden = true
        print("deselect", indexPath.row)
    }
    private static let cellId = "colorMenuCellId"
    
    var hexColorsList = [String]()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.helveticaNeue(ofsize: 14)
        label.text = "Color: "
        return label
    }()
    let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = UICollectionView.ScrollDirection.horizontal
        layout.minimumInteritemSpacing = 5
        let collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.backgroundColor = UIColor.clear
        return collectionView
    }()
    
    final class ColorOption: UICollectionViewCell {
        let colorPickerView: UIView = {
            let view = UIView()
            view.layer.borderWidth = 1
            view.layer.borderColor = UIColor.lightGray.cgColor
            return view
        }()
        
        let bottomLineView: UIView = {
            let view = UIView()
            view.backgroundColor = UIColor.black
            view.isHidden = true
            return view
        }()
        
        override init(frame: CGRect) {
            super.init(frame: frame)
            addSubview(colorPickerView)
            addSubview(bottomLineView)
            
            addConstraints(withFormat: "H:|[v0]|", views: colorPickerView)
            addConstraints(withFormat: "H:|[v0]|", views: bottomLineView)
            
            addConstraints(withFormat: "V:|[v0(30)]", views: colorPickerView)
            addConstraints(withFormat: "V:[v0(1.5)]|", views: bottomLineView)
        }
        
        required init?(coder aDecoder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
    }
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(ColorOption.self, forCellWithReuseIdentifier: ColorMenu.cellId)
        setupViews()
        
        
    }
    
    
    private func setupViews() {
        addSubview(titleLabel)
        addSubview(collectionView)
        
        addConstraints(withFormat: "H:|-12-[v0(40)]-12-[v1]|", views: titleLabel, collectionView)
        addConstraints(withFormat: "V:|[v0]|", views: titleLabel)
        addConstraints(withFormat: "V:|[v0]|", views: collectionView)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
