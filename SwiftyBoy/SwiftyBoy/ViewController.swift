//
//  ViewController.swift
//  SwiftyBoy
//
//  Created by Yigang Zhou on 2021/11/25.
//

import UIKit
import Foundation
import MobileCoreServices
import UniformTypeIdentifiers

class ViewController: UIViewController {
        
    var gameboy = GameBoy()
    var gameboyLcd: GameBoyLCDView!
    var mainMenu: MainMenuView!
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        gameboy.delegate = self
        self.view.backgroundColor = .white
        
        gameboyLcd = GameBoyLCDView()
        self.view.addSubview(gameboyLcd)
        gameboyLcd.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            gameboyLcd.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor),
            gameboyLcd.bottomAnchor.constraint(equalTo: view.layoutMarginsGuide.bottomAnchor),
            gameboyLcd.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            gameboyLcd.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
        
//        FPSMetric.shared.bind(gameboyDelegate: self)
    
        mainMenu = MainMenuView()
        self.view.addSubview(mainMenu)
        mainMenu.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            mainMenu.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor),
            mainMenu.bottomAnchor.constraint(equalTo: view.layoutMarginsGuide.bottomAnchor),
            mainMenu.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            mainMenu.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
        mainMenu.loadCartridgeButton.addTarget(self, action: #selector(self.showLoadCartridgeDialog), for: .touchUpInside)
        
    }
    
    
    
    
    override func pressesBegan(_ presses: Set<UIPress>, with event: UIPressesEvent?) {
                
        presses.forEach { press in
            if let key = press.key {
                if(key.keyCode == .keyboardW) {
                    gameboy.pressButton(button: .up)
                } else if (key.keyCode == .keyboardA) {
                    gameboy.pressButton(button: .left)
                } else if (key.keyCode == .keyboardS) {
                    gameboy.pressButton(button: .down)
                } else if (key.keyCode == .keyboardD) {
                    gameboy.pressButton(button: .right)
                } else if (key.keyCode == .keyboardJ) {
                    gameboy.pressButton(button: .a)
                } else if (key.keyCode == .keyboardK) {
                    gameboy.pressButton(button: .b)
                } else if (key.keyCode == .keyboardN) {
                    gameboy.pressButton(button: .select)
                } else if (key.keyCode == .keyboardM) {
                    gameboy.pressButton(button: .start)
                } else if (key.keyCode == .keyboardSpacebar) {
                    gameboy.setBoostMode(enable: true)
                }
            }
        }
        
    }
    
    override func pressesEnded(_ presses: Set<UIPress>, with event: UIPressesEvent?) {
        presses.forEach { press in
            if let key = press.key {
                if(key.keyCode == .keyboardW) {
                    gameboy.releaseButton(button: .up)
                } else if (key.keyCode == .keyboardA) {
                    gameboy.releaseButton(button: .left)
                } else if (key.keyCode == .keyboardS) {
                    gameboy.releaseButton(button: .down)
                } else if (key.keyCode == .keyboardD) {
                    gameboy.releaseButton(button: .right)
                } else if (key.keyCode == .keyboardJ) {
                    gameboy.releaseButton(button: .a)
                } else if (key.keyCode == .keyboardK) {
                    gameboy.releaseButton(button: .b)
                } else if (key.keyCode == .keyboardN) {
                    gameboy.releaseButton(button: .select)
                } else if (key.keyCode == .keyboardM) {
                    gameboy.releaseButton(button: .start)
                }else if (key.keyCode == .keyboardSpacebar) {
                    gameboy.setBoostMode(enable: false)
                }
            }
        }
    }
    
 

}

extension ViewController: UIContextMenuInteractionDelegate {
    
    @objc func showLoadCartridgeDialog() {
        let types = UTType.types(tag: "gb", tagClass: UTTagClass.filenameExtension, conformingTo: nil)
        
        let documentPickerController = UIDocumentBrowserViewController(forOpening: types)
        documentPickerController.delegate = self
        self.present(documentPickerController, animated: true, completion: nil)
    }
    
    func contextMenuInteraction(_ interaction: UIContextMenuInteraction, configurationForMenuAtLocation location: CGPoint) -> UIContextMenuConfiguration? {
        let loadAction = UIAction(title: "111", image: nil, identifier: nil, discoverabilityTitle: "", attributes: [], state: .on) { action in
            
        }        
        
        let config = UIContextMenuConfiguration(identifier: nil, previewProvider: nil) { elements in
            return UIMenu(title: "menu", subtitle: nil, image: nil, identifier: nil, options: [], children: [loadAction])
        }
        
        return config
        
    }
    
}

extension ViewController: UIDocumentBrowserViewControllerDelegate {
    
    func documentBrowser(_ controller: UIDocumentBrowserViewController, didPickDocumentsAt documentURLs: [URL]) {
        if let url = documentURLs.first {
            gameboy.loadCartridge(url: url)
            
        }
        
    }
    
}

extension ViewController: GameBoyDelegate {
    
    func gameBoyCartridgeDidLoad(cart: Cartridge) {
        self.view.bringSubviewToFront(self.gameboyLcd)
        print("gameBoyCartridgeDidLoad")
        FPSMetric.shared.startMoinitoring()
        FPSMetric.shared.delegate = self
    }
    
    func gameBoyDidDrawNewFrame(frame: UIImage) {
        FPSMetric.shared.increaseCounter()
        gameboyLcd.setFrame(frame: frame)
    }
    
}

extension ViewController: FPSMetricDelegate {
    
    func fpsMetricDidUpdateFps(fps: Int) {
        gameboyLcd.setFpsText(fps: fps)
    }
    
}

