//
//  AppDelegate.swift
//  SwiftyBoy
//
//  Created by Yigang Zhou on 2021/11/25.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {



    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        let scale = 3
        UIApplication.shared.connectedScenes.compactMap { $0 as? UIWindowScene }.forEach { windowScene in
            windowScene.sizeRestrictions?.minimumSize = CGSize(width: 160 * scale, height:  144 * scale)
            windowScene.sizeRestrictions?.maximumSize = CGSize(width: 160 * scale, height:  144 * scale)
        }
        
        return true
    }
    
    override func buildMenu(with builder: UIMenuBuilder) {
        super.buildMenu(with: builder)
        builder.remove(menu: .font)
        builder.remove(menu: .format)
        builder.remove(menu: .services)
        
        let refreshCommand = UIKeyCommand(input: "o", modifierFlags: [.command], action: #selector(ViewController.showLoadCartridgeDialog))
         refreshCommand.title = "Load Cartriage"
         let reloadDataMenu = UIMenu(title: "Load Cartriage", image: nil, identifier: UIMenu.Identifier("loadCart"), options: .displayInline, children: [refreshCommand])
        builder.insertChild(reloadDataMenu, atStartOfMenu: .file)
    }
   

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }


}

