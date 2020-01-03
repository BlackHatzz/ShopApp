//
//  UserInfoController.swift
//  ShopApp
//
//  Created by Nguyễn Đức Huy on 12/16/19.
//  Copyright © 2019 Nguyễn Đức Huy. All rights reserved.
//

import UIKit
import Firebase

class UserInfoController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    let userInfoContents: [UserInfoContent] = [
//        UserInfoContent(image: UIImage(named: "heart"), title: "WISH LIST", subtitle: "2 items in your Wish List"),
//        UserInfoContent(image: UIImage(named: "user"), title: "MY ACCOUNT", subtitle: customer.fullname ?? "Sign in or Register"),
        UserInfoContent(image: UIImage(named: "feedback"), title: "FEEDBACK", subtitle: "Tell us what you think"),
        UserInfoContent(image: UIImage(named: "about"), title: "ABOUT US", subtitle: "350+ designers"),
//        UserInfoContent(image: UIImage(named: "orders"), title: "ORDERS", subtitle: "Track and view your orders"),
    ]
    
    let userInfoCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = UICollectionView.ScrollDirection.vertical
        layout.minimumLineSpacing = 0
        let collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
        collectionView.alwaysBounceVertical = true
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.showsVerticalScrollIndicator = false
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.backgroundColor = UIColor.white
        return collectionView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "MORE"
        view.backgroundColor = UIColor.white
        
        userInfoCollectionView.register(UserInfoCollectionViewCell.self, forCellWithReuseIdentifier: UserInfoCollectionViewCell.cellId)
        userInfoCollectionView.delegate = self
        userInfoCollectionView.dataSource = self
        
        setupViews()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print("appear")
        userInfoContents[1].subtitle = customer.fullname ?? "Sign in or Register"
        
//        let ref = Database.database().reference().child("order")
//        if let id = customer.id {
//            ref.queryOrdered(byChild: "customerId").queryEqual(toValue: id).observeSingleEvent(of: DataEventType.value, with: { (snapshot) in
//                print("history", snapshot.key)
//                print(snapshot.value)
//                print("--")
//                dump(snapshot.value)
//            }) { (error) in
//                print(error.localizedDescription)
//            }
//        }
        
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
//        userInfoCollectionView.reloadItems(at: [IndexPath(item: 1, section: 0)])
    }
    
    private func setupViews() {
        view.addSubview(userInfoCollectionView)

        userInfoCollectionView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        userInfoCollectionView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        userInfoCollectionView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        userInfoCollectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
    }
    
    
// ---------------------------------------------------------------------------------------------
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return userInfoContents.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: UserInfoCollectionViewCell.cellId, for: indexPath) as! UserInfoCollectionViewCell
        
        cell.iconImageView.image = userInfoContents[indexPath.row].image
        cell.titleLabel.text = userInfoContents[indexPath.row].title
        cell.subtitleLabel.text = userInfoContents[indexPath.row].subtitle
        
//        cell.backgroundColor = .green
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        if indexPath.row == 1 {
//            let viewController = SignInController()
//            let navController = UINavigationController(rootViewController: viewController)
//            self.navigationController?.present(navController, animated: true, completion: nil)
//        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width, height: 80)
    }
}

class UserInfoCollectionViewCell: UICollectionViewCell {
    static let cellId = "userInfoCollectionViewCellId"
    
    override func prepareForReuse() {
        super.prepareForReuse()
        iconImageView.image = nil
        titleLabel.text = nil
        subtitleLabel.text = nil
    }
    
    let iconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.backgroundColor = UIColor.clear
        imageView.contentMode = UIView.ContentMode.scaleAspectFill
        imageView.image = UIImage(named: "heart")
        return imageView
    }()
    
    let containerTitleView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor.clear
        return view
    }()
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.helvetica(ofsize: 16)
        label.text = "WISH LIST"
//        label.backgroundColor = .red
        return label
    }()
    
    let subtitleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.helvetica(ofsize: 12)
        label.textColor = UIColor(white: 0.5, alpha: 1)
        label.text = "2 items in your Wish List"
//        label.backgroundColor = .blue
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    private func setupViews() {
        addSubview(iconImageView)
        addSubview(titleLabel)
        addSubview(subtitleLabel)
        
        iconImageView.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        iconImageView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 20).isActive = true
        iconImageView.widthAnchor.constraint(equalToConstant: 25).isActive = true
        iconImageView.heightAnchor.constraint(equalToConstant: 25).isActive = true
        
        titleLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor, constant: -10).isActive = true
        titleLabel.leftAnchor.constraint(equalTo: iconImageView.rightAnchor, constant: 12).isActive = true
        titleLabel.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -12).isActive = true
        titleLabel.heightAnchor.constraint(equalToConstant: 20).isActive = true
        
        subtitleLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor).isActive = true
        subtitleLabel.leftAnchor.constraint(equalTo: iconImageView.rightAnchor, constant: 12).isActive = true
        subtitleLabel.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -12).isActive = true
        subtitleLabel.heightAnchor.constraint(equalToConstant: 20).isActive = true
    }
    
    override func preferredLayoutAttributesFitting(_ layoutAttributes: UICollectionViewLayoutAttributes) -> UICollectionViewLayoutAttributes {
        super.preferredLayoutAttributesFitting(layoutAttributes)
        return layoutAttributes
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


class UserInfoContent {
    var image: UIImage?
    var title: String?
    var subtitle: String?
    
    init(image: UIImage?, title: String?, subtitle: String?) {
        self.image = image
        self.title = title
        self.subtitle = subtitle
    }
}
