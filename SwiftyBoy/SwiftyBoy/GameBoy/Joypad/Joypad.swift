//
//  Joypad.swift
//  SwiftyBoy
//
//  Created by Yigang Zhou on 2022/1/23.
//

import Foundation

enum JoypadButtonType {
    case up, down, left, right, a, b, select, start
}

class Joypad {
    
    private var p1 = 0
    private var pressedButtons = Set<JoypadButton>()
    
    private let rightButton = JoypadButton(mask: 0x01, line: 0x10)
    private let leftButton = JoypadButton(mask: 0x02, line: 0x10)
    private let upButton = JoypadButton(mask: 0x04, line: 0x10)
    private let downButton = JoypadButton(mask: 0x08, line: 0x10)
    private let aButton = JoypadButton(mask: 0x01, line: 0x20)
    private let bButton = JoypadButton(mask: 0x02, line: 0x20)
    private let selectButton = JoypadButton(mask: 0x04, line: 0x20)
    private let startButton = JoypadButton(mask: 0x08, line: 0x20)
    
    private func getButton(type: JoypadButtonType) -> JoypadButton {
        switch type {
        case .up:
            return upButton
        case .down:
            return downButton
        case .left:
            return leftButton
        case .right:
            return rightButton
        case .a:
            return aButton
        case .b:
            return bButton
        case .select:
            return selectButton
        case .start:
            return startButton
        }
    }
    
}

extension Joypad: MemoryAccessable {
    
    func canAccess(address: Int) -> Bool {
        return address == 0xff00
    }
    
    func getMem(address: Int) -> Int {
        var result = p1 | 0b11001111
        pressedButtons.forEach { b in
            if b.line & p1 == 0 {
                result &= 0xFF & ~b.mask
            }
        }
        return result
    }
    
    func setMem(address: Int, val: Int) {
        self.p1 = val & 0b00110000
    }
    
}
