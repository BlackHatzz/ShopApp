//
//  ProductCollectionView.swift
//  ShopApp
//
//  Created by Nguyễn Đức Huy on 9/12/19.
//  Copyright © 2019 Nguyễn Đức Huy. All rights reserved.
//

import UIKit

final class ProductCollectionView: UICollectionView {
    var statusCell = [String?]()
    struct StatusCellKey {
        static let initialization = "initialization"
        static let loading = "loading"
        static let loaded = "loaded"
    }
    
    override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        super.init(frame: frame, collectionViewLayout: layout)
        assert(self.numberOfSections == 1, "number of section must be 1")
        self.statusCell = Array(repeating: ProductCollectionView.StatusCellKey.initialization, count: numberOfItems(inSection: 0))
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
