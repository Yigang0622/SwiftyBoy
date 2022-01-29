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
    
    private weak var interruptManager: InterruptManager!
    var mb: Motherboard!
    
    private var p1 = 0
    private var pressedButtons = Set<JoypadButton>()
    
    private static let rightButton = JoypadButton(mask: 0x01, line: 0x10)
    private static let leftButton = JoypadButton(mask: 0x02, line: 0x10)
    private static let upButton = JoypadButton(mask: 0x04, line: 0x10)
    private static let downButton = JoypadButton(mask: 0x08, line: 0x10)
    private static let aButton = JoypadButton(mask: 0x01, line: 0x20)
    private static let bButton = JoypadButton(mask: 0x02, line: 0x20)
    private static let selectButton = JoypadButton(mask: 0x04, line: 0x20)
    private static let startButton = JoypadButton(mask: 0x08, line: 0x20)
    
    init(interruptManager: InterruptManager) {
        self.interruptManager = interruptManager
    }
    
    private func getButton(type: JoypadButtonType) -> JoypadButton {
        switch type {
        case .up:
            return Joypad.upButton
        case .down:
            return Joypad.downButton
        case .left:
            return Joypad.leftButton
        case .right:
            return Joypad.rightButton
        case .a:
            return Joypad.aButton
        case .b:
            return Joypad.bButton
        case .select:
            return Joypad.selectButton
        case .start:
            return Joypad.startButton
        }
    }
    
    func pressButton(type: JoypadButtonType) {
        let button = getButton(type: type)
        self.pressedButtons.insert(button)
        // todo request interrupt
        mb.cpu.interruptFlagRegister.highToLow = true
    }
    
    func releaseButton(type: JoypadButtonType) {
        let button = getButton(type: type)
        self.pressedButtons.remove(button)
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
