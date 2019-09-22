//
//  SlideProductCell.swift
//  ShopApp
//
//  Created by Nguyễn Đức Huy on 7/24/19.
//  Copyright © 2019 Nguyễn Đức Huy. All rights reserved.
//

import UIKit

class SlideProductCell: UICollectionViewCell {
    
    var statusCell = StatusCellKey.initialization
    struct StatusCellKey {
        static let initialization = "initialization"
        static let loading = "loading"
        static let loaded = "loaded"
    }
    
    let productImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    
    final class ProductActivityIndicatorView: UIActivityIndicatorView {
//        var status = SlideProductCell.ProductActivityIndicatorView.StatusKey.initialization
//        struct StatusKey {
//            static let initialization = "initialization"
//            static let loading = "loading"
//            static let loaded = "loaded"
//        }
        
        override func startAnimating() {
            super.startAnimating()
//            status = SlideProductCell.ProductActivityIndicatorView.StatusKey.loading
        }
        
        override func stopAnimating() {
            super.stopAnimating()
//            status = SlideProductCell.ProductActivityIndicatorView.StatusKey.loading
        }
        
        override init(frame: CGRect) {
            super.init(frame: frame)
            self.setNeededProperties()
        }
        override init(style: UIActivityIndicatorView.Style) {
            super.init(style: style)
            self.setNeededProperties()
        }
        
        private func setNeededProperties() {
            self.color = UIColor.black
            self.hidesWhenStopped = true
            self.translatesAutoresizingMaskIntoConstraints = false
            self.isUserInteractionEnabled = false
            self.layer.zPosition = 1
            self.style = UIActivityIndicatorView.Style.whiteLarge
        }
        
        required init(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
    }
    
    
    let activityIndicatorView: ProductActivityIndicatorView = {
        let indicator = ProductActivityIndicatorView(style: UIActivityIndicatorView.Style.whiteLarge)
        indicator.color = UIColor.black
        indicator.hidesWhenStopped = true
        indicator.translatesAutoresizingMaskIntoConstraints = false
        indicator.isUserInteractionEnabled = false
        indicator.layer.zPosition = 1
        return indicator
    }()
    
    override func prepareForReuse() {
        super.prepareForReuse()
        productImageView.image = nil
    }

    override init(frame: CGRect) {
        super.init(frame: frame)

        addSubview(productImageView)
        addSubview(activityIndicatorView)
        
        [productImageView.centerXAnchor.constraint(equalTo: self.centerXAnchor),
         productImageView.centerYAnchor.constraint(equalTo: self.centerYAnchor),
         productImageView.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: 0.9),
         productImageView.widthAnchor.constraint(equalTo: productImageView.heightAnchor, multiplier: 0.667),
         activityIndicatorView.centerXAnchor.constraint(equalTo: self.centerXAnchor),
         activityIndicatorView.centerYAnchor.constraint(equalTo: self.centerYAnchor),
         activityIndicatorView.widthAnchor.constraint(equalToConstant: 20),
         activityIndicatorView.heightAnchor.constraint(equalToConstant: 20)
            ].forEach { (nsLayoutConstraint) in
                nsLayoutConstraint.isActive = true
        }
        
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
