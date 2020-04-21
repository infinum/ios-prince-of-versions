//
//  AppDelegate.swift
//  PrinceOfVersionsMacSample
//
//  Created by Jasmin Abou Aldan on 20/09/2019.
//  Copyright © 2019 infinum. All rights reserved.
//

import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {

    func applicationDidFinishLaunching(_ aNotification: Notification) {
        // Insert code here to initialize your application

//         Uncomment version that you want to build:
        createAndShowViewController(with: "SwiftAppSample")
//        createAndShowViewController(with: "ObjCAppSample")
    }
}

private extension AppDelegate {

    func createAndShowViewController(with identifier: String) {
        let viewController = NSStoryboard(name: "Main", bundle: nil).instantiateController(withIdentifier: identifier) as! NSViewController
        NSApplication.shared.mainWindow?.contentViewController = viewController
    }
}
