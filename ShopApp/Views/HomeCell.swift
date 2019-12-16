//
//  SlideCollectionView.swift
//  ShopApp
//
//  Created by Nguyễn Đức Huy on 7/16/19.
//  Copyright © 2019 Nguyễn Đức Huy. All rights reserved.
//

import UIKit

//class HomeCell: UICollectionViewCell {
//    
//    override func prepareForReuse() {
//        super.prepareForReuse()
////        topLabel?.text = nil
//        cardView?.imageView.image = nil
//        cardView?.introLabel.text = nil
//        cardView?.titleLabel.text = nil
//        cardView?.descriptionTextView.text = nil
//    }
//    
//    
//    var cardView: HomeCardView? {
//        didSet {
//            addSubview(cardView!)
//            addConstraints(withFormat: "H:|[v0]|", views: cardView!)
//            addConstraints(withFormat: "V:|[v0]|", views: cardView!)
//        }
//    }
//    
//    
//    override init(frame: CGRect) {
//        super.init(frame: frame)
//    }
//    
//    required init?(coder aDecoder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//}
//
//class HomeCardView: UIView {
//    let imageView: UIImageView = {
//        let imageView = UIImageView()
//        imageView.backgroundColor = UIColor.black
//        return imageView
//    }()
//    
//    let containerView: UIView = {
//        let view = UIView()
//        view.backgroundColor = UIColor.white
//        view.translatesAutoresizingMaskIntoConstraints = false
//        return view
//    }()
//    let introLabel: UILabel = {
//        let label = UILabel()
//        label.textAlignment = .center
//        label.text = "UP TO 60% OFF"
//        label.font = UIFont.systemFont(ofSize: 14)
//        return label
//    }()
//    let titleLabel: UILabel = {
//        let label = UILabel()
//        label.textAlignment = .center
//        label.text = "UP TO 60% OFF"
//        label.font = UIFont.boldSystemFont(ofSize: 16)
//        return label
//    }()
//    let descriptionTextView: UITextView = {
////        let label = UILabel()
////        label.textAlignment = .center
////        label.text = "UP TO 60% OFF"
////        label.font = UIFont.helveticaLight(ofsize: 12)
////        return label
//        let textView = UITextView()
//        textView.textAlignment = .center
//        textView.text = "UP TO 60% OFF"
//        textView.font = UIFont.helveticaLight(ofsize: 12)
//        return textView
//    }()
//    
//    override init(frame: CGRect) {
//        super.init(frame: frame)
//        setupViews()
//    }
//    
//    private func setupViews() {
//        addSubview(imageView)
//        addSubview(containerView)
//        containerView.addSubview(introLabel)
//        containerView.addSubview(titleLabel)
//        containerView.addSubview(descriptionTextView)
//        
//        addConstraints(withFormat: "H:|[v0]|", views: imageView)
//        addConstraints(withFormat: "V:|[v0]|", views: imageView)
//        
//        containerView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
//        containerView.heightAnchor.constraint(equalToConstant: 100).isActive = true
//        containerView.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
//        containerView.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0.75).isActive = true
//        
//        containerView.addConstraints(withFormat: "H:|[v0]|", views: introLabel)
//        containerView.addConstraints(withFormat: "H:|[v0]|", views: titleLabel)
//        containerView.addConstraints(withFormat: "H:|-12-[v0]-12-|", views: descriptionTextView)
//        containerView.addConstraints(withFormat: "V:|-6-[v0(18)][v1(20)][v2]-6-|", views: introLabel, titleLabel, descriptionTextView)
//        
//        
//    }
//    
//    required init?(coder aDecoder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//}
//
//class HomeWishListCell: UICollectionViewCell {
//    let containerView: UIView = {
//        let view = UIView()
//        view.translatesAutoresizingMaskIntoConstraints = false
//        return view
//    }()
//    
//    let titleLabel: UILabel = {
//        let label = UILabel()
//        label.text = "Keep track of new arrivals from your favorite designers!"
//        label.numberOfLines = 0
//        label.font = UIFont.helvetica(ofsize: 18)
//        label.textAlignment = .center
//        return label
//    }()
//    let descriptionLabel: UILabel = {
//        let label = UILabel()
//        label.numberOfLines = 0
//        label.text = "With 350+ designers at up to 75% off, add your favorites to My Designers to see the latest arrivals all in one place."
//        label.font = UIFont.helveticaLight(ofsize: 14)
//        label.textAlignment = .center
//        return label
//    }()
//    let wishListButton: WishListButton = WishListButton(frame: CGRect.zero)
//    
//    
//    
//    override init(frame: CGRect) {
//        super.init(frame: frame)
//        addSubview(containerView)
//        
//        containerView.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
//        containerView.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
//        containerView.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0.75).isActive = true
//        containerView.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: 0.6).isActive = true
//        
//        containerView.addSubview(titleLabel)
//        containerView.addSubview(descriptionLabel)
//        containerView.addSubview(wishListButton)
//        
//        containerView.backgroundColor = UIColor.white
//        wishListButton.backgroundColor = UIColor.white
//        
//        containerView.addConstraints(withFormat: "H:|[v0]|", views: titleLabel)
//        containerView.addConstraints(withFormat: "H:|[v0]|", views: descriptionLabel)
//        containerView.addConstraints(withFormat: "H:|[v0]|", views: wishListButton)
//        
//        containerView.addConstraints(withFormat: "V:|[v0(60)]-10-[v1]-[v2(35)]|", views: titleLabel, descriptionLabel, wishListButton)
//    }
//    
//    required init?(coder aDecoder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//}
//
//class WishListButton: UIButton {
//    let iconImageView: UIImageView = {
//        let imageView = UIImageView()
//        imageView.translatesAutoresizingMaskIntoConstraints = false
//        imageView.backgroundColor = UIColor.clear
//        imageView.image = UIImage(named: "tag")
//        imageView.isUserInteractionEnabled = false
//        return imageView
//    }()
//    
//    let headerLabel: UILabel = {
//        let label = UILabel()
//        label.text = "Create Wish List"
//        label.font = UIFont.helveticaLight(ofsize: 14)
//        
//        let attributedText = NSMutableAttributedString(string: "Create My Wish List", attributes: [NSAttributedString.Key.kern : 1.15])
//        
//        label.textAlignment = .center
//        label.attributedText = attributedText
//        label.isUserInteractionEnabled = false
//        return label
//    }()
//    
//    override init(frame: CGRect) {
//        super.init(frame: frame)
//        
//        addSubview(iconImageView)
//        addSubview(headerLabel)
//        addConstraints(withFormat: "V:|-5-[v0]-5-|", views: iconImageView)
//        addConstraints(withFormat: "V:|[v0]|", views: headerLabel)
//        
//        iconImageView.widthAnchor.constraint(equalTo: iconImageView.heightAnchor).isActive = true
//        
//        addConstraints(withFormat: "H:|-10-[v0][v1]-17-|", views: iconImageView, headerLabel)
//        
//        addTarget(self, action: #selector(handleCreateWishList), for: UIControl.Event.touchUpInside)
////        addTarget(self, action: #selector(handleTouchDown), for: UIControl.Event.touchDown)
////        addTarget(self, action: #selector(handleTouchUpOutSide), for: UIControl.Event.touchDragInside)
//        
//        self.layer.borderWidth = 1
//        self.layer.borderColor = UIColor.lightGray.cgColor
//    }
//    
//    @objc func handleTouchDown() {
//        self.backgroundColor = UIColor.black
//        self.headerLabel.textColor = UIColor.white
//        self.iconImageView.image = nil
//    }
//    @objc func handleTouchUpOutSide() {
//        print("out side")
//        self.backgroundColor = UIColor.white
//        self.headerLabel.textColor = UIColor.black
//        self.iconImageView.image = UIImage(named: "tag")
//    }
//    
//    @objc func handleCreateWishList() {
//        print("inside")
//        self.backgroundColor = UIColor.white
//        self.headerLabel.textColor = UIColor.black
//        self.iconImageView.image = UIImage(named: "tag")
//    }
//    
//    required init?(coder aDecoder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//}
