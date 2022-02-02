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
        
    
    let scale = 1
    let imageView = UIImageView(frame: CGRect(x: 0, y: 100, width: 160 * 4, height: 144 * 4))
    let fpsLabel = UILabel(frame: CGRect(x: 0, y: 50, width: 100, height: 50))
    var gameboy = GameBoy()
    
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
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    
        let types = UTType.types(tag: "gb", tagClass: UTTagClass.filenameExtension, conformingTo: nil)
        let documentPickerController = UIDocumentBrowserViewController(forOpening: types)
        documentPickerController.delegate = self
        self.present(documentPickerController, animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        gameboy.delegate = self
    
        fpsLabel.backgroundColor = .black
        fpsLabel.textColor = .red
        fpsLabel.font = UIFont.systemFont(ofSize: 30, weight: .bold)
        self.view.addSubview(fpsLabel)
        
      
      
        view.addSubview(imageView)
        
        let viewPortImageView = UIImageView(frame: CGRect(x: 10, y: 400, width: 160 * 3, height: 144 * 3))
        view.addSubview(viewPortImageView)
        
                
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
        FPSMetric.shared.startMoinitoring()
        FPSMetric.shared.delegate = self
    }
    
    func gameBoyDidDrawNewFrame(frame: UIImage) {
        FPSMetric.shared.increaseCounter()
        imageView.image = frame
    }
    
}

extension ViewController: FPSMetricDelegate {
    
    func fpsMetricDidUpdateFps(fps: Int) {
        fpsLabel.text = "\(FPSMetric.shared.fps)"
    }
    
}

extension Array {
    func chunked(into size: Int) -> [[Element]] {
        return stride(from: 0, to: count, by: size).map {
            Array(self[$0 ..< Swift.min($0 + size, count)])
        }
    }

}


