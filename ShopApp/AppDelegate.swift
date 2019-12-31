//
//  AppDelegate.swift
//  ShopApp
//
//  Created by Nguyễn Đức Huy on 7/16/19.
//  Copyright © 2019 Nguyễn Đức Huy. All rights reserved.
//

import UIKit
import Firebase

//var customer: Customer! = Customer(id: "jkl", firstName: "Huy", lastName: "Nguyen", email: "testmail@mail.com")
var customer: Customer = Customer(id: nil, firstname: nil, lastname: nil, email: nil)

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        FirebaseApp.configure()
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.makeKeyAndVisible()
        
        
        let tabController = TabController()
//        tabController.navigationController.is
//        let viewController = ProductDetailController(productId: "-LnSlvkbBc3agYof2M7g")
        
//        let navi = UINavigationController(rootViewController: tabController)
//        navi.isNavigationBarHidden = true
        window?.rootViewController = tabController
        
        let navBarItem = UIBarButtonItem.appearance()
        navBarItem.tintColor = UIColor.black
        
        let navBar = UINavigationBar.appearance()
        navBar.isTranslucent = false
        
        if let statusBar = UIApplication.shared.value(forKeyPath: "statusBarWindow.statusBar") as? UIView {
            statusBar.backgroundColor = UIColor.white
        }

//        gs://shopapp-96ec7.appspot.com/product-image-name/3/3-0.jpg
        
        typealias key = Product.InfoKey
        let name = "Leather-trimmed suede ankle boots"
        let designer = "3.1 PHILLIP LIM"
        let price: Double = 289
        let discount: Double = 25
        
        let detail = """
                Ankle boots
                Suede
                Lined in shearling
                Quilted trims
                Leather trims
                Lace-up front
                Rubber sole
                Round toe
                Imported
                """
//        let sizeAndFit = """
//        Fits true to size, take your normal size
//        """
        let url = [
            "https://firebasestorage.googleapis.com/v0/b/shopapp-96ec7.appspot.com/o/product-image-name%2F7%2F7-0.jpg?alt=media&token=bad72299-e937-4d3d-8bd6-54d1813b4d5a",
            "https://firebasestorage.googleapis.com/v0/b/shopapp-96ec7.appspot.com/o/product-image-name%2F7%2F7-1.jpg?alt=media&token=b3eeadbd-304f-4d4a-abac-9f9aa62b1fec",
            "https://firebasestorage.googleapis.com/v0/b/shopapp-96ec7.appspot.com/o/product-image-name%2F7%2F7-2.jpg?alt=media&token=7113b5c3-fad0-4653-8474-828aa323b7cf",
            "https://firebasestorage.googleapis.com/v0/b/shopapp-96ec7.appspot.com/o/product-image-name%2F7%2F7-3.jpg?alt=media&token=aa8e2923-c550-43a3-adb5-691203d1ce4f"
        ]
//        let url2 = [
//            "https://firebasestorage.googleapis.com/v0/b/shopapp-96ec7.appspot.com/o/product-image-name%2F2%2F11731889rt_13_d.jpg?alt=media&token=4cce138c-368a-44f8-8b1c-e9c86a4320c2",
//            "https://firebasestorage.googleapis.com/v0/b/shopapp-96ec7.appspot.com/o/product-image-name%2F2%2F11731889rt_13_e.jpg?alt=media&token=935a3246-8f01-4db1-a51e-4717b0ec6a0d",
//            "https://firebasestorage.googleapis.com/v0/b/shopapp-96ec7.appspot.com/o/product-image-name%2F2%2F11731889rt_13_f.jpg?alt=media&token=ea608c54-b587-4e9e-b2ef-0f3cbefbe83a",
//            "https://firebasestorage.googleapis.com/v0/b/shopapp-96ec7.appspot.com/o/product-image-name%2F2%2F11731889rt_13_r.jpg?alt=media&token=8a8d0ba7-c3af-45ea-b67c-e8af86e1d18f"
//        ]

        let dictionary: [String: Any] = [
            key.name: name,
            "nameSearch": name.lowercased(),
            key.designer: designer,
            "designerSearch": designer.lowercased(),
            key.price: price,
//            key.discountPrice: 61,
            key.discount: discount,
            key.status: "just in",
            key.hexColors: [Product.HexColorText.sand],
            key.sizes: ["UK 3.5", "UK 4", "UK 4.5", "UK 5", "UK 5.5", "UK 6", "UK 6.5", "UK 7"],
            key.detail: detail,
//            key.sizeAndFit: sizeAndFit,
            key.composition: ["Lambskin", "Leather"],
            key.textColors: [Product.ColorText.sand],
            key.quantity: 20,
            key.category: "shoes",
            "\(key.imageUrls)0": url,
//            "\(key.imageUrls)1": url2
        ]
        
//        let databaseRef = Database.database().reference()
//        databaseRef.child("product").childByAutoId().updateChildValues(dictionary, withCompletionBlock: { (error, ref) in
//            if let error = error {
//                print(error)
//            }
//        })
        

        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

