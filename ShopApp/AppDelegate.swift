//
//  AppDelegate.swift
//  ShopApp
//
//  Created by Nguyễn Đức Huy on 7/16/19.
//  Copyright © 2019 Nguyễn Đức Huy. All rights reserved.
//

import UIKit
import Firebase

var customer = Customer(firstName: "Huy", lastName: "Nguyen")

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
        
//        typealias key = Product.InfoKey
//        let detail = """
//                Low-top sneakers
//                Designer logo
//                Canvas
//                Jacquard
//                Leather trims
//                Silver designer plaque
//                Lace-up front
//                Fully lined
//                Rubber sole
//                Imported
//                """
//        let url = [
//            "https://firebasestorage.googleapis.com/v0/b/shopapp-96ec7.appspot.com/o/product-image-name%2F2%2F11731884cs_13_d.jpg?alt=media&token=57ac62a7-312f-4e48-ad36-3664ee6211b2",
//            "https://firebasestorage.googleapis.com/v0/b/shopapp-96ec7.appspot.com/o/product-image-name%2F2%2F11731884cs_13_e.jpg?alt=media&token=dda9c23a-5620-4d57-995f-4e8ecbaa362d",
//            "https://firebasestorage.googleapis.com/v0/b/shopapp-96ec7.appspot.com/o/product-image-name%2F2%2F11731884cs_13_f.jpg?alt=media&token=040c077d-8383-4f6c-ac8d-ed0a9bc51fe4",
//            "https://firebasestorage.googleapis.com/v0/b/shopapp-96ec7.appspot.com/o/product-image-name%2F2%2F11731884cs_13_r.jpg?alt=media&token=e8b362c6-ae1f-4de5-8f67-052c9eac3d97"
//        ]
//        let url2 = [
//            "https://firebasestorage.googleapis.com/v0/b/shopapp-96ec7.appspot.com/o/product-image-name%2F2%2F11731889rt_13_d.jpg?alt=media&token=4cce138c-368a-44f8-8b1c-e9c86a4320c2",
//            "https://firebasestorage.googleapis.com/v0/b/shopapp-96ec7.appspot.com/o/product-image-name%2F2%2F11731889rt_13_e.jpg?alt=media&token=935a3246-8f01-4db1-a51e-4717b0ec6a0d",
//            "https://firebasestorage.googleapis.com/v0/b/shopapp-96ec7.appspot.com/o/product-image-name%2F2%2F11731889rt_13_f.jpg?alt=media&token=ea608c54-b587-4e9e-b2ef-0f3cbefbe83a",
//            "https://firebasestorage.googleapis.com/v0/b/shopapp-96ec7.appspot.com/o/product-image-name%2F2%2F11731889rt_13_r.jpg?alt=media&token=8a8d0ba7-c3af-45ea-b67c-e8af86e1d18f"
//        ]
//
//        let dictionary: [String: Any] = [
//            key.name: "Abel woven and textured-leather slip-on sneakers",
//            key.designer: "DKNY",
//            key.discountPrice: 61,
//            key.discount: 40,
//            key.status: "low stock",
//            key.hexColors: [Product.HexColor.black, Product.HexColor.brown],
//            key.sizes: ["UK 3.5", "UK 4", "UK 4.5", "UK 5", "UK 5.5", "UK 6", "UK 6.5", "UK 7"],
//            key.detail: detail,
//            key.composition: ["textile fibers", "leather"],
//            key.textColors: [Product.TextColor.black, Product.TextColor.brown],
//            key.imageUrls: url,
//            "\(key.imageUrls)1": url2
//        ]
//        let databaseRef = Database.database().reference()
//        databaseRef.child("product").childByAutoId().updateChildValues(dictionary, withCompletionBlock: { (error, ref) in
//            if let error = error {
//                print(error)
//            }
//        })
        
//        typealias key = Product.InfoKey
//                let detail = """
//                Cross-body bag
//                Pebbled-leather
//                Internal zipped compartment
//                Internal card slots
//                Quilted
//                Suede effect
//                Gunmetal hardware
//                Studded
//                Detachable chain-trimmed shoulder strap
//                Top handle
//                Twist lock-fastening front flap
//                External compartment
//                Fully lined in jacquard
//                This bag will fit a wallet, keys and standard phone
//                Imported
//                """
//        let sizeAndFit = """
//        This bag will fit a wallet, keys and standard phone
//        Handle drop - 4cm / 1.6in
//        Maximum strap length - 115cm / 45.3in
//        Height - 17.5cm / 6.9in
//        Width - 25cm / 9.8in
//        Depth - 5cm / 2in
//        """
//                let url = [
//                "https://firebasestorage.googleapis.com/v0/b/shopapp-96ec7.appspot.com/o/product-image-name%2F3%2F3-0.jpg?alt=media&token=6d5abe9d-8df8-4dce-a09c-05123ca0b024",
//                "https://firebasestorage.googleapis.com/v0/b/shopapp-96ec7.appspot.com/o/product-image-name%2F3%2F3-1.jpg?alt=media&token=a4439a06-04f8-4eed-b1e6-5dab6509ddab",
//                "https://firebasestorage.googleapis.com/v0/b/shopapp-96ec7.appspot.com/o/product-image-name%2F3%2F3-2.jpg?alt=media&token=5645cd34-6fb6-443e-ba8c-29745eeede58",
//                "https://firebasestorage.googleapis.com/v0/b/shopapp-96ec7.appspot.com/o/product-image-name%2F3%2F3-3.jpg?alt=media&token=31a5a56c-849d-489e-b207-ac9e11841b69",
//                
//                    "https://firebasestorage.googleapis.com/v0/b/shopapp-96ec7.appspot.com/o/product-image-name%2F3%2F3-4.jpg?alt=media&token=b65cbe6f-5ea5-42ef-ac1e-f102cbd5259f"
//                ]
////        let url2 = [
////            "https://firebasestorage.googleapis.com/v0/b/shopapp-96ec7.appspot.com/o/product-image-name%2F2%2F11731889rt_13_d.jpg?alt=media&token=4cce138c-368a-44f8-8b1c-e9c86a4320c2",
////            "https://firebasestorage.googleapis.com/v0/b/shopapp-96ec7.appspot.com/o/product-image-name%2F2%2F11731889rt_13_e.jpg?alt=media&token=935a3246-8f01-4db1-a51e-4717b0ec6a0d",
////            "https://firebasestorage.googleapis.com/v0/b/shopapp-96ec7.appspot.com/o/product-image-name%2F2%2F11731889rt_13_f.jpg?alt=media&token=ea608c54-b587-4e9e-b2ef-0f3cbefbe83a",
////            "https://firebasestorage.googleapis.com/v0/b/shopapp-96ec7.appspot.com/o/product-image-name%2F2%2F11731889rt_13_r.jpg?alt=media&token=8a8d0ba7-c3af-45ea-b67c-e8af86e1d18f"
////        ]
//
//                let dictionary: [String: Any] = [
//                    key.name: "Studded quilted textured suede-effect leather shoulder bag",
//                    key.designer: "REBECCA MINKOFF",
////                    key.discountPrice: 210,
//                    key.price: 420,
//                    key.discount: 50,
//                    key.status: "just in",
////                    key.hexColors: [Product.HexColorText.black],
////                    key.sizes: ["UK 3.5", "UK 4", "UK 4.5", "UK 5", "UK 5.5", "UK 6", "UK 6.5", "UK 7"],
//                    key.detail: detail,
//                    key.sizeAndFit: sizeAndFit,
//                    key.quantity: 20,
//                    key.composition: ["Bovine leather 100%"],
//                    key.textColors: ["sky blue"],
//                    "\(key.imageUrls)0": url,
////                    "\(key.imageUrls)1": url2
//                    ]
//        let databaseRef = Database.database().reference()
//                databaseRef.child("product").childByAutoId().updateChildValues(dictionary, withCompletionBlock: { (error, ref) in
//                    if let error = error {
//                        print(error)
//                    }
//                })

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

