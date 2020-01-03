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
        let name = "Darren studded textured-leather shoulder bag"
        let designer = "REBECCA MINKOFF"
        let price: Double = 1000
        let discount: Double = 15
        let category = "bag"
        
        let detail = """
                Shoulder bag
                Pebbled-leather
                Silver hardware
                Detachable adjustable shoulder strap
                Twist lock-fastening tab at top
                Magnetic snap fastening at top
                Two internal compartments
                Internal zip pocket
                Back external compartment
                This bag will fit your essentials, plus a tablet
                Imported
                """
        let sizeAndFit = """
            This bag will fit your essentials, plus a tablet
            Minimum strap length - 72cm / 28.3in
            Maximum strap length - 86cm / 33.9in
            Height - 28cm / 11in
            Width - 26cm / 10.2in
            Depth - 11.5cm / 4.5in
            """
        let url = [
            "https://firebasestorage.googleapis.com/v0/b/shopapp-96ec7.appspot.com/o/product-image-name%2F10%2F10-0.jpg?alt=media&token=179a190c-2a1b-429d-964e-9fb27834f0c4",
            "https://firebasestorage.googleapis.com/v0/b/shopapp-96ec7.appspot.com/o/product-image-name%2F10%2F10-1.jpg?alt=media&token=17261598-9e5d-4dc0-a11b-5c61e11e8e10",
            "https://firebasestorage.googleapis.com/v0/b/shopapp-96ec7.appspot.com/o/product-image-name%2F10%2F10-2.jpg?alt=media&token=abf2c08a-1e37-47f4-a7fa-a12193ddedc5",
            "https://firebasestorage.googleapis.com/v0/b/shopapp-96ec7.appspot.com/o/product-image-name%2F10%2F10-3.jpg?alt=media&token=4da0513c-8714-4d38-958e-468ddd21b319",
            "https://firebasestorage.googleapis.com/v0/b/shopapp-96ec7.appspot.com/o/product-image-name%2F10%2F10-4.jpg?alt=media&token=e7195f73-2a06-4e3b-91e5-4fdb9418e571"
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
            key.hexColors: [Product.HexColorText.pink],
//            key.sizes: ["UK 3.5", "UK 4", "UK 4.5", "UK 5", "UK 5.5", "UK 6", "UK 6.5", "UK 7"],
            key.detail: detail,
            key.sizeAndFit: sizeAndFit,
            key.composition: ["Leather 100%"],
            key.textColors: [Product.ColorText.pink],
            key.quantity: 20,
            key.category: category,
            "\(key.imageUrls)0": url,
//            "\(key.imageUrls)1": url2
        ]
        
//        let databaseRef = Database.database().reference()
//        databaseRef.child("product").childByAutoId().updateChildValues(dictionary, withCompletionBlock: { (error, ref) in
//            if let error = error {
//                print(error)
//            }
//        })
        print("valid phone")
        print("0123456789".isValidPhoneNumber())
        print("01234567891".isValidPhoneNumber())
        print("012345678910".isValidPhoneNumber())
        print("0123456789101".isValidPhoneNumber())
        print("012345678".isValidPhoneNumber())
        print("0123s45678".isValidPhoneNumber())
        print("dfjaslkdjfl;".isValidPhoneNumber())

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

