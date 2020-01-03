//
//  SearchController.swift
//  ShopApp
//
//  Created by Nguyễn Đức Huy on 10/2/19.
//  Copyright © 2019 Nguyễn Đức Huy. All rights reserved.
//

import UIKit
import Firebase


private let cellId = "cellId"
private let databaseRef = Database.database().reference(fromURL: "https://shopapp-96ec7.firebaseio.com/")

class SearchingController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UITextFieldDelegate {
    
    
    let containerView = UIView()
    let searchBar: SearchBar = {
        let searchBar = SearchBar()
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        return searchBar
    }()
    var productDataTask: URLSessionDataTask? = nil
    
//    private var searchResult: [(id: String, title: String, subtitle: String)] = [(String, String, String)]()
    private var designerSearchResult: [(id: String, title: String, subtitle: String)] = [(String, String, String)]()
    private var productSearchResult = [Product]()
    
    let searchResultStatusLabel: UILabel = {
        let label = UILabel()
        label.text = "NOT FOUND"
        label.textAlignment = NSTextAlignment.center
        label.textColor = UIColor.gray
        label.font = UIFont.helvetica(ofsize: 16)
        label.isHidden = true
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    var searchResultStatusLabelHeightConstraint: NSLayoutConstraint? = nil
    
    let searchResultCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 10
        layout.scrollDirection = UICollectionView.ScrollDirection.vertical
        let collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
        collectionView.backgroundColor = UIColor.clear
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.alwaysBounceVertical = true
        return collectionView
    }()
    
    let dividerLineView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.lightGray
        return view
    }()
    
// ------------------------------------------------------------------------------
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white
        
        searchResultCollectionView.delegate = self
        searchResultCollectionView.dataSource = self
        searchResultCollectionView.register(SearchResultCollectionViewCell.self, forCellWithReuseIdentifier: cellId)
        
        searchBar.textField.addTarget(self, action: #selector(textFieldDidChange), for: UIControl.Event.editingChanged)
        
        setupNavBar()
        setupView()
    }
    
    @objc func textFieldDidChange(_ sender: UITextField) {
        print("")
        print("change text field:", sender.text as Any)
        
        // remove all searchResult when user change textField and remove collection view
        DispatchQueue.main.async {
            databaseRef.removeAllObservers()
            self.productDataTask?.cancel()
            self.productDataTask = nil
            self.designerSearchResult.removeAll()
            self.productSearchResult.removeAll()
            self.searchResultCollectionView.reloadData()
        }
        
        // search text cannot be nil and empty
        // change searchText to lowercased
        guard let searchText = sender.text?.lowercased() else { return }
        if searchText.count < 3 {
            self.searchResultStatusLabel.text = "Input at least 3 characters"
            self.searchResultStatusLabel.isHidden = false
            self.searchResultStatusLabelHeightConstraint?.constant = 20
            return
        } else {
            self.searchResultStatusLabel.text = nil
            self.searchResultStatusLabel.isHidden = true
            self.searchResultStatusLabelHeightConstraint?.constant = 1
        }
        print("search text", searchText)
        
        // search by designers
        databaseRef.child("product").queryOrdered(byChild: "designerSearch").observe(DataEventType.value, with: { (snapshot) in
            DispatchQueue.main.async {
                // remove previous data before get new data
                self.designerSearchResult.removeAll()
                self.searchResultCollectionView.reloadData()
            
                if let dictionary = snapshot.value as? [String: Any] {
                    // dictionary: id - product info
                    for key in dictionary.keys {
                        // get produt info from id(key)
                        if let productInfo = dictionary[key] as? [String: Any] {
                            // get designer name
                            if let designerSearch = productInfo["designerSearch"] as? String {
                                if let designer = productInfo[Product.InfoKey.designer] as? String {
                                    // if designer name contain searchText
                                    if designerSearch.contains(searchText) {
                                        self.designerSearchResult.append((id: key, title: designer, subtitle: "Designer"))
                                        
                                        DispatchQueue.main.async {
                                            self.searchResultCollectionView.reloadData()
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
                
                // when search result is empty
                if self.productSearchResult.isEmpty && self.designerSearchResult.isEmpty {
                    self.searchResultStatusLabel.text = "NOT FOUND"
                    self.searchResultStatusLabel.isHidden = false
                    self.searchResultStatusLabelHeightConstraint?.constant = 20
                } else {
                    // if search result is not empty
                    self.searchResultStatusLabel.text = nil
                    self.searchResultStatusLabel.isHidden = true
                    self.searchResultStatusLabelHeightConstraint?.constant = 1
                }
                
            } // async queue
        }) { (error) in
            print(error.localizedDescription)
        }
        
        // search by products
        databaseRef.child("product").queryOrdered(byChild: "nameSearch").observe(DataEventType.value, with: { (snapshot) in
            DispatchQueue.main.async {
                // remove previous data before get new data
                self.productSearchResult.removeAll()
                self.searchResultCollectionView.reloadData()
            
                if let dictionary = snapshot.value as? [String: Any] {
                    // dictionary: id - product info
                    for key in dictionary.keys {
                        // get produt info from id(key)
                        if let productInfo = dictionary[key] as? [String: Any] {
                            // get nameSearch to compare searchText
                            if let nameSearch = productInfo["nameSearch"] as? String {
                                if nameSearch.contains(searchText) {
                                    // get product info
                                    let searchedProduct = Product(id: key, productInfo: productInfo)
                                    self.productSearchResult.append(searchedProduct)
                                    
                                    // get the first image
                                    self.productDataTask = self.productSearchResult.last!.loadFirstImage(completionHandler: {
                                        // reload data when downloaded image
                                        DispatchQueue.main.async {
                                            self.searchResultCollectionView.reloadData()
                                        }
                                    })
                                }
                            }
                        }
                    } //  iterate over dictionary
                }
                
                // when search result is empty
                if self.productSearchResult.isEmpty && self.designerSearchResult.isEmpty {
                    self.searchResultStatusLabel.text = "NOT FOUND"
                    self.searchResultStatusLabel.isHidden = false
                    self.searchResultStatusLabelHeightConstraint?.constant = 20
                } else {
                    // if search result is not empty
                    self.searchResultStatusLabel.text = nil
                    self.searchResultStatusLabel.isHidden = true
                    self.searchResultStatusLabelHeightConstraint?.constant = 1
                }
                
            } // async queue
        }) { (error) in
            print(error.localizedDescription)
        }
    } // textFieldDidChange

// ------------------------------------------------------------------------------
    
    private func setupNavBar() {
        navigationItem.title = "SEARCH"
        
        let doneButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.done, target: self, action: #selector(handleDoneButton))
        
        self.navigationItem.rightBarButtonItem = doneButton
        
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: UIBarButtonItem.Style.plain, target: nil, action: nil)
    }
    
    private func setupView() {
        view.addSubview(containerView)
        
        view.addConstraints(withFormat: "H:|-12-[v0]-12-|", views: containerView)
        view.addConstraints(withFormat: "V:|-(22)-[v0]|", views: containerView)
        
        containerView.addSubview(searchBar)
        containerView.addSubview(searchResultStatusLabel)
        containerView.addSubview(searchResultCollectionView)
        
        searchBar.topAnchor.constraint(equalTo: containerView.topAnchor).isActive = true
        searchBar.leftAnchor.constraint(equalTo: containerView.leftAnchor).isActive = true
        searchBar.rightAnchor.constraint(equalTo: containerView.rightAnchor).isActive = true
        searchBar.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        searchResultStatusLabel.topAnchor.constraint(equalTo: searchBar.bottomAnchor, constant: 12).isActive = true
        searchResultStatusLabel.leftAnchor.constraint(equalTo: containerView.leftAnchor).isActive = true
        searchResultStatusLabel.rightAnchor.constraint(equalTo: containerView.rightAnchor).isActive = true
        searchResultStatusLabelHeightConstraint = searchResultStatusLabel.heightAnchor.constraint(equalToConstant: 1)
        searchResultStatusLabelHeightConstraint?.isActive = true
        
        searchResultCollectionView.topAnchor.constraint(equalTo: searchResultStatusLabel.bottomAnchor).isActive = true
        searchResultCollectionView.leftAnchor.constraint(equalTo: containerView.leftAnchor).isActive = true
        searchResultCollectionView.rightAnchor.constraint(equalTo: containerView.rightAnchor).isActive = true
        searchResultCollectionView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor).isActive = true
    }
    
    
    @objc private func handleDoneButton() {
        self.navigationController?.dismiss(animated: true, completion: nil)
    }
    
// ---------------------------------------------------------------
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if indexPath.section == 0 {
            return CGSize(width: searchResultCollectionView.frame.width, height: 40)
        }
        return CGSize(width: searchResultCollectionView.frame.width, height: 60)
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        // 1 for search designers and 1 for search products
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        if section == 0 {
            return UIEdgeInsets(top: 0, left: 0, bottom: 20, right: 0)
        }
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        print("co", designerSearchResult, productSearchResult)
        if section == 0 {
            return designerSearchResult.count
        }
        return productSearchResult.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! SearchResultCollectionViewCell
        cell.imageView.image = UIImage(named: "searchBarIcon")?.withRenderingMode(UIImage.RenderingMode.alwaysTemplate)
        
        cell.removeTopLineLayer()
        
        if indexPath.section == 0 {
            // search result is designers
            cell.imageViewCellType = .searchIcon
            
            cell.title.text = designerSearchResult[indexPath.row].title
            cell.subtitle.text = designerSearchResult[indexPath.row].subtitle
        } else {
            // serch result is products
            cell.imageViewCellType = .product
            
            cell.imageView.image = productSearchResult[indexPath.row].images[0]?[0]
            cell.title.text = productSearchResult[indexPath.row].name
            cell.subtitle.text = productSearchResult[indexPath.row].designer
            
            if indexPath.row == 0 && indexPath.section == 1 {
                cell.addTopLineLayer()
//                let topLineLayer = CALayer()
//                topLineLayer.backgroundColor = UIColor.gray.cgColor
//                topLineLayer.frame = CGRect(x: 0, y: 0, width: self.searchResultCollectionView.frame.width, height: 1)
//
//                cell.layer.addSublayer(topLineLayer)
            }
        }
        
        return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.section == 0 { return }
        let viewController = ProductDetailController(ofProduct: productSearchResult[indexPath.row])
        self.navigationController?.pushViewController(viewController, animated: true)
    }
    
    
// ---------------------------------------------------------------------------
    
}
// ---------------------------------------------------------------------------
// ---------------------------------------------------------------------------
class SearchBar: UIView {
    let iconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "searchBarIcon")?.withRenderingMode(UIImage.RenderingMode.alwaysTemplate)
        imageView.tintColor = UIColor(white: 0.1, alpha: 1)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = UIImageView.ContentMode.scaleAspectFill
        return imageView
    }()
    
    let textField: UITextField = {
        let textField = UITextField()
        textField.backgroundColor = UIColor.clear
        textField.layer.masksToBounds = true
        textField.translatesAutoresizingMaskIntoConstraints = false
        
        typealias Key = NSAttributedString.Key
        
        let attributes = [Key.font: UIFont.helveticaLight(ofsize: 12), Key.foregroundColor: UIColor(white: 0.6, alpha: 1)]
        textField.attributedPlaceholder = NSAttributedString(string: "Search products & designers", attributes: attributes)
        
        return textField
    }()
    
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = UIColor.init(white: 0.9, alpha: 1)
        layer.cornerRadius = 8
        layer.masksToBounds = true
        
        // setup views
        addSubview(iconImageView)
        addSubview(textField)
        
        iconImageView.topAnchor.constraint(equalTo: self.topAnchor, constant: 10).isActive = true
        iconImageView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 10).isActive = true
        iconImageView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -10).isActive = true
        iconImageView.widthAnchor.constraint(equalToConstant: 20).isActive = true
        
        textField.leftAnchor.constraint(equalTo: iconImageView.rightAnchor, constant: 12).isActive = true
        textField.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
        textField.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        textField.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class SearchResultCollectionViewCell: UICollectionViewCell {
    override func prepareForReuse() {
        super.prepareForReuse()
        self.imageView.image = nil
        title.text = nil
        subtitle.text = nil
    }
    
    enum ImageViewCellType {
        case searchIcon
        case product
    }
    var imageViewCellType = ImageViewCellType.searchIcon {
        didSet {
            switch imageViewCellType {
            case .searchIcon:
                imageView.image = UIImage(named: "searchBarIcon")?.withRenderingMode(UIImage.RenderingMode.alwaysTemplate)
                imageView.tintColor = UIColor(white: 0.7, alpha: 1)
                
                imageViewTopLayoutConstraint.isActive = false
                imageViewLeftLayoutConstraint.isActive = false
                imageViewRightLayoutConstraint.isActive = false
                imageViewBottomLayoutConstraint.isActive = false
                
                imageViewTopLayoutConstraint.constant = 10
                imageViewLeftLayoutConstraint.constant = 10
                imageViewRightLayoutConstraint.constant = -10
                imageViewBottomLayoutConstraint.constant = 20
                
                imageViewTopLayoutConstraint.isActive = true
                imageViewLeftLayoutConstraint.isActive = true
                imageViewRightLayoutConstraint.isActive = true
                imageViewBottomLayoutConstraint.isActive = true
                
            case .product:
                imageView.image = nil
                
                imageViewTopLayoutConstraint.isActive = false
                imageViewLeftLayoutConstraint.isActive = false
                imageViewRightLayoutConstraint.isActive = false
                imageViewBottomLayoutConstraint.isActive = false
                
                imageViewTopLayoutConstraint.constant = 5
                imageViewLeftLayoutConstraint.constant = 5
                imageViewRightLayoutConstraint.constant = -5
                imageViewBottomLayoutConstraint.constant = 30
                
                imageViewTopLayoutConstraint.isActive = true
                imageViewLeftLayoutConstraint.isActive = true
                imageViewRightLayoutConstraint.isActive = true
                imageViewBottomLayoutConstraint.isActive = true
            }
        }
    }
    
    let containerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor.clear
        return view
    }()
    
    private let topLineLayer: CALayer = {
        let layer = CALayer()
        layer.backgroundColor = UIColor(white: 0.7, alpha: 1).cgColor
        return layer
    }()
    
    func addTopLineLayer() {
        containerView.layer.addSublayer(topLineLayer)
        topLineLayer.frame = CGRect(x: 0, y: -5, width: self.frame.width * 0.9, height: 1)
        topLineLayer.position = CGPoint(x: self.frame.width/2, y: -5)
    }
    func removeTopLineLayer() {
        topLineLayer.removeFromSuperlayer()
    }
    
    let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "searchBarIcon")?.withRenderingMode(UIImage.RenderingMode.alwaysTemplate)
        imageView.tintColor = UIColor(white: 0.7, alpha: 1)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = UIImageView.ContentMode.scaleAspectFill
        imageView.backgroundColor = UIColor.clear
        return imageView
    }()
    
    private var imageViewTopLayoutConstraint: NSLayoutConstraint!
    private var imageViewLeftLayoutConstraint: NSLayoutConstraint!
    private var imageViewRightLayoutConstraint: NSLayoutConstraint!
    private var imageViewBottomLayoutConstraint: NSLayoutConstraint!
    
    
    let titleContainerView: UIView = {
        let stackView = UIStackView()
        stackView.backgroundColor = UIColor.yellow
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    let title: UILabel = {
        let label = UILabel()
        label.font = UIFont.helvetica(ofsize: 14)
        label.text = "test products"
//        label.backgroundColor = UIColor.yellow
        label.translatesAutoresizingMaskIntoConstraints = false
        label.backgroundColor = UIColor.clear
        return label
    }()
    let subtitle: UILabel = {
        let label = UILabel()
        label.text = "subtitle"
        label.font = UIFont.helvetica(ofsize: 14)
        label.textColor = UIColor.gray
        label.translatesAutoresizingMaskIntoConstraints = false
        label.backgroundColor = UIColor.clear
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = UIColor.clear
        
        // setup views
        addSubview(containerView)
        
        containerView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        containerView.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        containerView.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        containerView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        
        containerView.addSubview(imageView)
        containerView.addSubview(titleContainerView)
        
        titleContainerView.addSubview(title)
        titleContainerView.addSubview(subtitle)
        
        imageViewTopLayoutConstraint = imageView.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 10)
        imageViewLeftLayoutConstraint = imageView.leftAnchor.constraint(equalTo: containerView.leftAnchor, constant: 10)
        imageViewRightLayoutConstraint = imageView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -10)
        imageViewBottomLayoutConstraint = imageView.widthAnchor.constraint(equalToConstant: 20)
        
        imageViewTopLayoutConstraint.isActive = true
        imageViewLeftLayoutConstraint.isActive = true
        imageViewRightLayoutConstraint.isActive = true
        imageViewBottomLayoutConstraint.isActive = true
        
        titleContainerView.centerYAnchor.constraint(equalTo: containerView.centerYAnchor).isActive = true
        titleContainerView.leftAnchor.constraint(equalTo: imageView.rightAnchor, constant: 12).isActive = true
        titleContainerView.rightAnchor.constraint(equalTo: containerView.rightAnchor).isActive = true
        titleContainerView.heightAnchor.constraint(equalToConstant: 41).isActive = true
        
        title.leftAnchor.constraint(equalTo: titleContainerView.leftAnchor).isActive = true
        title.rightAnchor.constraint(equalTo: titleContainerView.rightAnchor).isActive = true
        title.topAnchor.constraint(equalTo: titleContainerView.topAnchor).isActive = true
        title.heightAnchor.constraint(equalToConstant: 18).isActive = true
        
        subtitle.topAnchor.constraint(equalTo: title.bottomAnchor, constant: 5).isActive = true
        subtitle.leftAnchor.constraint(equalTo: titleContainerView.leftAnchor).isActive = true
        subtitle.rightAnchor.constraint(equalTo: titleContainerView.rightAnchor).isActive = true
        subtitle.bottomAnchor.constraint(equalTo: titleContainerView.bottomAnchor).isActive = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
