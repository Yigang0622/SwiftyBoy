//
//  VirtualJoyPadInteractiveZone.swift
//  SwiftyBoy
//
//  Created by Yigang Zhou on 2022/2/12.
//

import UIKit

class VirtualJoyPadInteractiveZone: UIImageView {
    
    var delegate: VirtualJoyPadInteractiveZoneDelegate?
    var buttonType: JoypadButtonType?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .blue
        self.isUserInteractionEnabled = true
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let type = buttonType {
            delegate?.onKeyPress(button: type)
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let type = buttonType {
            delegate?.onKeyRelease(button: type)
        }
    }

   
    
}

protocol VirtualJoyPadInteractiveZoneDelegate {
    
    func onKeyPress(button: JoypadButtonType)
    func onKeyRelease(button: JoypadButtonType)
    
}
