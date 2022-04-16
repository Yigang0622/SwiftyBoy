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
            WindowUtil.setNormalWindowSize()
            
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
        
        let loadCartCommand = UIKeyCommand(input: "o", modifierFlags: [.command], action: #selector(ViewController.showLoadCartridgeDialog))
        loadCartCommand.title = "Load Cartriage"
        
        let toggleDevModeCommand =  UIKeyCommand(input: "d", modifierFlags: [.command], action: #selector(ViewController.toggleDevMode))
        toggleDevModeCommand.title = "Dev Mode"
        
        let menu = UIMenu(title: "Load Cartriage", image: nil, identifier: UIMenu.Identifier("loadCart"), options: .displayInline, children: [loadCartCommand, toggleDevModeCommand])
        builder.insertChild(menu, atStartOfMenu: .file)
    }
   



}

