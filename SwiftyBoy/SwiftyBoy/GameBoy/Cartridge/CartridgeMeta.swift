//
//  CartridgeMeta.swift
//  SwiftyBoy
//
//  Created by Yigang Zhou on 2021/12/7.
//

import Foundation

enum CartridgeType: Int {
    case ROMOnly
    case MBC1
    case MBC2
    case MBC3
    case MBC5
}

struct CartridgeMeta {
    var type: CartridgeType
    var sram: Bool
    var battery: Bool
    var rtc: Bool
}

class CartridgeUtil {
    
    
    static func getCaridgeMeta(flag: UInt8) -> CartridgeMeta {
        switch flag {
        case 0x00: return CartridgeMeta(type: .ROMOnly, sram: false, battery: false, rtc: false)
        case 0x01: return CartridgeMeta(type: .MBC1, sram: false, battery: false, rtc: false)
        case 0x02: return CartridgeMeta(type: .MBC1, sram: true, battery: false, rtc: false)
        case 0x03: return CartridgeMeta(type: .MBC1, sram: true, battery: true, rtc: false)
        case 0x05: return CartridgeMeta(type: .MBC2, sram: false, battery: false, rtc: false)
        case 0x06: return CartridgeMeta(type: .MBC2, sram: false, battery: true, rtc: false)
        case 0x08: return CartridgeMeta(type: .ROMOnly, sram: true, battery: false, rtc: false)
        case 0x09: return CartridgeMeta(type: .ROMOnly, sram: true, battery: true, rtc: false)
            
        case 0x0F: return CartridgeMeta(type: .MBC3, sram: false, battery: true, rtc: true)
        case 0x10: return CartridgeMeta(type: .MBC3, sram: true, battery: true, rtc: true)
        case 0x11: return CartridgeMeta(type: .MBC3, sram: false, battery: false, rtc: false)
        case 0x12: return CartridgeMeta(type: .MBC3, sram: true, battery: false, rtc: false)
        case 0x13: return CartridgeMeta(type: .MBC3, sram: true, battery: true, rtc: false)
            
        case 0x19: return CartridgeMeta(type: .MBC5, sram: false, battery: false, rtc: false)
        case 0x1A: return CartridgeMeta(type: .MBC5, sram: true, battery: false, rtc: false)
        case 0x1B: return CartridgeMeta(type: .MBC5, sram: true, battery: true, rtc: false)
        case 0x1C: return CartridgeMeta(type: .MBC5, sram: false, battery: false, rtc: false)
        case 0x1D: return CartridgeMeta(type: .MBC5, sram: true, battery: false, rtc: false)
        case 0x1E: return CartridgeMeta(type: .MBC5, sram: true, battery: true, rtc: false)
            
        default:
            print("Unknow cart!!")
            return CartridgeMeta(type: .ROMOnly, sram: false, battery: false, rtc: false)
        }
    }

    
}


