//
//  GameBoy.swift
//  SwiftyBoy
//
//  Created by Yigang on 2022/2/1.
//

import Foundation
import UIKit

class GameBoy {
    
    let mb = Motherboard()
    var delegate: GameBoyDelegate?
    
    init() {
        mb.gpu.onFrameDrawn = { pixels in
            
            DispatchQueue.main.async { [self] in
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
                    delegate?.gameBoyDidDrawNewFrame(frame: UIImage(cgImage: cgImage, scale: 1, orientation: .up))
                }
                
            }
            
        }
    }
    
    func pressButton(button: JoypadButtonType) {
        mb.joypad.pressButton(type: button)
    }
    
    func releaseButton(button: JoypadButtonType) {
        mb.joypad.releaseButton(type: button)
    }
    
    func loadCartridge(url: URL) {
        if let cart = CartageLoader.loadCartridge(url: url) {
            mb.cart = cart            
            DispatchQueue.global().async {
                self.mb.run()
            }
        }
    }
    
    func setBoostMode(enable: Bool) {
        mb.setFpsRestriction(enable: !enable)
    }
    
    
}

protocol GameBoyDelegate {
    
    func gameBoyDidDrawNewFrame(frame: UIImage)
    
}
