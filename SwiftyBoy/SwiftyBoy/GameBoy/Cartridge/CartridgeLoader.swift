//
//  CartridgeLoader.swift
//  SwiftyBoy
//
//  Created by Yigang Zhou on 2021/12/19.
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



class CartageLoader {
    
    static func loadCartage() -> Cartridge {
        print("loading cartage")
        let fileName = "Pokemon Red (UE) [S][!]"
        let bytes = loadTestRom(name: fileName)
        let meta = getCaridgeMeta(flag: bytes[0x0147])
        let name = bytes[0x0134...0x0142].reduce("") { partialResult, next in
            partialResult + String(Character(UnicodeScalar(next)))
        }
        print("[Cartridge Name] \(name)")
        print(meta)
//        return DummyCart()
        if meta.type == .MBC1 {
            return MBC1(bytes: bytes, name: name, meta: meta, fileName: fileName)
        } else if meta.type == .ROMOnly {
            return ROMOnly(bytes: bytes, name: name, meta: meta, fileName: fileName)
        } else if meta.type == .MBC3 {
            return MBC3(bytes: bytes, name: name, meta: meta, fileName: fileName)
        } else {
            fatalError("cart not supported")
        }
    }
    
    static func loadCartridge(url: URL) -> Cartridge? {
        do {
            let fileName = url.deletingPathExtension().lastPathComponent
            let bytes = [UInt8](try Data(contentsOf: url))
            let meta = getCaridgeMeta(flag: bytes[0x0147])
            let name = bytes[0x0134...0x0142].reduce("") { partialResult, next in
                partialResult + String(Character(UnicodeScalar(next)))
            }
            print("[Cartridge Name] \(name)")
            print(meta) 
            if meta.type == .MBC1 {
                return MBC1(bytes: bytes, name: name, meta: meta, fileName: fileName)
            } else if meta.type == .ROMOnly {
                return ROMOnly(bytes: bytes, name: name, meta: meta, fileName: fileName)
            } else if meta.type == .MBC3 {
                return MBC3(bytes: bytes, name: name, meta: meta, fileName: fileName)
            }  else if meta.type == .MBC2 {
                return MBC2(bytes: bytes, name: name, meta: meta, fileName: fileName)
            } else if meta.type == .MBC5 {
                return MBC5(bytes: bytes, name: name, meta: meta, fileName: fileName)
            } else {
                fatalError("cart not supported")
            }
        } catch {
            print(error.localizedDescription)
            return nil
        }
    }
    
    
    private static func loadTestRom(name: String) -> [UInt8] {

        if let fileURL = Bundle.main.url(forResource: name, withExtension: "gb") {
            
            do {
                let raw = try Data(contentsOf: fileURL)
    
                return [UInt8](raw)
            } catch {
                print(error.localizedDescription)
            }
        }
        return []
    }
    
    
    private static func getCaridgeMeta(flag: UInt8) -> CartridgeMeta {
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
