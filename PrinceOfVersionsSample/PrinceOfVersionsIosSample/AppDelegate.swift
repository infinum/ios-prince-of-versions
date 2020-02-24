//
//  AppDelegate.swift
//  PrinceOfVersionsSample
//
//  Created by Jasmin Abou Aldan on 13/09/2019.
//  Copyright © 2019 infinum. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.

        // Uncomment version that you want to build:
        createAndShowViewController(with: "SwiftAppSample")
//         createAndShowViewController(with: "ObjCAppSample")

        return true
    }
}

private extension AppDelegate {

    func createAndShowViewController(with identifier: String) {
        let viewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: identifier)
        window?.rootViewController = viewController
        window?.makeKeyAndVisible()
    }
}
