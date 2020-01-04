//
//  Temp.swift
//  ShopApp
//
//  Created by Nguyễn Đức Huy on 12/15/19.
//  Copyright © 2019 Nguyễn Đức Huy. All rights reserved.
//

import UIKit


let samuelQuotes = [
    "Normally, both your asses would be dead as fucking fried chicken, but you happen to pull this shit while I'm in a transitional period so I don't wanna kill you, I wanna help you. But I can't give you this case, it don't belong to me. Besides, I've already been through too much shit this morning over this case to hand it over to your dumb ass. fldsf';k'sa;dkj f;d'kf'aksdlfk 'wkads'fk 'adlskfds' fkds f;skd' fk;lsadkfk lsdkf 'skdkf 'a;kd fks'l;dk fkas'd;kf ';asdk;'f k;sdk 'fksak dfl;k'sd;fkl ojtre[jqrtoperqmevkmfq efm[ v qoe[j [or[eqt9ur[iot [eqroqvm vq oejf[ojrpgjopqiu[pouteopqr q]g qjeoprgj osda'gjao  jeo'rjg qojertu p'qoerjglaejrgpo eor h eiohgoiqehrotuyoiqeryoij 're qioreht[rh ogja;lkrjg roe oqerjtoiquoit jr  ijer'oht'o re'oi ro 'qerioy'erqoig ireh/lgkh¬˚hrg ¬aerh.hgaelr h tglerlhiea/ht gwh; g;h grih gwrhg whghelrhgjk rbek.jgkebfoigegbfiehgo iwegh i ho;ghoh4",
    "Well, the way they make shows is, they make one show. That show's called a pilot.",
    "My money's in that office, right? If she start giving me some bullshit about it ain't there, and we got to go someplace else and get it, I'm gonna shoot you in the head then and there.",
    "The path of the righteous man is beset on all sides by the iniquities of the selfish and the tyranny of evil men.",
    "And I will strike down upon thee with great vengeance and furious anger those who would attempt to poison and destroy My brothers. And you will know My name is the Lord when I lay My vengeance upon thee."
]

class DynamicCollectionViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    private(set) var collectionView: UICollectionView
    
    // Initializers
    init() {
        // Create new `UICollectionView` and set `UICollectionViewFlowLayout` as its layout
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        // Create new `UICollectionView` and set `UICollectionViewFlowLayout` as its layout
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Dynamic size sample"
        
        // Register Cells
        collectionView.register(MultilineLabelCell.self, forCellWithReuseIdentifier: MultilineLabelCell.reuseId)
        
        // Add `coolectionView` to display hierarchy and setup its appearance
        view.addSubview(collectionView)
        collectionView.backgroundColor = .white
        collectionView.contentInsetAdjustmentBehavior = .always
        collectionView.contentInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        
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
        (collectionView.collectionViewLayout as! UICollectionViewFlowLayout).sectionInsetReference = .fromLayoutMargins
    }
    
    // MARK: - UICollectionViewDataSource -
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MultilineLabelCell.reuseId, for: indexPath) as! MultilineLabelCell
        cell.configure(text: samuelQuotes[indexPath.row])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return samuelQuotes.count
    }
    
    // MARK: - UICollectionViewDelegateFlowLayout -
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let sectionInset = (collectionViewLayout as! UICollectionViewFlowLayout).sectionInset
        let referenceHeight: CGFloat = 100 // Approximate height of your cell
        let referenceWidth = collectionView.safeAreaLayoutGuide.layoutFrame.width
            - sectionInset.left
            - sectionInset.right
            - collectionView.contentInset.left
            - collectionView.contentInset.right
        return CGSize(width: referenceWidth, height: referenceHeight)
    }
}

class MultilineLabelCell: UICollectionViewCell {
    static let reuseId = "MultilineLabelCellReuseId"
    
    private let label: UILabel = UILabel(frame: .zero)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        layer.borderColor = UIColor.red.cgColor
        layer.borderWidth = 1.0
        
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        
        let labelInset = UIEdgeInsets(top: 10, left: 10, bottom: -10, right: -10)
        contentView.addSubview(label)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.topAnchor.constraint(equalTo: contentView.layoutMarginsGuide.topAnchor, constant: labelInset.top).isActive = true
        label.leadingAnchor.constraint(equalTo: contentView.layoutMarginsGuide.leadingAnchor, constant: labelInset.left).isActive = true
        label.trailingAnchor.constraint(equalTo: contentView.layoutMarginsGuide.trailingAnchor, constant: labelInset.right).isActive = true
        label.bottomAnchor.constraint(equalTo: contentView.layoutMarginsGuide.bottomAnchor, constant: labelInset.bottom).isActive = true
        
        label.layer.borderColor = UIColor.black.cgColor
        label.layer.borderWidth = 1.0
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("Storyboards are quicker, easier, more seductive. Not stronger then Code.")
    }
    
    func configure(text: String?) {
        label.text = text
    }
    
    override func preferredLayoutAttributesFitting(_ layoutAttributes: UICollectionViewLayoutAttributes) -> UICollectionViewLayoutAttributes {
        label.preferredMaxLayoutWidth = layoutAttributes.size.width - contentView.layoutMargins.left - contentView.layoutMargins.left
        layoutAttributes.bounds.size.height = systemLayoutSizeFitting(UIView.layoutFittingCompressedSize).height
        return layoutAttributes
    }
}
