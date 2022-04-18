//
//  DMAController.swift
//  SwiftyBoy
//
//  Created by Yigang Zhou on 2022/4/17.
//

import UIKit

class DMAController: NSObject {
    
    var mb: Motherboard!
    
    public func dma(src: Int) {
        let dst = 0xFE00
        let offset = src * 0x100
        for i in 0...0xA0 {
            mb.setMem(address: dst + i, val: mb.getMem(address: i + offset))
        }
    }

}
