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

        let homeController = HomeController()
        
        let homeNav = UINavigationController(rootViewController: homeController)
        homeNav.title = "Home"
        homeNav.tabBarItem.image = UIImage(named: "home-icon")
        homeNav.navigationBar.barTintColor = UIColor.white
        homeNav.navigationBar.isTranslucent = false
//        homeNav.isNavigationBarHidden = true
        
//        let cartController = CartViewController()
//        let cartNav = UINavigationController(rootViewController: cartController)
//        cartNav.title = "Cart"
//        cartNav.tabBarItem.image = UIImage(named: "cart-icon")
        
//        let vc = FriendRequestsController()
//        let nav = UINavigationController(rootViewController: vc)
//        nav.title = "temp"
        
        let designerController = DesignersController()
        let navDesignerController = UINavigationController(rootViewController: designerController)
        navDesignerController.title = "Designers"
        navDesignerController.tabBarItem.image = UIImage(named: "people")
        
        let categoriesController = CategoriesController()
        let navCategoriesController = UINavigationController(rootViewController: categoriesController)
        navCategoriesController.title = "Categories"
        navCategoriesController.tabBarItem.image = UIImage(named: "hanger")
        
        let userInfoController = UserInfoController()
        let userInfoNavController = UINavigationController(rootViewController: userInfoController)
        userInfoNavController.title = "More"
        userInfoNavController.tabBarItem.image = UIImage(named: "more")
        
        viewControllers = [homeNav, navDesignerController, navCategoriesController, userInfoNavController]
        self.tabBar.isTranslucent = false
        UITabBar.appearance().tintColor = UIColor.black
    }
    


}
