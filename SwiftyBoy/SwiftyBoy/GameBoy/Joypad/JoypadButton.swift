//
//  JoypadButton.swift
//  SwiftyBoy
//
//  Created by Yigang Zhou on 2022/1/23.
//

import Foundation

struct JoypadButton: Hashable {
    var mask: Int;
    var line: Int;
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(mask)
        hasher.combine(line)
    }
    
    static func == (lhs: JoypadButton, rhs: JoypadButton) -> Bool {
        return lhs.mask == rhs.mask && lhs.line == rhs.line
    }
    
}
