//
//  ViewController.swift
//  ShopApp
//
//  Created by Nguyễn Đức Huy on 7/16/19.
//  Copyright © 2019 Nguyễn Đức Huy. All rights reserved.
//

import UIKit
import Firebase


class HomeController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    private(set) var collectionView: UICollectionView
    private static let cellId = "cellId"
    
    var homeContents = [HomeContent]()
    let loadingView = NotificationView(title: "Loading", type: NotificationView.NotiType.loading)
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: UIBarButtonItem.Style.plain, target: nil, action: nil)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        // show loading view when no data
        view.addSubview(loadingView)
        
        // start load data from database(firebase)
        loadDataFromFirebase()
        
        // set up collection view
        collectionView.backgroundColor = UIColor.white
        collectionView.register(HomeCell.self, forCellWithReuseIdentifier: HomeController.cellId)
        collectionView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 20, right: 0)
        collectionView.showsVerticalScrollIndicator = false
        collectionView.showsHorizontalScrollIndicator = false
        view.addSubview(collectionView)
        collectionView.backgroundColor = .white
        
        // Setup Autolayout constraints
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0).isActive = true
        collectionView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 0).isActive = true
        collectionView.topAnchor.constraint(equalTo: view.topAnchor, constant: 0).isActive = true
        collectionView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: 0).isActive = true
        
        // Setup `dataSource` and `delegate`
        collectionView.dataSource = self
        collectionView.delegate = self
        
        (collectionView.collectionViewLayout as! UICollectionViewFlowLayout).estimatedItemSize = UICollectionViewFlowLayout.automaticSize
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return homeContents.count
    }
    
    init() {
        // Create new `UICollectionView` and set `UICollectionViewFlowLayout` as its layout
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        super.init(nibName: nil, bundle: nil)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HomeController.cellId, for: indexPath) as! HomeCell
        
        if indexPath.row == 0 {
            cell.style = .topContent
            cell.topLabel.text = "Free Every Shipping"
        } else {
            cell.style = .default
        }
        
        if let image = homeContents[indexPath.row].image {
            cell.imageView.image = image
            cell.imageStatus = .loaded
        }
        
        cell.titleLabel.text = homeContents[indexPath.row].title?.uppercased()
        cell.introLabel.text = homeContents[indexPath.row].intro?.uppercased()
        cell.subtitleLabel.text = homeContents[indexPath.row].subtitle?.uppercased()
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let referenceHeight: CGFloat = 500 // Approximate height of your cell
        return CGSize(width: self.view.frame.width, height: referenceHeight)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let viewController = ProductViewController(collectionViewLayout: UICollectionViewFlowLayout())
//        let navController = UINavigationController(rootViewController: viewController)
        self.navigationController?.pushViewController(viewController, animated: true)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func loadDataFromFirebase() {
        let databaseRef = Database.database().reference()
        
        databaseRef.child("home").queryOrderedByKey().observeSingleEvent(of: DataEventType.value, with: { (snapshot) in
            if let nsarray = snapshot.value as? NSArray {
                for (i, value) in nsarray.enumerated() {
                    if let homeContentInfo = value as? [String: Any] {
                        let homeContent = HomeContent(homeContentInfo)
                        self.homeContents.append(homeContent)
                        
                        if let imageUrl = homeContent.imageUrl {
                            if let url = URL(string: imageUrl) {
                                URLSession.shared.dataTask(with: url) { (data, response, error) in
                                    if let error = error {
                                        print(error)
                                        return
                                    }
                                    if let data = data {
                                        if let image = UIImage(data: data) {
                                            self.homeContents[i].image = image
                                            DispatchQueue.main.async {
                                                self.collectionView.reloadData()
                                            }
                                        }
                                    }
                                }.resume()
                            }
                        } // get image url
                        
                        DispatchQueue.main.async {
                            self.collectionView.reloadData()
                        }
                    } // casting value to [String: Any]
                    
                    if i == nsarray.count - 1 {
                        // the final loop
                        self.loadingView.removeFromSuperview()
                    }
                    
                } // iterate over snapshot value (nsarray)
                
                
            }
        }) { (error) in
            print(error.localizedDescription)
        }
    }
    
}

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

//
//class HomeViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
//    private let firstCellId = "firstCellId"
//    private let cellId = "cellId"
//    private let wishListCellId = "wishListCellId"
//
//    var topIntroImageName = "home-1"
//    var imageNames = ["home-2", "home-3", "home-4"]
//
//    let collectionView: UICollectionView = {
//        let layout = UICollectionViewFlowLayout()
//        let collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
//        collectionView.backgroundColor = UIColor.clear
//        collectionView.translatesAutoresizingMaskIntoConstraints = false
//        return collectionView
//    }()
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
////        self.collectionView.register(HomeCell.self, forCellWithReuseIdentifier: cellId)
//        view.addSubview(collectionView)
//        view.backgroundColor = UIColor.white
//        collectionView.delegate = self
//        collectionView.dataSource = self
//        setupViews()
//
//        let backButton = UIBarButtonItem(title: "", style: UIBarButtonItem.Style.plain, target: self, action: nil)
//        navigationItem.backBarButtonItem = backButton
//
//    }
//
//    override func viewWillAppear(_ animated: Bool) {
//        super.viewWillAppear(animated)
//        navigationController?.hidesBarsOnSwipe = false
//    }
//
//    private func setupViews() {
//        collectionView.backgroundColor = UIColor.red
//        view.addConstraints(withFormat: "H:|[v0]|", views: collectionView)
//        view.addConstraints(withFormat: "V:|[v0]|", views: collectionView)
//    }
//
//
//    func numberOfSections(in collectionView: UICollectionView) -> Int {
//        return 4
//    }
//
//    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        if section == 0 || section == 1 || section == 2 { return 1 }
//        return imageNames.count
//    }
//
//    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
////        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! HomeCell
//        var topCell: TopCell?
//        var contentCell: HomeCell?
//        var wisthListCell: HomeWishListCell?
//        if indexPath.section == 0 {
//
//            self.collectionView.register(TopCell.self, forCellWithReuseIdentifier: firstCellId)
//            topCell = collectionView.dequeueReusableCell(withReuseIdentifier: firstCellId, for: indexPath) as? TopCell
//        } else if indexPath.section == 2 {
//            self.collectionView.register(HomeWishListCell.self, forCellWithReuseIdentifier: wishListCellId)
//            wisthListCell = collectionView.dequeueReusableCell(withReuseIdentifier: wishListCellId, for: indexPath) as? HomeWishListCell
//        } else {
//            self.collectionView.register(HomeCell.self, forCellWithReuseIdentifier: cellId)
//            contentCell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as? HomeCell
//        }
//
////        cell.backgroundColor = UIColor.green
//        if indexPath.section == 0 {
//            topCell?.label.text = "Free Every Shipping"
//        } else if indexPath.section == 2 {
//
//        } else {
//            if indexPath.section == 1 {
//                if contentCell?.cardView == nil { contentCell?.cardView = HomeCardView() }
//                contentCell?.cardView?.imageView.image = UIImage(named: self.topIntroImageName)
//                contentCell?.cardView?.introLabel.text = "UP TO 60% OFF"
//                contentCell?.cardView?.titleLabel.text = "SUMMER NOIR"
//                contentCell?.cardView?.descriptionTextView.text = "Monochrome is chic all year-round, especially in the summer! Here's how..."
//            } else {
//                if contentCell?.cardView == nil { contentCell?.cardView = HomeCardView() }
//                contentCell?.cardView?.imageView.image = UIImage(named: imageNames[indexPath.row])
//                contentCell?.cardView?.introLabel.text = "UP TO 60% OFF"
//                contentCell?.cardView?.titleLabel.text = "SUMMER NOIR"
//                contentCell?.cardView?.descriptionTextView.text = "Monochrome is chic all year-round, especially in the summer! Here's how..."
//            }
//            contentCell?.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleTap)))
//        }
//
//        if indexPath.section == 0 { return topCell! }
//        else if indexPath.section == 2 { return wisthListCell!}
//        return contentCell!
//    }
//
//    @objc func handleTap() {
//        let layout = UICollectionViewFlowLayout()
//        let viewController = ProductViewController(collectionViewLayout: layout)
//        self.navigationController?.pushViewController(viewController, animated: true)
//    }
//
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
//        return 15
//    }
//
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//        if indexPath.section == 0 {
//            return CGSize(width: self.view.frame.width, height: 70)
//        } else if indexPath.section == 2 {
//            return  CGSize(width: self.view.frame.width, height: 350)
//        }
//        return CGSize(width: self.view.frame.width, height: 400)
//    }
//
//}
//
//class TopCell: UICollectionViewCell {
//    override func prepareForReuse() {
//        super.prepareForReuse()
////        label.text = nil
//    }
//
//    var label: UILabel = {
//        let label = UILabel()
//        label.textAlignment = .center
//        label.translatesAutoresizingMaskIntoConstraints = false
//        label.font = UIFont.helveticaLight(ofsize: 12)
//        return label
//    }()
//
//    override init(frame: CGRect) {
//        super.init(frame: frame)
//        addSubview(label)
//        addConstraints(withFormat: "H:|[v0]|", views: label)
//        addConstraints(withFormat: "V:|[v0]|", views: label)
//    }
//
//    required init?(coder aDecoder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//
//}
//
