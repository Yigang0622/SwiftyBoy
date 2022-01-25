//
//  Palette.swift
//  SwiftyBoy
//
//  Created by Yigang Zhou on 2022/1/25.
//

import Foundation

class Palette{

    static let paletteGreen: [UInt32] = [
        0xE0F8D0FF, 0x88C070FF, 0x346856FF, 0x081820FF
    ]
                                
    static let paletteGray: [UInt32] = [
        0xFFFFFFFF, 0xAAAAAAFF, 0x444444FF, 0x000000FF
    ]
        
    static func getPaletteColor(colorCode: Int) -> UInt32 {
        if colorCode >= 0 && colorCode <= 3 {
            return paletteGray[colorCode]
        } else {
            return 0
        }
    }
    
}
