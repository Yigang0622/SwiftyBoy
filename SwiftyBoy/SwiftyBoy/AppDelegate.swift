//
//  AppDelegate.swift
//  SwiftyBoy
//
//  Created by Yigang Zhou on 2021/11/25.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {


    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        
        window = UIWindow(frame: UIScreen.main.bounds)
        if let window = window {
            window.backgroundColor = UIColor.white
            #if targetEnvironment(macCatalyst)
            window.rootViewController = ViewController()
            let scale = 4
            UIApplication.shared.connectedScenes.compactMap { $0 as? UIWindowScene }.forEach { windowScene in
                windowScene.sizeRestrictions?.minimumSize = CGSize(width: 160 * scale, height:  144 * scale + 40)
                windowScene.sizeRestrictions?.maximumSize = CGSize(width: 160 * scale, height:  144 * scale + 40)
            }
            
            #else
            window.rootViewController = MainViewController()
            
            #endif            
            window.makeKeyAndVisible()
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
   



}

