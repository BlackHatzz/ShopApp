//
//  ProductCell.swift
//  ShopApp
//
//  Created by Nguyễn Đức Huy on 7/18/19.
//  Copyright © 2019 Nguyễn Đức Huy. All rights reserved.
//

import UIKit

class ProductCell: UICollectionViewCell {
    override func prepareForReuse() {
        super.prepareForReuse()
        self.productImageView.image = nil
        self.designerLabel.text = nil
        self.discountPriceLabel.text = nil
        self.priceLabel.text = nil
        self.discountLabel.text = nil
        if productImageView.image != nil {
            self.activityIndicatorView.startAnimating()
        } else {
            self.activityIndicatorView.stopAnimating()
        }
        
    }
    
    var productImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
//        imageView.backgroundColor = UIColor.yellow
//        imageView.image = UIImage(named: "tag")
        imageView.isUserInteractionEnabled = false
        imageView.backgroundColor = UIColor.init(white: 0.97, alpha: 1)
        imageView.layer.cornerRadius = 2
        imageView.layer.masksToBounds = true
        return imageView
    }()
    let designerLabel: UILabel = {
        let label = UILabel()
        label.text = "abc"
//        label.backgroundColor = UIColor.yellow
        label.font = UIFont.helvetica(ofsize: 18)
        label.textAlignment = .center
        return label
    }()
    let discountPriceLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.red
        label.text = "$580"
        label.font = UIFont.helvetica(ofsize: 16)
        label.textAlignment = .center
        return label
    }()
    let priceLabel: UILabel = {
        let label = UILabel()
        label.text = "was $580"
        label.font = UIFont.helvetica(ofsize: 12)
        label.textAlignment = .right
        return label
    }()
    let discountLabel: UILabel = {
        let label = UILabel()
        label.text = "40% off"
        label.font = UIFont.helvetica(ofsize: 12)
        label.textAlignment = .left
        return label
    }()
    let activityIndicatorView: UIActivityIndicatorView = {
        let aiv = UIActivityIndicatorView(style: UIActivityIndicatorView.Style.white)
        aiv.color = UIColor.black
        aiv.translatesAutoresizingMaskIntoConstraints = false
        aiv.layer.zPosition = 1
//        aiv.isHidden = true
        return aiv
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(productImageView)
        addSubview(designerLabel)
        addSubview(discountPriceLabel)
        addSubview(priceLabel)
        addSubview(discountLabel)
        
        addConstraints(withFormat: "H:|[v0]|", views: productImageView)
        addConstraints(withFormat: "H:|[v0]|", views: designerLabel)
        addConstraints(withFormat: "H:|[v0]|", views: discountPriceLabel)
        addConstraints(withFormat: "H:|[v0(v1)]-8-[v1]|", views: priceLabel, discountLabel)
        addConstraints(withFormat: "V:|-4-[v0]-4-[v1(20)]-4-[v2(18)][v3(14)]-4-|", views: productImageView, designerLabel, discountPriceLabel, priceLabel)
        addConstraints(withFormat: "V:[v0][v1(14)]-4-|", views: discountPriceLabel, discountLabel)
        
        addSubview(activityIndicatorView)
        activityIndicatorView.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        activityIndicatorView.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        activityIndicatorView.widthAnchor.constraint(equalToConstant: 50).isActive = true
        activityIndicatorView.heightAnchor.constraint(equalToConstant: 50).isActive = true
        activityIndicatorView.startAnimating()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
