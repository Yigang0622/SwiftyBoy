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
        
    let mb = Motherboard()
    
    var fpsTimer: DispatchSourceTimer!
    var queue: DispatchQueue!
    var frameCount = 0
    
    let scale = 1
    let imageView = UIImageView(frame: CGRect(x: 0, y: 100, width: 160 * 4, height: 144 * 4))
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
    
        let fpsLabel = UILabel(frame: CGRect(x: 0, y: 60, width: 100, height: 50))
        fpsLabel.backgroundColor = .black
        fpsLabel.textColor = .red
        fpsLabel.font = UIFont.systemFont(ofSize: 30, weight: .bold)
        self.view.addSubview(fpsLabel)
        
        queue = DispatchQueue(label: "fpsQueue")
        fpsTimer = DispatchSource.makeTimerSource(flags: .strict, queue: queue)
        
        fpsTimer.setEventHandler {
            let fps = self.frameCount
            self.frameCount = 0
            DispatchQueue.main.async {
                fpsLabel.text = "\(fps)"
            }
            
        }
        
        self.fpsTimer.schedule(deadline: .now(), repeating: .seconds(1), leeway: .milliseconds(10))
        self.fpsTimer.resume()
        
      
        view.addSubview(imageView)
        
        let viewPortImageView = UIImageView(frame: CGRect(x: 10, y: 400, width: 160 * 3, height: 144 * 3))
        view.addSubview(viewPortImageView)
        
        mb.gpu.onViewPortUpdate = { pixels in
            self.frameCount += 1
            DispatchQueue.main.async {
                var pixels = pixels
                let w = 160
                let h = 144
                let rgbColorSpace = CGColorSpace(name: CGColorSpace.sRGB)!
                let bitmapInfo = CGBitmapInfo(rawValue: CGImageAlphaInfo.premultipliedFirst.rawValue)
                let bitsPerComponent = 8
                let bitsPerPixel = 32

                let providerRef = CGDataProvider(data: NSData(bytes: &pixels, length: pixels.count * 4))

                let cgim = CGImage(
                   width: w,
                   height: h,
                   bitsPerComponent: bitsPerComponent,
                   bitsPerPixel: bitsPerPixel,
                   bytesPerRow: w * 4,
                   space: rgbColorSpace,
                   bitmapInfo: bitmapInfo,
                   provider: providerRef!,
                   decode: nil,
                   shouldInterpolate: true,
                   intent: .defaultIntent
                   )
                
                if let cgImage = cgim {
                    viewPortImageView.image =  UIImage(cgImage: cgImage, scale: 1, orientation: .up)
                }
                
            }
            
        }
        
        
        mb.gpu.onFrameUpdateV2 = { pixels in
            
            DispatchQueue.main.async { [self] in
                var pixels = pixels
                let w = 256
                let h = 256
                //           var pixels = Array<UInt32>(repeating: 0xAAAAAAff, count: 100 * 100)

                let rgbColorSpace = CGColorSpace(name: CGColorSpace.sRGB)!
                let bitmapInfo = CGBitmapInfo(rawValue: CGImageAlphaInfo.premultipliedFirst.rawValue)
                let bitsPerComponent = 8
                let bitsPerPixel = 32

                let providerRef = CGDataProvider(data: NSData(bytes: &pixels, length: pixels.count * 4))

                let cgim = CGImage(
                   width: w,
                   height: h,
                   bitsPerComponent: bitsPerComponent,
                   bitsPerPixel: bitsPerPixel,
                   bytesPerRow: w * 4,
                   space: rgbColorSpace,
                   bitmapInfo: bitmapInfo,
                   provider: providerRef!,
                   decode: nil,
                   shouldInterpolate: true,
                   intent: .defaultIntent
                   )
                
                if let cgImage = cgim {
                    imageView.image =  UIImage(cgImage: cgImage, scale: 2, orientation: .up)
                }
                
            }
        }
                
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
    
    func gameBoyDidDrawNewFrame(frame: UIImage) {
        
        imageView.image = frame
    }
    
}

extension Array {
    func chunked(into size: Int) -> [[Element]] {
        return stride(from: 0, to: count, by: size).map {
            Array(self[$0 ..< Swift.min($0 + size, count)])
        }
    }

}


