//
//  TabController.swift
//  ShopApp
//
//  Created by Nguyễn Đức Huy on 7/16/19.
//  Copyright © 2019 Nguyễn Đức Huy. All rights reserved.
//

import UIKit

class TabController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()

        let homeController = HomeViewController()
        let homeNav = UINavigationController(rootViewController: homeController)
        homeNav.title = "Home"
        homeNav.tabBarItem.image = UIImage(named: "home-icon")
        homeNav.navigationBar.barTintColor = UIColor.white
        homeNav.navigationBar.isTranslucent = false
//        homeNav.isNavigationBarHidden = true
        
        let cartController = CartViewController()
        let cartNav = UINavigationController(rootViewController: cartController)
        cartNav.title = "Cart"
        cartNav.tabBarItem.image = UIImage(named: "cart-icon")
        
        
        viewControllers = [homeNav, cartNav]
        self.tabBar.isTranslucent = false
        UITabBar.appearance().tintColor = UIColor.black
    }
    


}