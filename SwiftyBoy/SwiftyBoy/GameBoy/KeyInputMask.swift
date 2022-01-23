//
//  Screen.swift
//  SwiftyBoy
//
//  Created by Yigang Zhou on 2022/1/23.
//

import Foundation
import UIKit

class KeyInputMask: UIImageView {
        
    override var canBecomeFirstResponder: Bool { return true }
    override var canResignFirstResponder: Bool { return true }
    
    var onKeyPress: ((_ type: JoypadButtonType) -> Void)?
    var onKeyRelease: ((_ type: JoypadButtonType) -> Void)?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.alpha = 0
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.alpha = 0
    }
    
    override func pressesBegan(_ presses: Set<UIPress>, with event: UIPressesEvent?) {
        super.pressesBegan(presses, with: event)
        presses.forEach { press in
            if let key = press.key {
                if(key.keyCode == .keyboardW) {
                    onKeyPress?(.up)
                } else if (key.keyCode == .keyboardA) {
                    onKeyPress?(.left)
                } else if (key.keyCode == .keyboardS) {
                    onKeyPress?(.down)
                } else if (key.keyCode == .keyboardD) {
                    onKeyPress?(.right)
                } else if (key.keyCode == .keyboardJ) {
                    onKeyPress?(.a)
                } else if (key.keyCode == .keyboardK) {
                    onKeyPress?(.b)
                } else if (key.keyCode == .keyboardN) {
                    onKeyPress?(.select)
                } else if (key.keyCode == .keyboardM) {
                    onKeyPress?(.start)
                }
            }
        }
        
    }
    
    override func pressesEnded(_ presses: Set<UIPress>, with event: UIPressesEvent?) {
        super.pressesEnded(presses, with: event)
        presses.forEach { press in
            if let key = press.key {
                if(key.keyCode == .keyboardW) {
                    onKeyRelease?(.up)
                } else if (key.keyCode == .keyboardA) {
                    onKeyRelease?(.left)
                } else if (key.keyCode == .keyboardS) {
                    onKeyRelease?(.down)
                } else if (key.keyCode == .keyboardD) {
                    onKeyRelease?(.right)
                } else if (key.keyCode == .keyboardJ) {
                    onKeyRelease?(.a)
                } else if (key.keyCode == .keyboardK) {
                    onKeyRelease?(.b)
                } else if (key.keyCode == .keyboardN) {
                    onKeyRelease?(.select)
                } else if (key.keyCode == .keyboardM) {
                    onKeyRelease?(.start)
                }
            }
        }
    }
    
}

extension KeyInputMask: UIKeyInput {
    
    var hasText: Bool {
        return false
    }
    
    
    func insertText(_ text: String) {
        print(text)
    }
    
    func deleteBackward() {
        
    }
    
}

