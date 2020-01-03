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
