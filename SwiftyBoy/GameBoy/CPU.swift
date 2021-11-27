//
//  CPU.swift
//  SwiftyBoy
//
//  Created by Yigang Zhou on 2021/11/25.
//

import Foundation

/**
 GameBoy CPU
 */
class CPU {
    
    weak var mb: Motherboard!;
    
    private var _a: UInt8 = 0x00
    private var _f: UInt8 = 0x00
    
    private var _b: UInt8 = 0x00
    private var _c: UInt8 = 0x00
    
    private var _d: UInt8 = 0x00
    private var _e: UInt8 = 0x00
    
    private var _h: UInt8 = 0x00
    private var _l: UInt8 = 0x00
    
    private var _sp: UInt16 = 0x0000
    private var _pc: UInt16 = 0x0000
    
    public var a: UInt {
        get {
            return UInt(_a)
        }
        set {
            _a = UInt8(newValue & 0xFF)
        }
    }
    
    public var b: UInt {
        get {
            return UInt(_b)
        }
        set {
            _b = UInt8(newValue & 0xFF)
        }
    }
    
    public var c: UInt {
        get {
            return UInt(_c)
        }
        set {
            _c = UInt8(newValue & 0xFF)
        }
    }
    
    public var d: UInt {
        get {
            return UInt(_d)
        }
        set {
            _d = UInt8(newValue & 0xFF)
        }
    }
    
    public var e: UInt {
        get {
            return UInt(_e)
        }
        set {
            _e = UInt8(newValue & 0xFF)
        }
    }
    
    public var h: UInt {
        get {
            return UInt(_h)
        }
        set {
            _h = UInt8(newValue & 0xFF)
        }
    }
    
    public var l: UInt {
        get {
            return UInt(_l)
        }
        set {
            _l = UInt8(newValue & 0xFF)
        }
    }
    
    public var pc: UInt {
        get {
            return UInt(_pc)
        }
        set {
            _pc = UInt16(newValue & 0xFFFF)
        }
    }
    
    public var sp: UInt {
        get {
            return UInt(_sp)
        }
        set {
            _sp = UInt16(newValue & 0xFFFF)
        }
    }
    
    public var bc: UInt {
        get {
            return UInt(_b << 8 + _c)
        }
        set {
            _b = UInt8(newValue >> 8)
            _c = UInt8(newValue & 0x00FF)
        }
    }
    
    public var de: UInt {
        get {
            return UInt(_d << 8 + _e)
        }
        set {
            _d = UInt8(newValue >> 8)
            _e = UInt8(newValue & 0x00FF)
        }
    }
    
    public var hl: UInt {
        get {
            return UInt(_h << 8 + _l)
        }
        set {
            _h = UInt8(newValue >> 8)
            _l = UInt8(newValue & 0x00FF)
        }
    }
    
    var baseInstructions = Array<CPUInstruction?>(repeating: nil, count: 256)
    var extendedInstructions = Array<CPUInstruction?>(repeating: nil, count: 256)
    
    init() {
        // 1. LD nn,n
        setupBaseInstructions(instruction: CPUInstruction(name: "LD B, N", opcode: 0x06, inscruction: LD_06))
        setupBaseInstructions(instruction: CPUInstruction(name: "LD C, N", opcode: 0x0E, inscruction: LD_0E))
        setupBaseInstructions(instruction: CPUInstruction(name: "LD D, N", opcode: 0x16, inscruction: LD_16))
        setupBaseInstructions(instruction: CPUInstruction(name: "LD E, N", opcode: 0x1E, inscruction: LD_1E))
        setupBaseInstructions(instruction: CPUInstruction(name: "LD H, N", opcode: 0x26, inscruction: LD_26))
        setupBaseInstructions(instruction: CPUInstruction(name: "LD L, N", opcode: 0x2E, inscruction: LD_2E))
        // 2. LD r1, r2
        setupBaseInstructions(instruction: CPUInstruction(name: "LD A, A", opcode: 0x7F, inscruction: LD_7F))
        setupBaseInstructions(instruction: CPUInstruction(name: "LD A, B", opcode: 0x78, inscruction: LD_78))
        setupBaseInstructions(instruction: CPUInstruction(name: "LD A, C", opcode: 0x79, inscruction: LD_79))
        setupBaseInstructions(instruction: CPUInstruction(name: "LD A, D", opcode: 0x7A, inscruction: LD_7A))
        setupBaseInstructions(instruction: CPUInstruction(name: "LD A, E", opcode: 0x7B, inscruction: LD_7B))
        setupBaseInstructions(instruction: CPUInstruction(name: "LD A, H", opcode: 0x7C, inscruction: LD_7C))
        setupBaseInstructions(instruction: CPUInstruction(name: "LD A, L", opcode: 0x7D, inscruction: LD_7D))
        
    }
    
    private func setupBaseInstructions(instruction: CPUInstruction) {
        baseInstructions[Int(instruction.opcode)] = instruction
    }
    
}
