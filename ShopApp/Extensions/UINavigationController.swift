//
//  UINavigationController.swift
//  ShopApp
//
//  Created by Nguyễn Đức Huy on 12/13/19.
//  Copyright © 2019 Nguyễn Đức Huy. All rights reserved.
//

import UIKit.UINavigationController

extension UINavigationController {
    func presentPushViewControllerFromRight(_ controller: UIViewController) {
        let transition = CATransition()
        transition.duration = 0.5
        transition.type = CATransitionType.push
        transition.subtype = CATransitionSubtype.fromRight
        transition.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
        
        
        view.window!.layer.add(transition, forKey: kCATransition)
        self.present(controller, animated: false, completion: nil)
    }
    func dismissPushViewControllerFromLeft() {
        let transition = CATransition()
        transition.duration = 0.5
        transition.type = CATransitionType.push
        transition.subtype = CATransitionSubtype.fromLeft
        transition.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
        
        
        view.window!.layer.add(transition, forKey: kCATransition)
        self.dismiss(animated: false, completion: nil)
        
    }
}
