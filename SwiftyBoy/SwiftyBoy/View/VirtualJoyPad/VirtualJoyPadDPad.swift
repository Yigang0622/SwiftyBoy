//
//  VirtualJoyPadDPad.swift
//  SwiftyBoy
//
//  Created by Yigang Zhou on 2022/2/13.
//

import UIKit

class VirtualJoyPadDPad: VirtualJoyPadInteractiveZone {

    // up down left right
    private var directionPointes = [CGPoint(x: 0, y: 0), CGPoint(x: 0, y: 0), CGPoint(x: 0, y: 0), CGPoint(x: 0, y: 0)]
    
    var pressedButton: JoypadButtonType!
    
    override func layoutSubviews() {
        super.layoutSubviews()
        let halfW = self.frame.width / 2
        let halfH = self.frame.height / 2
        directionPointes = [CGPoint(x: 0, y: halfH),
                            CGPoint(x: 0, y: -halfH),
                            CGPoint(x: -halfW, y: 0),
                            CGPoint(x: halfW, y: 0)]
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first {
            let loc = touch.location(in: self)
            let x = loc.x - self.center.x
            let y = loc.y - self.center.y
            handlePress(x: x, y: y)
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first {
            let loc = touch.location(in: self)
            let x = loc.x - self.center.x
            let y = loc.y - self.center.y
            handlePress(x: x, y: y)
        }
    }
    
    
    
    func handlePress(x: CGFloat, y: CGFloat) {
        var result: JoypadButtonType = .up
        var tempMax: CGFloat = -1
        for (i, p) in directionPointes.enumerated() {
            let distance = sqrt( (p.y - y) * (p.y - y) + (p.x - x) * (p.x - x) )
            if distance > tempMax {
                tempMax = distance
                result = [.up, .down, .right, .left][i]
            }
        }
        
        // release first
        if let press = pressedButton {
            if press.rawValue != result.rawValue {
                delegate?.onKeyRelease(button: press)
                delegate?.onKeyPress(button: result)
                pressedButton = result
            }
        } else {
            delegate?.onKeyPress(button: result)
            pressedButton = result
        }
        
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let press = pressedButton {
            delegate?.onKeyRelease(button: press)
        }
        pressedButton = nil
    }
    
}
