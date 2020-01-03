//
//  SlideCollectionView.swift
//  ShopApp
//
//  Created by Nguyễn Đức Huy on 7/16/19.
//  Copyright © 2019 Nguyễn Đức Huy. All rights reserved.
//

import UIKit

class HomeCell: UICollectionViewCell {
    override func prepareForReuse() {
        super.prepareForReuse()
        topLabel.text = nil
        imageView.image = nil
        titleLabel.text = nil
        introLabel.text = nil
        subtitleLabel.text = nil
        if imageStatus == .loading && !activityIndicatorView.isAnimating {
            activityIndicatorView.startAnimating()
        }
    }
    
    enum Style {
        case `default`
        case topContent
    }
    
    var style = Style.default {
        didSet {
            switch style {
            case .default:
                topLabelHeightLayoutConstraint.constant = 0
                topLabel.text = nil
            case .topContent:
                topLabelHeightLayoutConstraint.constant = 60
            }
        }
    }
    
    let topLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.helvetica(ofsize: 14)
        label.textAlignment = NSTextAlignment.center
        return label
    }()
    private var topLabelHeightLayoutConstraint: NSLayoutConstraint!
    
    enum ImageStatus {
        case loading // hide the image and show activityIndicatorView
        case loaded // show the image and hide activityIndicatorView
    }
    
    var imageStatus = ImageStatus.loading {
        didSet {
            if imageStatus == .loaded {
                imageView.isHidden = false
                activityIndicatorView.stopAnimating()
                activityIndicatorView.removeFromSuperview()
            } else {
                assertionFailure("from loaded cannot change to loading status")
            }
        }
    }
    
    let activityIndicatorView: UIActivityIndicatorView = {
        let view = UIActivityIndicatorView(style: UIActivityIndicatorView.Style.white)
        view.hidesWhenStopped = true
        view.color = UIColor.black
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.zPosition = 10
        view.isUserInteractionEnabled = false
        return view
    }()
    
    
    let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.backgroundColor = UIColor.clear
        imageView.isUserInteractionEnabled = false
        imageView.image = UIImage(named: "home-2")
        imageView.isHidden = true
        imageView.isUserInteractionEnabled = false
        return imageView
    }()
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.backgroundColor = UIColor.clear
        label.isUserInteractionEnabled = false
        label.font = UIFont.systemFont(ofSize: 18, weight: UIFont.Weight.regular)
        label.textAlignment = NSTextAlignment.center
        label.text = "DOLCE & GABBANA"
        label.isUserInteractionEnabled = false
        return label
    }()
    let introLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.backgroundColor = UIColor.clear
        label.isUserInteractionEnabled = false
        label.font = UIFont.systemFont(ofSize: 12, weight: UIFont.Weight.regular)
        label.textAlignment = NSTextAlignment.center
        label.numberOfLines = 0
        label.lineBreakMode = NSLineBreakMode.byWordWrapping
        label.text = "ROOTED IN SILIAN ELEGANCE, DOLCE AND GABBANA IS FAMED FOR OVETLY FEMININE CREATIONS THAT BEAUTIFUL CAPTURE ITALIAN GLAMOUR."
        label.isUserInteractionEnabled = false
        return label
    }()
    
    let subtitleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.backgroundColor = UIColor.clear
        label.isUserInteractionEnabled = false
        label.font = UIFont.systemFont(ofSize: 12, weight: UIFont.Weight.light)
        label.textAlignment = NSTextAlignment.center
        label.text = "SHOP NOW"
        label.isUserInteractionEnabled = false
        return label
    }()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(topLabel)
        addSubview(imageView)
        addSubview(titleLabel)
        addSubview(introLabel)
        addSubview(subtitleLabel)
        
        topLabel.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        topLabel.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        topLabel.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
        topLabelHeightLayoutConstraint = topLabel.heightAnchor.constraint(equalToConstant: 60)
        topLabelHeightLayoutConstraint.isActive = true
        
        imageView.topAnchor.constraint(equalTo: topLabel.bottomAnchor).isActive = true
        imageView.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        imageView.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
        imageView.heightAnchor.constraint(equalToConstant: UIWindow().frame.width).isActive = true
        
        addSubview(activityIndicatorView)
        
        activityIndicatorView.centerXAnchor.constraint(equalTo: imageView.centerXAnchor).isActive = true
        activityIndicatorView.centerYAnchor.constraint(equalTo: imageView.centerYAnchor).isActive = true
        activityIndicatorView.widthAnchor.constraint(equalToConstant: 30).isActive = true
        activityIndicatorView.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        
        titleLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 18).isActive = true
        titleLabel.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 12).isActive = true
        titleLabel.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -12).isActive = true
        
        introLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor).isActive = true
        introLabel.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 12).isActive = true
        introLabel.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -12).isActive = true
        
        subtitleLabel.topAnchor.constraint(equalTo: introLabel.bottomAnchor, constant: 8).isActive = true
        subtitleLabel.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 12).isActive = true
        subtitleLabel.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -12).isActive = true
        subtitleLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
    }
    
    override func preferredLayoutAttributesFitting(_ layoutAttributes: UICollectionViewLayoutAttributes) -> UICollectionViewLayoutAttributes {
        super.preferredLayoutAttributesFitting(layoutAttributes)
        titleLabel.preferredMaxLayoutWidth = layoutAttributes.size.width - contentView.layoutMargins.left - contentView.layoutMargins.right
        introLabel.preferredMaxLayoutWidth = layoutAttributes.size.width - contentView.layoutMargins.left - contentView.layoutMargins.right
        subtitleLabel.preferredMaxLayoutWidth = layoutAttributes.size.width - contentView.layoutMargins.left - contentView.layoutMargins.right
        
        layoutAttributes.bounds.size.height = systemLayoutSizeFitting(UIView.layoutFittingCompressedSize).height
        return layoutAttributes
    }
    
    override func didMoveToSuperview() {
        super.didMoveToSuperview()
        if imageStatus == .loading {
            activityIndicatorView.startAnimating()
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
