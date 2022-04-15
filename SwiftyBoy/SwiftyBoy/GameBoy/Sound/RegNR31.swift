//
//  RegNR31.swift
//  SwiftyBoy
//
//  Created by Yigang Zhou on 2022/4/11.
//

import UIKit

class RegNR31: BaseRegister {
    
    var soundLength: Int {
        get {
            return (getVal() & 0b11111000) >> 3
        }
        set {
            _val = UInt8((newValue & 0b11111) << 3)
        }
    }

}
