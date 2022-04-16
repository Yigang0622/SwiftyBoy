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
        mb.gpu.onFrameDrawn = { frame in
            DispatchQueue.main.async { [self] in
                delegate?.gameBoyDidDrawNewFrame(frame: frame.toImage())
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
        mb.reset()
        if let cart = CartageLoader.loadCartridge(url: url) {
            mb.cart = cart
            delegate?.gameBoyCartridgeDidLoad(cart: cart)
            DispatchQueue.global().async {
                self.mb.run()
            }
        }
    }
    
    func loadBootRom(url: URL) {
        if let bootrom = BootRomLoader.loadBootRom(url: url) {
            print("set bootrom success")
            mb.bootRom = bootrom
        }
    }
    
    func setBoostMode(enable: Bool) {
        mb.setFpsRestriction(enable: !enable)
    }
    
}

@objc protocol GameBoyDelegate {

    func gameBoyCartridgeDidLoad(cart: Cartridge)
    
    func gameBoyDidDrawNewFrame(frame: UIImage)
    
}
