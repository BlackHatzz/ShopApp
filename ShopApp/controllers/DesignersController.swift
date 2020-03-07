//
//  DesignersController.swift
//  ShopApp
//
//  Created by Nguyễn Đức Huy on 1/4/20.
//  Copyright © 2020 Nguyễn Đức Huy. All rights reserved.
//

import UIKit
import Firebase

class DesignersController: UITableViewController {
    let loadingView = ProcessView(title: "Loading", type: ProcessView.NotiType.loading)
    
    var headers = [String]()
    var datas = [String: [String]]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // setupViews
        view.addSubview(loadingView)
        
        view.backgroundColor = UIColor.white
        navigationItem.title = "DESIGNERS"
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        
        tableView.alwaysBounceVertical = true
        tableView.showsVerticalScrollIndicator = false
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(DesignerCell.self, forCellReuseIdentifier: DesignerCell.cellId)
        tableView.register(DesignerHeaderFooter.self, forHeaderFooterViewReuseIdentifier: DesignerHeaderFooter.id)
        
        // download data
        setupContent()
    }
    
    private func setupContent() {
        // get all designers
        let ref = Database.database().reference().child("designer")
        ref.observeSingleEvent(of: DataEventType.value, with: { (snapshot) in
            if let dictionary = snapshot.value as? [String: Any] {
                for i in dictionary.values {
                    if let designer = i as? String {
                        
                        if designer.first!.isLetter {
                            // if designer start with letter
                            if self.datas["\(designer.first!.uppercased())"] == nil {
                                self.datas["\(designer.first!.uppercased())"] = [String]()
                            }
                            self.datas["\(designer.first!.uppercased())"]!.append(designer)
                        } else {
                            // if designer start with number
                            if self.datas["0-9"] == nil {
                                self.datas["0-9"] = [String]()
                            }
                            self.datas["0-9"]!.append(designer)
                        }
                    } // optional binding to get desinger name
                } // loop over dictionary value to get designer name
                
                // sort all designer in datas dictionary
                for key in self.datas.keys {
                    self.datas[key]?.sort()
                }
                
                // get all sorted keys of datas dictionary(use for header in table view)
                self.headers = self.datas.keys.sorted()
                print("headers", self.headers)
                print("designer data:", self.datas)
                
                // reload table view when all is done
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                    
                    // if reload table view is finished then remove loading view
                    self.tableView.performBatchUpdates(nil, completion: { (_) in
                        self.loadingView.removeFromSuperview()
                    })
                }
                
            }
        }) { (error) in
            print(error.localizedDescription)
        }
    }
    
// ------------------------------------------------------------------------------
    override func numberOfSections(in tableView: UITableView) -> Int {
        return headers.count
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let key = headers[section]
        return self.datas[key]?.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: DesignerCell.cellId, for: indexPath) as! DesignerCell
        cell.backgroundColor = UIColor.clear
        
        // get key of header
        let key = headers[indexPath.section]
        // set desinger name label text
        if let designerArray = datas[key] {
            cell.nameLabel.text = designerArray[indexPath.row]
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: DesignerHeaderFooter.id) as! DesignerHeaderFooter
        
        // set header
        header.label.text = headers[section]
        
        return header
    }
    
    override func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let footer = tableView.dequeueReusableHeaderFooterView(withIdentifier: DesignerHeaderFooter.id) as! DesignerHeaderFooter
        
        return footer
    }
    
}

final class DesignerCell: UITableViewCell {
    static let cellId = "designerCellId"
    
    let nameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.isUserInteractionEnabled = false
        label.backgroundColor = UIColor.clear
        label.font = UIFont.helvetica(ofsize: 18)
        label.text = ""
        return label
    }()
    
    let loveBookmarkImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.isUserInteractionEnabled = false
        imageView.backgroundColor = UIColor.clear
        imageView.contentMode = UIView.ContentMode.scaleAspectFill
        imageView.image = UIImage(named: "love-bookmark")?.withRenderingMode(UIImage.RenderingMode.alwaysTemplate)
        imageView.tintColor = UIColor(white: 0.7, alpha: 1)
        return imageView
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupViews()
    }
    
    
    
    private func setupViews() {
        addSubview(nameLabel)
        addSubview(loveBookmarkImageView)
        
        nameLabel.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        nameLabel.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 28).isActive = true
        nameLabel.rightAnchor.constraint(equalTo: loveBookmarkImageView.leftAnchor, constant: -8).isActive = true
        nameLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        
        loveBookmarkImageView.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        loveBookmarkImageView.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -12).isActive = true
        loveBookmarkImageView.widthAnchor.constraint(equalToConstant: 20).isActive = true
        loveBookmarkImageView.heightAnchor.constraint(equalToConstant: 20).isActive = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

final class DesignerHeaderFooter: UITableViewHeaderFooterView {
    static let id = "designerHeaderFooterId"
    
    let containerView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(white: 0.9, alpha: 1)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.isUserInteractionEnabled = false
        return view
    }()
    
    let label: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.isUserInteractionEnabled = false
        label.backgroundColor = UIColor.clear
        label.font = UIFont.helvetica(ofsize: 17)
        label.text = ""
        return label
    }()
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        setupViews()
    }
    
    private func setupViews() {
        addSubview(containerView)
        
        containerView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        containerView.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        containerView.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
        containerView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        
        containerView.addSubview(label)
        
        label.topAnchor.constraint(equalTo: containerView.topAnchor).isActive = true
        label.leftAnchor.constraint(equalTo: containerView.leftAnchor, constant: 16).isActive = true
        label.rightAnchor.constraint(equalTo: containerView.rightAnchor).isActive = true
        label.bottomAnchor.constraint(equalTo: containerView.bottomAnchor).isActive = true
        
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}
