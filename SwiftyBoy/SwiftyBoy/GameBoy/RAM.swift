//
//  RAM.swift
//  SwiftyBoy
//
//  Created by Yigang Zhou on 2021/12/9.
//

import Foundation

class RAM {
    
    var internalRam0 = Array<UInt8>(repeating: 0x00, count: 8 * 1024)
    var nonIoInternalRam0 = Array<UInt8>(repeating: 0x00, count: 0x60)
    var ioPortsRAM = Array<UInt8>(repeating: 0x00, count: 0x4C)
    var internalRam1 = Array<UInt8>(repeating: 0x00, count: 0x7F)
    var nonIoInternalRam1 = Array<UInt8>(repeating: 0x00, count: 0x34)
    
}
