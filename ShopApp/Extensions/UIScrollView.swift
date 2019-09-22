//
//  UIScrollView.swift
//  ShopApp
//
//  Created by Nguyễn Đức Huy on 7/19/19.
//  Copyright © 2019 Nguyễn Đức Huy. All rights reserved.
//

import UIKit

extension UIScrollView {
    func resize(direction: Direction) {
        var contentRect = CGRect.zero
        
        switch direction {
        case .horizontal:
            for view in self.subviews {
                contentRect.size.width += view.frame.width
            }
            self.contentSize.width = contentRect.size.height
            
        case .vertical:
            for view in self.subviews {
                print("subview:", view.frame)
                contentRect = contentRect.union(view.frame)
            }
            self.contentSize.height = contentRect.size.width
            print("vertical height: ", contentSize.height)
        case .all:
            for view in self.subviews {
                contentRect = contentRect.union(view.frame)
                print("s", view.frame)
            }
            self.contentSize = contentRect.size
        }
     
    }
}
