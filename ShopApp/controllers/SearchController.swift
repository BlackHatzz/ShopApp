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
        layout.minimumLineSpacing = 4
        layout.scrollDirection = UICollectionView.ScrollDirection.vertical
        let collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
        collectionView.backgroundColor = UIColor.clear
        collectionView.translatesAutoresizingMaskIntoConstraints = false
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
    }
    
    private func setupView() {
        view.addSubview(containerView)
        
        view.addConstraints(withFormat: "H:|-12-[v0]-12-|", views: containerView)
        view.addConstraints(withFormat: "V:|-(22)-[v0]|", views: containerView)
        
        containerView.addSubview(searchBar)
        containerView.addSubview(searchResultStatusLabel)
        containerView.addSubview(searchResultCollectionView)
        
        searchBar.topAnchor.constraint(equalTo: containerView.topAnchor).isActive = true
        searchBar.leadingAnchor.constraint(equalTo: containerView.leadingAnchor).isActive = true
        searchBar.trailingAnchor.constraint(equalTo: containerView.trailingAnchor).isActive = true
        searchBar.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        searchResultStatusLabel.topAnchor.constraint(equalTo: searchBar.bottomAnchor, constant: 12).isActive = true
        searchResultStatusLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor).isActive = true
        searchResultStatusLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor).isActive = true
        searchResultStatusLabelHeightConstraint = searchResultStatusLabel.heightAnchor.constraint(equalToConstant: 1)
        searchResultStatusLabelHeightConstraint?.isActive = true
        
        searchResultCollectionView.topAnchor.constraint(equalTo: searchResultStatusLabel.bottomAnchor).isActive = true
        searchResultCollectionView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor).isActive = true
        searchResultCollectionView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor).isActive = true
        searchResultCollectionView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor).isActive = true
    }
    
    
    @objc private func handleDoneButton() {
        self.navigationController?.dismiss(animated: true, completion: nil)
    }
    
// ---------------------------------------------------------------
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: searchResultCollectionView.frame.width, height: 40)
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        // 1 for search designers and 1 for search products
        return 2
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
        
        if indexPath.section == 0 {
            // search result is designers
            cell.imageViewCellType = .searchIcon
            
            cell.title.text = designerSearchResult[indexPath.row].title
            cell.subtitle.text = designerSearchResult[indexPath.row].subtitle
        } else {
            // serch result is products
            cell.imageViewCellType = .product
            
            cell.title.text = productSearchResult[indexPath.row].name
            cell.subtitle.text = productSearchResult[indexPath.row].designer
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10
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
        iconImageView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 10).isActive = true
        iconImageView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -10).isActive = true
        iconImageView.widthAnchor.constraint(equalToConstant: 20).isActive = true
        
        textField.leadingAnchor.constraint(equalTo: iconImageView.trailingAnchor, constant: 12).isActive = true
        textField.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
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
            case .product:
                imageView.image = nil
                imageView.backgroundColor = UIColor.red
            }
        }
    }
    
    
    let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "searchBarIcon")?.withRenderingMode(UIImage.RenderingMode.alwaysTemplate)
        imageView.tintColor = UIColor(white: 0.7, alpha: 1)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = UIImageView.ContentMode.scaleAspectFill
//        imageView.backgroundColor = UIColor.blue
        return imageView
    }()
    let title: UILabel = {
        let label = UILabel()
        label.font = UIFont.helvetica(ofsize: 14)
        label.text = "test products"
//        label.backgroundColor = UIColor.yellow
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    let subtitle: UILabel = {
        let label = UILabel()
        label.text = "subtitle"
        label.font = UIFont.helvetica(ofsize: 14)
        label.textColor = UIColor.gray
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = UIColor.clear
        
        // setup views
        addSubview(imageView)
        addSubview(title)
        addSubview(subtitle)
        
        imageView.topAnchor.constraint(equalTo: self.topAnchor, constant: 10).isActive = true
        imageView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 10).isActive = true
        imageView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -10).isActive = true
        imageView.widthAnchor.constraint(equalToConstant: 20).isActive = true
        
        title.leadingAnchor.constraint(equalTo: imageView.trailingAnchor, constant: 12).isActive = true
        title.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        title.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        title.bottomAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        
        subtitle.topAnchor.constraint(equalTo: title.bottomAnchor).isActive = true
        subtitle.leadingAnchor.constraint(equalTo: imageView.trailingAnchor, constant: 12).isActive = true
        subtitle.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        subtitle.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
