//
//  RegNR41.swift
//  SwiftyBoy
//
//  Created by Yigang Zhou on 2022/4/14.
//

import UIKit

class RegNR41: BaseRegister {
    
    var soundLength: Int {
        set {
            _val = UInt8(newValue)
        }
        get {
            return Int(_val) & 0b11111
        }
    }

}
