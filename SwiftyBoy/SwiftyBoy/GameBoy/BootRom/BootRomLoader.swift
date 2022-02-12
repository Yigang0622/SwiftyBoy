//
//  BootRomLoader.swift
//  SwiftyBoy
//
//  Created by Yigang Zhou on 2022/2/12.
//

import Foundation

class BootRomLoader: NSObject {
    
    public static func loadBootRom(url: URL) -> BootRom? {
        do {
            let bytes = [UInt8](try Data(contentsOf: url))            
            return BootRom(bytes: bytes)
        } catch {
            print(error.localizedDescription)
            return nil
        }
    }
    
}
