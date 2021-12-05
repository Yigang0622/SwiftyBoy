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
    
    public var halted: Bool = false
    public var interruptMasterEnable = false
    
    public var a: Int {
        get {
            return Int(_a)
        }
        set {
            _a = UInt8(newValue & 0xFF)
        }
    }
    
    public var b: Int {
        get {
            return Int(_b)
        }
        set {
            _b = UInt8(newValue & 0xFF)
        }
    }
    
    public var c: Int {
        get {
            return Int(_c)
        }
        set {
            _c = UInt8(newValue & 0xFF)
        }
    }
    
    public var d: Int {
        get {
            return Int(_d)
        }
        set {
            _d = UInt8(newValue & 0xFF)
        }
    }
    
    public var e: Int {
        get {
            return Int(_e)
        }
        set {
            _e = UInt8(newValue & 0xFF)
        }
    }
    
    public var h: Int {
        get {
            return Int(_h)
        }
        set {
            _h = UInt8(newValue & 0xFF)
        }
    }
    
    public var l: Int {
        get {
            return Int(_l)
        }
        set {
            _l = UInt8(newValue & 0xFF)
        }
    }
    
    public var pc: Int {
        get {
            return Int(_pc)
        }
        set {
            _pc = UInt16(newValue & 0xFFFF)
        }
    }
    
    public var sp: Int {
        get {
            return Int(_sp)
        }
        set {
            print("set SP \(newValue)")
            _sp = UInt16(newValue & 0xFFFF)
        }
    }
    
    public var bc: Int {
        get {
            return b << 8 + c
        }
        set {
            _b = UInt8(newValue >> 8)
            _c = UInt8(newValue & 0x00FF)
        }
    }
    
    public var de: Int {
        get {
            return d << 8 + e
        }
        set {
            _d = UInt8(newValue >> 8)
            _e = UInt8(newValue & 0x00FF)
        }
    }
    
    public var hl: Int {
        get {
            return h << 8 + l
        }
        set {
            _h = UInt8(newValue >> 8)
            _l = UInt8(newValue & 0x00FF)
        }
    }
    
    public var f: Int {
        get {
            return Int(_f)
        }
        set {
            _f = UInt8(newValue & 0b11110000)
        }
    }
    
    public var fZ: Bool {
        get {
            let a =  Int(_f & 0b10000000) >> 7 == 1
            return a
        }
        set {
            let mask = newValue ? 0b11110000 : 0b01110000
//            f = newValue.integerValue << 7 & mask
            f = newValue ? setBit(n: 7, val: f) : resetBit(n: 7, val: f)
        }
    }
    
    public var fN: Bool {
        get {
            return Int(_f & 0b01000000) >> 6 == 1
        }
        set {
//            let mask = newValue ? 0b11110000 : 0b10110000
//            _f = UInt8(newValue.integerValue << 6 & mask)
            f = newValue ? setBit(n: 6, val: f) : resetBit(n: 6, val: f)
        }
    }
    
    public var fH: Bool {
        get {
            return Int(_f & 0b00100000) >> 5 == 1
        }
        set {
//            let mask = newValue ? 0b11110000 : 0b11010000
//            _f = UInt8(newValue.integerValue << 5 & mask)
            f = newValue ? setBit(n: 5, val: f) : resetBit(n: 5, val: f)
        }
    }
    
    public var fC: Bool {
        get {
            return Int(_f & 0b00010000) >> 4 == 1
        }
        set {
//            let mask = newValue ? 0b11110000 : 0b11100000
//            _f = UInt8(newValue.integerValue << 4 & mask)
            f = newValue ? setBit(n: 4, val: f) : resetBit(n: 4, val: f)
        }
    }
    
    
    var baseInstructions = Array<CPUInstruction?>(repeating: nil, count: 256)
    var cbInstructions = Array<CPUInstruction?>(repeating: nil, count: 256)
    
    init() {
        baseInstructions[0x00] = CPUInstruction(name: "NOP", opcode: 0x00, instruction: NOP_00, byteLength: 1)
        baseInstructions[0x01] = CPUInstruction(name: "LD BC,d16", opcode: 0x01, instruction: LD_01, byteLength: 3)
        baseInstructions[0x02] = CPUInstruction(name: "LD (BC),A", opcode: 0x02, instruction: LD_02, byteLength: 1)
        baseInstructions[0x03] = CPUInstruction(name: "INC BC", opcode: 0x03, instruction: INC_03, byteLength: 1)
        baseInstructions[0x04] = CPUInstruction(name: "INC B", opcode: 0x04, instruction: INC_04, byteLength: 1)
        baseInstructions[0x05] = CPUInstruction(name: "DEC B", opcode: 0x05, instruction: DEC_05, byteLength: 1)
        baseInstructions[0x06] = CPUInstruction(name: "LD B,d8", opcode: 0x06, instruction: LD_06, byteLength: 2)
        baseInstructions[0x07] = CPUInstruction(name: "RLCA", opcode: 0x07, instruction: RLCA_07, byteLength: 1)
        baseInstructions[0x08] = CPUInstruction(name: "LD (a16),SP", opcode: 0x08, instruction: LD_08, byteLength: 3)
        baseInstructions[0x09] = CPUInstruction(name: "ADD HL,BC", opcode: 0x09, instruction: ADD_09, byteLength: 1)
        baseInstructions[0x0a] = CPUInstruction(name: "LD A,(BC)", opcode: 0x0a, instruction: LD_0A, byteLength: 1)
        baseInstructions[0x0b] = CPUInstruction(name: "DEC BC", opcode: 0x0b, instruction: DEC_0B, byteLength: 1)
        baseInstructions[0x0c] = CPUInstruction(name: "INC C", opcode: 0x0c, instruction: INC_0C, byteLength: 1)
        baseInstructions[0x0d] = CPUInstruction(name: "DEC C", opcode: 0x0d, instruction: DEC_0D, byteLength: 1)
        baseInstructions[0x0e] = CPUInstruction(name: "LD C,d8", opcode: 0x0e, instruction: LD_0E, byteLength: 2)
        baseInstructions[0x0f] = CPUInstruction(name: "RRCA", opcode: 0x0f, instruction: RRCA_0F, byteLength: 1)
        baseInstructions[0x10] = CPUInstruction(name: "STOP 0", opcode: 0x10, instruction: STOP_10, byteLength: 2)
        baseInstructions[0x11] = CPUInstruction(name: "LD DE,d16", opcode: 0x11, instruction: LD_11, byteLength: 3)
        baseInstructions[0x12] = CPUInstruction(name: "LD (DE),A", opcode: 0x12, instruction: LD_12, byteLength: 1)
        baseInstructions[0x13] = CPUInstruction(name: "INC DE", opcode: 0x13, instruction: INC_13, byteLength: 1)
        baseInstructions[0x14] = CPUInstruction(name: "INC D", opcode: 0x14, instruction: INC_14, byteLength: 1)
        baseInstructions[0x15] = CPUInstruction(name: "DEC D", opcode: 0x15, instruction: DEC_15, byteLength: 1)
        baseInstructions[0x16] = CPUInstruction(name: "LD D,d8", opcode: 0x16, instruction: LD_16, byteLength: 2)
        baseInstructions[0x17] = CPUInstruction(name: "RLA", opcode: 0x17, instruction: RLA_17, byteLength: 1)
        baseInstructions[0x18] = CPUInstruction(name: "JR r8", opcode: 0x18, instruction: JR_18, byteLength: 2)
        baseInstructions[0x19] = CPUInstruction(name: "ADD HL,DE", opcode: 0x19, instruction: ADD_19, byteLength: 1)
        baseInstructions[0x1a] = CPUInstruction(name: "LD A,(DE)", opcode: 0x1a, instruction: LD_1A, byteLength: 1)
        baseInstructions[0x1b] = CPUInstruction(name: "DEC DE", opcode: 0x1b, instruction: DEC_1B, byteLength: 1)
        baseInstructions[0x1c] = CPUInstruction(name: "INC E", opcode: 0x1c, instruction: INC_1C, byteLength: 1)
        baseInstructions[0x1d] = CPUInstruction(name: "DEC E", opcode: 0x1d, instruction: DEC_1D, byteLength: 1)
        baseInstructions[0x1e] = CPUInstruction(name: "LD E,d8", opcode: 0x1e, instruction: LD_1E, byteLength: 2)
        baseInstructions[0x1f] = CPUInstruction(name: "RRA", opcode: 0x1f, instruction: RRA_1F, byteLength: 1)
        baseInstructions[0x20] = CPUInstruction(name: "JR NZ,r8", opcode: 0x20, instruction: JR_20, byteLength: 2)
        baseInstructions[0x21] = CPUInstruction(name: "LD HL,d16", opcode: 0x21, instruction: LD_21, byteLength: 3)
        baseInstructions[0x22] = CPUInstruction(name: "LD (HL+),A", opcode: 0x22, instruction: LD_22, byteLength: 1)
        baseInstructions[0x23] = CPUInstruction(name: "INC HL", opcode: 0x23, instruction: INC_23, byteLength: 1)
        baseInstructions[0x24] = CPUInstruction(name: "INC H", opcode: 0x24, instruction: INC_24, byteLength: 1)
        baseInstructions[0x25] = CPUInstruction(name: "DEC H", opcode: 0x25, instruction: DEC_25, byteLength: 1)
        baseInstructions[0x26] = CPUInstruction(name: "LD H,d8", opcode: 0x26, instruction: LD_26, byteLength: 2)
        baseInstructions[0x27] = CPUInstruction(name: "DAA", opcode: 0x27, instruction: DAA_27, byteLength: 1)
        baseInstructions[0x28] = CPUInstruction(name: "JR Z,r8", opcode: 0x28, instruction: JR_28, byteLength: 2)
        baseInstructions[0x29] = CPUInstruction(name: "ADD HL,HL", opcode: 0x29, instruction: ADD_29, byteLength: 1)
        baseInstructions[0x2a] = CPUInstruction(name: "LD A,(HL+)", opcode: 0x2a, instruction: LD_2A, byteLength: 1)
        baseInstructions[0x2b] = CPUInstruction(name: "DEC HL", opcode: 0x2b, instruction: DEC_2B, byteLength: 1)
        baseInstructions[0x2c] = CPUInstruction(name: "INC L", opcode: 0x2c, instruction: INC_2C, byteLength: 1)
        baseInstructions[0x2d] = CPUInstruction(name: "DEC L", opcode: 0x2d, instruction: DEC_2D, byteLength: 1)
        baseInstructions[0x2e] = CPUInstruction(name: "LD L,d8", opcode: 0x2e, instruction: LD_2E, byteLength: 2)
        baseInstructions[0x2f] = CPUInstruction(name: "CPL", opcode: 0x2f, instruction: CPL_2F, byteLength: 1)
        baseInstructions[0x30] = CPUInstruction(name: "JR NC,r8", opcode: 0x30, instruction: JR_30, byteLength: 2)
        baseInstructions[0x31] = CPUInstruction(name: "LD SP,d16", opcode: 0x31, instruction: LD_31, byteLength: 3)
        baseInstructions[0x32] = CPUInstruction(name: "LD (HL-),A", opcode: 0x32, instruction: LD_32, byteLength: 1)
        baseInstructions[0x33] = CPUInstruction(name: "INC SP", opcode: 0x33, instruction: INC_33, byteLength: 1)
        baseInstructions[0x34] = CPUInstruction(name: "INC (HL)", opcode: 0x34, instruction: INC_34, byteLength: 1)
        baseInstructions[0x35] = CPUInstruction(name: "DEC (HL)", opcode: 0x35, instruction: DEC_35, byteLength: 1)
        baseInstructions[0x36] = CPUInstruction(name: "LD (HL),d8", opcode: 0x36, instruction: LD_36, byteLength: 2)
        baseInstructions[0x37] = CPUInstruction(name: "SCF", opcode: 0x37, instruction: SCF_37, byteLength: 1)
        baseInstructions[0x38] = CPUInstruction(name: "JR C,r8", opcode: 0x38, instruction: JR_38, byteLength: 2)
        baseInstructions[0x39] = CPUInstruction(name: "ADD HL,SP", opcode: 0x39, instruction: ADD_39, byteLength: 1)
        baseInstructions[0x3a] = CPUInstruction(name: "LD A,(HL-)", opcode: 0x3a, instruction: LD_3A, byteLength: 1)
        baseInstructions[0x3b] = CPUInstruction(name: "DEC SP", opcode: 0x3b, instruction: DEC_3B, byteLength: 1)
        baseInstructions[0x3c] = CPUInstruction(name: "INC A", opcode: 0x3c, instruction: INC_3C, byteLength: 1)
        baseInstructions[0x3d] = CPUInstruction(name: "DEC A", opcode: 0x3d, instruction: DEC_3D, byteLength: 1)
        baseInstructions[0x3e] = CPUInstruction(name: "LD A,d8", opcode: 0x3e, instruction: LD_3E, byteLength: 2)
        baseInstructions[0x3f] = CPUInstruction(name: "CCF", opcode: 0x3f, instruction: CCF_3F, byteLength: 1)
        baseInstructions[0x40] = CPUInstruction(name: "LD B,B", opcode: 0x40, instruction: LD_40, byteLength: 1)
        baseInstructions[0x41] = CPUInstruction(name: "LD B,C", opcode: 0x41, instruction: LD_41, byteLength: 1)
        baseInstructions[0x42] = CPUInstruction(name: "LD B,D", opcode: 0x42, instruction: LD_42, byteLength: 1)
        baseInstructions[0x43] = CPUInstruction(name: "LD B,E", opcode: 0x43, instruction: LD_43, byteLength: 1)
        baseInstructions[0x44] = CPUInstruction(name: "LD B,H", opcode: 0x44, instruction: LD_44, byteLength: 1)
        baseInstructions[0x45] = CPUInstruction(name: "LD B,L", opcode: 0x45, instruction: LD_45, byteLength: 1)
        baseInstructions[0x46] = CPUInstruction(name: "LD B,(HL)", opcode: 0x46, instruction: LD_46, byteLength: 1)
        baseInstructions[0x47] = CPUInstruction(name: "LD B,A", opcode: 0x47, instruction: LD_47, byteLength: 1)
        baseInstructions[0x48] = CPUInstruction(name: "LD C,B", opcode: 0x48, instruction: LD_48, byteLength: 1)
        baseInstructions[0x49] = CPUInstruction(name: "LD C,C", opcode: 0x49, instruction: LD_49, byteLength: 1)
        baseInstructions[0x4a] = CPUInstruction(name: "LD C,D", opcode: 0x4a, instruction: LD_4A, byteLength: 1)
        baseInstructions[0x4b] = CPUInstruction(name: "LD C,E", opcode: 0x4b, instruction: LD_4B, byteLength: 1)
        baseInstructions[0x4c] = CPUInstruction(name: "LD C,H", opcode: 0x4c, instruction: LD_4C, byteLength: 1)
        baseInstructions[0x4d] = CPUInstruction(name: "LD C,L", opcode: 0x4d, instruction: LD_4D, byteLength: 1)
        baseInstructions[0x4e] = CPUInstruction(name: "LD C,(HL)", opcode: 0x4e, instruction: LD_4E, byteLength: 1)
        baseInstructions[0x4f] = CPUInstruction(name: "LD C,A", opcode: 0x4f, instruction: LD_4F, byteLength: 1)
        baseInstructions[0x50] = CPUInstruction(name: "LD D,B", opcode: 0x50, instruction: LD_50, byteLength: 1)
        baseInstructions[0x51] = CPUInstruction(name: "LD D,C", opcode: 0x51, instruction: LD_51, byteLength: 1)
        baseInstructions[0x52] = CPUInstruction(name: "LD D,D", opcode: 0x52, instruction: LD_52, byteLength: 1)
        baseInstructions[0x53] = CPUInstruction(name: "LD D,E", opcode: 0x53, instruction: LD_53, byteLength: 1)
        baseInstructions[0x54] = CPUInstruction(name: "LD D,H", opcode: 0x54, instruction: LD_54, byteLength: 1)
        baseInstructions[0x55] = CPUInstruction(name: "LD D,L", opcode: 0x55, instruction: LD_55, byteLength: 1)
        baseInstructions[0x56] = CPUInstruction(name: "LD D,(HL)", opcode: 0x56, instruction: LD_56, byteLength: 1)
        baseInstructions[0x57] = CPUInstruction(name: "LD D,A", opcode: 0x57, instruction: LD_57, byteLength: 1)
        baseInstructions[0x58] = CPUInstruction(name: "LD E,B", opcode: 0x58, instruction: LD_58, byteLength: 1)
        baseInstructions[0x59] = CPUInstruction(name: "LD E,C", opcode: 0x59, instruction: LD_59, byteLength: 1)
        baseInstructions[0x5a] = CPUInstruction(name: "LD E,D", opcode: 0x5a, instruction: LD_5A, byteLength: 1)
        baseInstructions[0x5b] = CPUInstruction(name: "LD E,E", opcode: 0x5b, instruction: LD_5B, byteLength: 1)
        baseInstructions[0x5c] = CPUInstruction(name: "LD E,H", opcode: 0x5c, instruction: LD_5C, byteLength: 1)
        baseInstructions[0x5d] = CPUInstruction(name: "LD E,L", opcode: 0x5d, instruction: LD_5D, byteLength: 1)
        baseInstructions[0x5e] = CPUInstruction(name: "LD E,(HL)", opcode: 0x5e, instruction: LD_5E, byteLength: 1)
        baseInstructions[0x5f] = CPUInstruction(name: "LD E,A", opcode: 0x5f, instruction: LD_5F, byteLength: 1)
        baseInstructions[0x60] = CPUInstruction(name: "LD H,B", opcode: 0x60, instruction: LD_60, byteLength: 1)
        baseInstructions[0x61] = CPUInstruction(name: "LD H,C", opcode: 0x61, instruction: LD_61, byteLength: 1)
        baseInstructions[0x62] = CPUInstruction(name: "LD H,D", opcode: 0x62, instruction: LD_62, byteLength: 1)
        baseInstructions[0x63] = CPUInstruction(name: "LD H,E", opcode: 0x63, instruction: LD_63, byteLength: 1)
        baseInstructions[0x64] = CPUInstruction(name: "LD H,H", opcode: 0x64, instruction: LD_64, byteLength: 1)
        baseInstructions[0x65] = CPUInstruction(name: "LD H,L", opcode: 0x65, instruction: LD_65, byteLength: 1)
        baseInstructions[0x66] = CPUInstruction(name: "LD H,(HL)", opcode: 0x66, instruction: LD_66, byteLength: 1)
        baseInstructions[0x67] = CPUInstruction(name: "LD H,A", opcode: 0x67, instruction: LD_67, byteLength: 1)
        baseInstructions[0x68] = CPUInstruction(name: "LD L,B", opcode: 0x68, instruction: LD_68, byteLength: 1)
        baseInstructions[0x69] = CPUInstruction(name: "LD L,C", opcode: 0x69, instruction: LD_69, byteLength: 1)
        baseInstructions[0x6a] = CPUInstruction(name: "LD L,D", opcode: 0x6a, instruction: LD_6A, byteLength: 1)
        baseInstructions[0x6b] = CPUInstruction(name: "LD L,E", opcode: 0x6b, instruction: LD_6B, byteLength: 1)
        baseInstructions[0x6c] = CPUInstruction(name: "LD L,H", opcode: 0x6c, instruction: LD_6C, byteLength: 1)
        baseInstructions[0x6d] = CPUInstruction(name: "LD L,L", opcode: 0x6d, instruction: LD_6D, byteLength: 1)
        baseInstructions[0x6e] = CPUInstruction(name: "LD L,(HL)", opcode: 0x6e, instruction: LD_6E, byteLength: 1)
        baseInstructions[0x6f] = CPUInstruction(name: "LD L,A", opcode: 0x6f, instruction: LD_6F, byteLength: 1)
        baseInstructions[0x70] = CPUInstruction(name: "LD (HL),B", opcode: 0x70, instruction: LD_70, byteLength: 1)
        baseInstructions[0x71] = CPUInstruction(name: "LD (HL),C", opcode: 0x71, instruction: LD_71, byteLength: 1)
        baseInstructions[0x72] = CPUInstruction(name: "LD (HL),D", opcode: 0x72, instruction: LD_72, byteLength: 1)
        baseInstructions[0x73] = CPUInstruction(name: "LD (HL),E", opcode: 0x73, instruction: LD_73, byteLength: 1)
        baseInstructions[0x74] = CPUInstruction(name: "LD (HL),H", opcode: 0x74, instruction: LD_74, byteLength: 1)
        baseInstructions[0x75] = CPUInstruction(name: "LD (HL),L", opcode: 0x75, instruction: LD_75, byteLength: 1)
        baseInstructions[0x76] = CPUInstruction(name: "HALT", opcode: 0x76, instruction: HALT_76, byteLength: 1)
        baseInstructions[0x77] = CPUInstruction(name: "LD (HL),A", opcode: 0x77, instruction: LD_77, byteLength: 1)
        baseInstructions[0x78] = CPUInstruction(name: "LD A,B", opcode: 0x78, instruction: LD_78, byteLength: 1)
        baseInstructions[0x79] = CPUInstruction(name: "LD A,C", opcode: 0x79, instruction: LD_79, byteLength: 1)
        baseInstructions[0x7a] = CPUInstruction(name: "LD A,D", opcode: 0x7a, instruction: LD_7A, byteLength: 1)
        baseInstructions[0x7b] = CPUInstruction(name: "LD A,E", opcode: 0x7b, instruction: LD_7B, byteLength: 1)
        baseInstructions[0x7c] = CPUInstruction(name: "LD A,H", opcode: 0x7c, instruction: LD_7C, byteLength: 1)
        baseInstructions[0x7d] = CPUInstruction(name: "LD A,L", opcode: 0x7d, instruction: LD_7D, byteLength: 1)
        baseInstructions[0x7e] = CPUInstruction(name: "LD A,(HL)", opcode: 0x7e, instruction: LD_7E, byteLength: 1)
        baseInstructions[0x7f] = CPUInstruction(name: "LD A,A", opcode: 0x7f, instruction: LD_7F, byteLength: 1)
        baseInstructions[0x80] = CPUInstruction(name: "ADD A,B", opcode: 0x80, instruction: ADD_80, byteLength: 1)
        baseInstructions[0x81] = CPUInstruction(name: "ADD A,C", opcode: 0x81, instruction: ADD_81, byteLength: 1)
        baseInstructions[0x82] = CPUInstruction(name: "ADD A,D", opcode: 0x82, instruction: ADD_82, byteLength: 1)
        baseInstructions[0x83] = CPUInstruction(name: "ADD A,E", opcode: 0x83, instruction: ADD_83, byteLength: 1)
        baseInstructions[0x84] = CPUInstruction(name: "ADD A,H", opcode: 0x84, instruction: ADD_84, byteLength: 1)
        baseInstructions[0x85] = CPUInstruction(name: "ADD A,L", opcode: 0x85, instruction: ADD_85, byteLength: 1)
        baseInstructions[0x86] = CPUInstruction(name: "ADD A,(HL)", opcode: 0x86, instruction: ADD_86, byteLength: 1)
        baseInstructions[0x87] = CPUInstruction(name: "ADD A,A", opcode: 0x87, instruction: ADD_87, byteLength: 1)
        baseInstructions[0x88] = CPUInstruction(name: "ADC A,B", opcode: 0x88, instruction: ADC_88, byteLength: 1)
        baseInstructions[0x89] = CPUInstruction(name: "ADC A,C", opcode: 0x89, instruction: ADC_89, byteLength: 1)
        baseInstructions[0x8a] = CPUInstruction(name: "ADC A,D", opcode: 0x8a, instruction: ADC_8A, byteLength: 1)
        baseInstructions[0x8b] = CPUInstruction(name: "ADC A,E", opcode: 0x8b, instruction: ADC_8B, byteLength: 1)
        baseInstructions[0x8c] = CPUInstruction(name: "ADC A,H", opcode: 0x8c, instruction: ADC_8C, byteLength: 1)
        baseInstructions[0x8d] = CPUInstruction(name: "ADC A,L", opcode: 0x8d, instruction: ADC_8D, byteLength: 1)
        baseInstructions[0x8e] = CPUInstruction(name: "ADC A,(HL)", opcode: 0x8e, instruction: ADC_8E, byteLength: 1)
        baseInstructions[0x8f] = CPUInstruction(name: "ADC A,A", opcode: 0x8f, instruction: ADC_8F, byteLength: 1)
        baseInstructions[0x90] = CPUInstruction(name: "SUB B", opcode: 0x90, instruction: SUB_90, byteLength: 1)
        baseInstructions[0x91] = CPUInstruction(name: "SUB C", opcode: 0x91, instruction: SUB_91, byteLength: 1)
        baseInstructions[0x92] = CPUInstruction(name: "SUB D", opcode: 0x92, instruction: SUB_92, byteLength: 1)
        baseInstructions[0x93] = CPUInstruction(name: "SUB E", opcode: 0x93, instruction: SUB_93, byteLength: 1)
        baseInstructions[0x94] = CPUInstruction(name: "SUB H", opcode: 0x94, instruction: SUB_94, byteLength: 1)
        baseInstructions[0x95] = CPUInstruction(name: "SUB L", opcode: 0x95, instruction: SUB_95, byteLength: 1)
        baseInstructions[0x96] = CPUInstruction(name: "SUB (HL)", opcode: 0x96, instruction: SUB_96, byteLength: 1)
        baseInstructions[0x97] = CPUInstruction(name: "SUB A", opcode: 0x97, instruction: SUB_97, byteLength: 1)
        baseInstructions[0x98] = CPUInstruction(name: "SBC A,B", opcode: 0x98, instruction: SBC_98, byteLength: 1)
        baseInstructions[0x99] = CPUInstruction(name: "SBC A,C", opcode: 0x99, instruction: SBC_99, byteLength: 1)
        baseInstructions[0x9a] = CPUInstruction(name: "SBC A,D", opcode: 0x9a, instruction: SBC_9A, byteLength: 1)
        baseInstructions[0x9b] = CPUInstruction(name: "SBC A,E", opcode: 0x9b, instruction: SBC_9B, byteLength: 1)
        baseInstructions[0x9c] = CPUInstruction(name: "SBC A,H", opcode: 0x9c, instruction: SBC_9C, byteLength: 1)
        baseInstructions[0x9d] = CPUInstruction(name: "SBC A,L", opcode: 0x9d, instruction: SBC_9D, byteLength: 1)
        baseInstructions[0x9e] = CPUInstruction(name: "SBC A,(HL)", opcode: 0x9e, instruction: SBC_9E, byteLength: 1)
        baseInstructions[0x9f] = CPUInstruction(name: "SBC A,A", opcode: 0x9f, instruction: SBC_9F, byteLength: 1)
        baseInstructions[0xa0] = CPUInstruction(name: "AND B", opcode: 0xa0, instruction: AND_A0, byteLength: 1)
        baseInstructions[0xa1] = CPUInstruction(name: "AND C", opcode: 0xa1, instruction: AND_A1, byteLength: 1)
        baseInstructions[0xa2] = CPUInstruction(name: "AND D", opcode: 0xa2, instruction: AND_A2, byteLength: 1)
        baseInstructions[0xa3] = CPUInstruction(name: "AND E", opcode: 0xa3, instruction: AND_A3, byteLength: 1)
        baseInstructions[0xa4] = CPUInstruction(name: "AND H", opcode: 0xa4, instruction: AND_A4, byteLength: 1)
        baseInstructions[0xa5] = CPUInstruction(name: "AND L", opcode: 0xa5, instruction: AND_A5, byteLength: 1)
        baseInstructions[0xa6] = CPUInstruction(name: "AND (HL)", opcode: 0xa6, instruction: AND_A6, byteLength: 1)
        baseInstructions[0xa7] = CPUInstruction(name: "AND A", opcode: 0xa7, instruction: AND_A7, byteLength: 1)
        baseInstructions[0xa8] = CPUInstruction(name: "XOR B", opcode: 0xa8, instruction: XOR_A8, byteLength: 1)
        baseInstructions[0xa9] = CPUInstruction(name: "XOR C", opcode: 0xa9, instruction: XOR_A9, byteLength: 1)
        baseInstructions[0xaa] = CPUInstruction(name: "XOR D", opcode: 0xaa, instruction: XOR_AA, byteLength: 1)
        baseInstructions[0xab] = CPUInstruction(name: "XOR E", opcode: 0xab, instruction: XOR_AB, byteLength: 1)
        baseInstructions[0xac] = CPUInstruction(name: "XOR H", opcode: 0xac, instruction: XOR_AC, byteLength: 1)
        baseInstructions[0xad] = CPUInstruction(name: "XOR L", opcode: 0xad, instruction: XOR_AD, byteLength: 1)
        baseInstructions[0xae] = CPUInstruction(name: "XOR (HL)", opcode: 0xae, instruction: XOR_AE, byteLength: 1)
        baseInstructions[0xaf] = CPUInstruction(name: "XOR A", opcode: 0xaf, instruction: XOR_AF, byteLength: 1)
        baseInstructions[0xb0] = CPUInstruction(name: "OR B", opcode: 0xb0, instruction: OR_B0, byteLength: 1)
        baseInstructions[0xb1] = CPUInstruction(name: "OR C", opcode: 0xb1, instruction: OR_B1, byteLength: 1)
        baseInstructions[0xb2] = CPUInstruction(name: "OR D", opcode: 0xb2, instruction: OR_B2, byteLength: 1)
        baseInstructions[0xb3] = CPUInstruction(name: "OR E", opcode: 0xb3, instruction: OR_B3, byteLength: 1)
        baseInstructions[0xb4] = CPUInstruction(name: "OR H", opcode: 0xb4, instruction: OR_B4, byteLength: 1)
        baseInstructions[0xb5] = CPUInstruction(name: "OR L", opcode: 0xb5, instruction: OR_B5, byteLength: 1)
        baseInstructions[0xb6] = CPUInstruction(name: "OR (HL)", opcode: 0xb6, instruction: OR_B6, byteLength: 1)
        baseInstructions[0xb7] = CPUInstruction(name: "OR A", opcode: 0xb7, instruction: OR_B7, byteLength: 1)
        baseInstructions[0xb8] = CPUInstruction(name: "CP B", opcode: 0xb8, instruction: CP_B8, byteLength: 1)
        baseInstructions[0xb9] = CPUInstruction(name: "CP C", opcode: 0xb9, instruction: CP_B9, byteLength: 1)
        baseInstructions[0xba] = CPUInstruction(name: "CP D", opcode: 0xba, instruction: CP_BA, byteLength: 1)
        baseInstructions[0xbb] = CPUInstruction(name: "CP E", opcode: 0xbb, instruction: CP_BB, byteLength: 1)
        baseInstructions[0xbc] = CPUInstruction(name: "CP H", opcode: 0xbc, instruction: CP_BC, byteLength: 1)
        baseInstructions[0xbd] = CPUInstruction(name: "CP L", opcode: 0xbd, instruction: CP_BD, byteLength: 1)
        baseInstructions[0xbe] = CPUInstruction(name: "CP (HL)", opcode: 0xbe, instruction: CP_BE, byteLength: 1)
        baseInstructions[0xbf] = CPUInstruction(name: "CP A", opcode: 0xbf, instruction: CP_BF, byteLength: 1)
        baseInstructions[0xc0] = CPUInstruction(name: "RET NZ", opcode: 0xc0, instruction: RET_C0, byteLength: 1)
        baseInstructions[0xc1] = CPUInstruction(name: "POP BC", opcode: 0xc1, instruction: POP_C1, byteLength: 1)
        baseInstructions[0xc2] = CPUInstruction(name: "JP NZ,a16", opcode: 0xc2, instruction: JP_C2, byteLength: 3)
        baseInstructions[0xc3] = CPUInstruction(name: "JP a16", opcode: 0xc3, instruction: JP_C3, byteLength: 3)
        baseInstructions[0xc4] = CPUInstruction(name: "CALL NZ,a16", opcode: 0xc4, instruction: CALL_C4, byteLength: 3)
        baseInstructions[0xc5] = CPUInstruction(name: "PUSH BC", opcode: 0xc5, instruction: PUSH_C5, byteLength: 1)
        baseInstructions[0xc6] = CPUInstruction(name: "ADD A,d8", opcode: 0xc6, instruction: ADD_C6, byteLength: 2)
        baseInstructions[0xc7] = CPUInstruction(name: "RST 00H", opcode: 0xc7, instruction: RST_C7, byteLength: 1)
        baseInstructions[0xc8] = CPUInstruction(name: "RET Z", opcode: 0xc8, instruction: RET_C8, byteLength: 1)
        baseInstructions[0xc9] = CPUInstruction(name: "RET", opcode: 0xc9, instruction: RET_C9, byteLength: 1)
        baseInstructions[0xca] = CPUInstruction(name: "JP Z,a16", opcode: 0xca, instruction: JP_CA, byteLength: 3)
        baseInstructions[0xcb] = CPUInstruction(name: "PREFIX CB", opcode: 0xcb, instruction: PREFIX_CB, byteLength: 1)
        baseInstructions[0xcc] = CPUInstruction(name: "CALL Z,a16", opcode: 0xcc, instruction: CALL_CC, byteLength: 3)
        baseInstructions[0xcd] = CPUInstruction(name: "CALL a16", opcode: 0xcd, instruction: CALL_CD, byteLength: 3)
        baseInstructions[0xce] = CPUInstruction(name: "ADC A,d8", opcode: 0xce, instruction: ADC_CE, byteLength: 2)
        baseInstructions[0xcf] = CPUInstruction(name: "RST 08H", opcode: 0xcf, instruction: RST_CF, byteLength: 1)
        baseInstructions[0xd0] = CPUInstruction(name: "RET NC", opcode: 0xd0, instruction: RET_D0, byteLength: 1)
        baseInstructions[0xd1] = CPUInstruction(name: "POP DE", opcode: 0xd1, instruction: POP_D1, byteLength: 1)
        baseInstructions[0xd2] = CPUInstruction(name: "JP NC,a16", opcode: 0xd2, instruction: JP_D2, byteLength: 3)
        baseInstructions[0xd4] = CPUInstruction(name: "CALL NC,a16", opcode: 0xd4, instruction: CALL_D4, byteLength: 3)
        baseInstructions[0xd5] = CPUInstruction(name: "PUSH DE", opcode: 0xd5, instruction: PUSH_D5, byteLength: 1)
        baseInstructions[0xd6] = CPUInstruction(name: "SUB d8", opcode: 0xd6, instruction: SUB_D6, byteLength: 2)
        baseInstructions[0xd7] = CPUInstruction(name: "RST 10H", opcode: 0xd7, instruction: RST_D7, byteLength: 1)
        baseInstructions[0xd8] = CPUInstruction(name: "RET C", opcode: 0xd8, instruction: RET_D8, byteLength: 1)
        baseInstructions[0xd9] = CPUInstruction(name: "RETI", opcode: 0xd9, instruction: RETI_D9, byteLength: 1)
        baseInstructions[0xda] = CPUInstruction(name: "JP C,a16", opcode: 0xda, instruction: JP_DA, byteLength: 3)
        baseInstructions[0xdc] = CPUInstruction(name: "CALL C,a16", opcode: 0xdc, instruction: CALL_DC, byteLength: 3)
        baseInstructions[0xde] = CPUInstruction(name: "SBC A,d8", opcode: 0xde, instruction: SBC_DE, byteLength: 2)
        baseInstructions[0xdf] = CPUInstruction(name: "RST 18H", opcode: 0xdf, instruction: RST_DF, byteLength: 1)
        baseInstructions[0xe0] = CPUInstruction(name: "LDH (a8),A", opcode: 0xe0, instruction: LDH_E0, byteLength: 2)
        baseInstructions[0xe1] = CPUInstruction(name: "POP HL", opcode: 0xe1, instruction: POP_E1, byteLength: 1)
        baseInstructions[0xe2] = CPUInstruction(name: "LD (C),A", opcode: 0xe2, instruction: LD_E2, byteLength: 2)
        baseInstructions[0xe5] = CPUInstruction(name: "PUSH HL", opcode: 0xe5, instruction: PUSH_E5, byteLength: 1)
        baseInstructions[0xe6] = CPUInstruction(name: "AND d8", opcode: 0xe6, instruction: AND_E6, byteLength: 2)
        baseInstructions[0xe7] = CPUInstruction(name: "RST 20H", opcode: 0xe7, instruction: RST_E7, byteLength: 1)
        baseInstructions[0xe8] = CPUInstruction(name: "ADD SP,r8", opcode: 0xe8, instruction: ADD_E8, byteLength: 2)
        baseInstructions[0xe9] = CPUInstruction(name: "JP (HL)", opcode: 0xe9, instruction: JP_E9, byteLength: 1)
        baseInstructions[0xea] = CPUInstruction(name: "LD (a16),A", opcode: 0xea, instruction: LD_EA, byteLength: 3)
        baseInstructions[0xee] = CPUInstruction(name: "XOR d8", opcode: 0xee, instruction: XOR_EE, byteLength: 2)
        baseInstructions[0xef] = CPUInstruction(name: "RST 28H", opcode: 0xef, instruction: RST_EF, byteLength: 1)
        baseInstructions[0xf0] = CPUInstruction(name: "LDH A,(a8)", opcode: 0xf0, instruction: LDH_F0, byteLength: 2)
        baseInstructions[0xf1] = CPUInstruction(name: "POP AF", opcode: 0xf1, instruction: POP_F1, byteLength: 1)
        baseInstructions[0xf2] = CPUInstruction(name: "LD A,(C)", opcode: 0xf2, instruction: LD_F2, byteLength: 2)
        baseInstructions[0xf3] = CPUInstruction(name: "DI", opcode: 0xf3, instruction: DI_F3, byteLength: 1)
        baseInstructions[0xf5] = CPUInstruction(name: "PUSH AF", opcode: 0xf5, instruction: PUSH_F5, byteLength: 1)
        baseInstructions[0xf6] = CPUInstruction(name: "OR d8", opcode: 0xf6, instruction: OR_F6, byteLength: 2)
        baseInstructions[0xf7] = CPUInstruction(name: "RST 30H", opcode: 0xf7, instruction: RST_F7, byteLength: 1)
        baseInstructions[0xf8] = CPUInstruction(name: "LD HL,SP+r8", opcode: 0xf8, instruction: LD_F8, byteLength: 2)
        baseInstructions[0xf9] = CPUInstruction(name: "LD SP,HL", opcode: 0xf9, instruction: LD_F9, byteLength: 1)
        baseInstructions[0xfa] = CPUInstruction(name: "LD A,(a16)", opcode: 0xfa, instruction: LD_FA, byteLength: 3)
        baseInstructions[0xfb] = CPUInstruction(name: "EI", opcode: 0xfb, instruction: EI_FB, byteLength: 1)
        baseInstructions[0xfe] = CPUInstruction(name: "CP d8", opcode: 0xfe, instruction: CP_FE, byteLength: 2)
        baseInstructions[0xff] = CPUInstruction(name: "RST 38H", opcode: 0xff, instruction: RST_FF, byteLength: 1)
        cbInstructions[0x00] = CPUInstruction(name: "RLC B", opcode: 0x00, instruction: RLC_00, byteLength: 2)
        cbInstructions[0x01] = CPUInstruction(name: "RLC C", opcode: 0x01, instruction: RLC_01, byteLength: 2)
        cbInstructions[0x02] = CPUInstruction(name: "RLC D", opcode: 0x02, instruction: RLC_02, byteLength: 2)
        cbInstructions[0x03] = CPUInstruction(name: "RLC E", opcode: 0x03, instruction: RLC_03, byteLength: 2)
        cbInstructions[0x04] = CPUInstruction(name: "RLC H", opcode: 0x04, instruction: RLC_04, byteLength: 2)
        cbInstructions[0x05] = CPUInstruction(name: "RLC L", opcode: 0x05, instruction: RLC_05, byteLength: 2)
        cbInstructions[0x06] = CPUInstruction(name: "RLC (HL)", opcode: 0x06, instruction: RLC_06, byteLength: 2)
        cbInstructions[0x07] = CPUInstruction(name: "RLC A", opcode: 0x07, instruction: RLC_07, byteLength: 2)
        cbInstructions[0x08] = CPUInstruction(name: "RRC B", opcode: 0x08, instruction: RRC_08, byteLength: 2)
        cbInstructions[0x09] = CPUInstruction(name: "RRC C", opcode: 0x09, instruction: RRC_09, byteLength: 2)
        cbInstructions[0x0a] = CPUInstruction(name: "RRC D", opcode: 0x0a, instruction: RRC_0A, byteLength: 2)
        cbInstructions[0x0b] = CPUInstruction(name: "RRC E", opcode: 0x0b, instruction: RRC_0B, byteLength: 2)
        cbInstructions[0x0c] = CPUInstruction(name: "RRC H", opcode: 0x0c, instruction: RRC_0C, byteLength: 2)
        cbInstructions[0x0d] = CPUInstruction(name: "RRC L", opcode: 0x0d, instruction: RRC_0D, byteLength: 2)
        cbInstructions[0x0e] = CPUInstruction(name: "RRC (HL)", opcode: 0x0e, instruction: RRC_0E, byteLength: 2)
        cbInstructions[0x0f] = CPUInstruction(name: "RRC A", opcode: 0x0f, instruction: RRC_0F, byteLength: 2)
        cbInstructions[0x10] = CPUInstruction(name: "RL B", opcode: 0x10, instruction: RL_10, byteLength: 2)
        cbInstructions[0x11] = CPUInstruction(name: "RL C", opcode: 0x11, instruction: RL_11, byteLength: 2)
        cbInstructions[0x12] = CPUInstruction(name: "RL D", opcode: 0x12, instruction: RL_12, byteLength: 2)
        cbInstructions[0x13] = CPUInstruction(name: "RL E", opcode: 0x13, instruction: RL_13, byteLength: 2)
        cbInstructions[0x14] = CPUInstruction(name: "RL H", opcode: 0x14, instruction: RL_14, byteLength: 2)
        cbInstructions[0x15] = CPUInstruction(name: "RL L", opcode: 0x15, instruction: RL_15, byteLength: 2)
        cbInstructions[0x16] = CPUInstruction(name: "RL (HL)", opcode: 0x16, instruction: RL_16, byteLength: 2)
        cbInstructions[0x17] = CPUInstruction(name: "RL A", opcode: 0x17, instruction: RL_17, byteLength: 2)
        cbInstructions[0x18] = CPUInstruction(name: "RR B", opcode: 0x18, instruction: RR_18, byteLength: 2)
        cbInstructions[0x19] = CPUInstruction(name: "RR C", opcode: 0x19, instruction: RR_19, byteLength: 2)
        cbInstructions[0x1a] = CPUInstruction(name: "RR D", opcode: 0x1a, instruction: RR_1A, byteLength: 2)
        cbInstructions[0x1b] = CPUInstruction(name: "RR E", opcode: 0x1b, instruction: RR_1B, byteLength: 2)
        cbInstructions[0x1c] = CPUInstruction(name: "RR H", opcode: 0x1c, instruction: RR_1C, byteLength: 2)
        cbInstructions[0x1d] = CPUInstruction(name: "RR L", opcode: 0x1d, instruction: RR_1D, byteLength: 2)
        cbInstructions[0x1e] = CPUInstruction(name: "RR (HL)", opcode: 0x1e, instruction: RR_1E, byteLength: 2)
        cbInstructions[0x1f] = CPUInstruction(name: "RR A", opcode: 0x1f, instruction: RR_1F, byteLength: 2)
        cbInstructions[0x20] = CPUInstruction(name: "SLA B", opcode: 0x20, instruction: SLA_20, byteLength: 2)
        cbInstructions[0x21] = CPUInstruction(name: "SLA C", opcode: 0x21, instruction: SLA_21, byteLength: 2)
        cbInstructions[0x22] = CPUInstruction(name: "SLA D", opcode: 0x22, instruction: SLA_22, byteLength: 2)
        cbInstructions[0x23] = CPUInstruction(name: "SLA E", opcode: 0x23, instruction: SLA_23, byteLength: 2)
        cbInstructions[0x24] = CPUInstruction(name: "SLA H", opcode: 0x24, instruction: SLA_24, byteLength: 2)
        cbInstructions[0x25] = CPUInstruction(name: "SLA L", opcode: 0x25, instruction: SLA_25, byteLength: 2)
        cbInstructions[0x26] = CPUInstruction(name: "SLA (HL)", opcode: 0x26, instruction: SLA_26, byteLength: 2)
        cbInstructions[0x27] = CPUInstruction(name: "SLA A", opcode: 0x27, instruction: SLA_27, byteLength: 2)
        cbInstructions[0x28] = CPUInstruction(name: "SRA B", opcode: 0x28, instruction: SRA_28, byteLength: 2)
        cbInstructions[0x29] = CPUInstruction(name: "SRA C", opcode: 0x29, instruction: SRA_29, byteLength: 2)
        cbInstructions[0x2a] = CPUInstruction(name: "SRA D", opcode: 0x2a, instruction: SRA_2A, byteLength: 2)
        cbInstructions[0x2b] = CPUInstruction(name: "SRA E", opcode: 0x2b, instruction: SRA_2B, byteLength: 2)
        cbInstructions[0x2c] = CPUInstruction(name: "SRA H", opcode: 0x2c, instruction: SRA_2C, byteLength: 2)
        cbInstructions[0x2d] = CPUInstruction(name: "SRA L", opcode: 0x2d, instruction: SRA_2D, byteLength: 2)
        cbInstructions[0x2e] = CPUInstruction(name: "SRA (HL)", opcode: 0x2e, instruction: SRA_2E, byteLength: 2)
        cbInstructions[0x2f] = CPUInstruction(name: "SRA A", opcode: 0x2f, instruction: SRA_2F, byteLength: 2)
        cbInstructions[0x30] = CPUInstruction(name: "SWAP B", opcode: 0x30, instruction: SWAP_30, byteLength: 2)
        cbInstructions[0x31] = CPUInstruction(name: "SWAP C", opcode: 0x31, instruction: SWAP_31, byteLength: 2)
        cbInstructions[0x32] = CPUInstruction(name: "SWAP D", opcode: 0x32, instruction: SWAP_32, byteLength: 2)
        cbInstructions[0x33] = CPUInstruction(name: "SWAP E", opcode: 0x33, instruction: SWAP_33, byteLength: 2)
        cbInstructions[0x34] = CPUInstruction(name: "SWAP H", opcode: 0x34, instruction: SWAP_34, byteLength: 2)
        cbInstructions[0x35] = CPUInstruction(name: "SWAP L", opcode: 0x35, instruction: SWAP_35, byteLength: 2)
        cbInstructions[0x36] = CPUInstruction(name: "SWAP (HL)", opcode: 0x36, instruction: SWAP_36, byteLength: 2)
        cbInstructions[0x37] = CPUInstruction(name: "SWAP A", opcode: 0x37, instruction: SWAP_37, byteLength: 2)
        cbInstructions[0x38] = CPUInstruction(name: "SRL B", opcode: 0x38, instruction: SRL_38, byteLength: 2)
        cbInstructions[0x39] = CPUInstruction(name: "SRL C", opcode: 0x39, instruction: SRL_39, byteLength: 2)
        cbInstructions[0x3a] = CPUInstruction(name: "SRL D", opcode: 0x3a, instruction: SRL_3A, byteLength: 2)
        cbInstructions[0x3b] = CPUInstruction(name: "SRL E", opcode: 0x3b, instruction: SRL_3B, byteLength: 2)
        cbInstructions[0x3c] = CPUInstruction(name: "SRL H", opcode: 0x3c, instruction: SRL_3C, byteLength: 2)
        cbInstructions[0x3d] = CPUInstruction(name: "SRL L", opcode: 0x3d, instruction: SRL_3D, byteLength: 2)
        cbInstructions[0x3e] = CPUInstruction(name: "SRL (HL)", opcode: 0x3e, instruction: SRL_3E, byteLength: 2)
        cbInstructions[0x3f] = CPUInstruction(name: "SRL A", opcode: 0x3f, instruction: SRL_3F, byteLength: 2)
        cbInstructions[0x40] = CPUInstruction(name: "BIT 0,B", opcode: 0x40, instruction: BIT_40, byteLength: 2)
        cbInstructions[0x41] = CPUInstruction(name: "BIT 0,C", opcode: 0x41, instruction: BIT_41, byteLength: 2)
        cbInstructions[0x42] = CPUInstruction(name: "BIT 0,D", opcode: 0x42, instruction: BIT_42, byteLength: 2)
        cbInstructions[0x43] = CPUInstruction(name: "BIT 0,E", opcode: 0x43, instruction: BIT_43, byteLength: 2)
        cbInstructions[0x44] = CPUInstruction(name: "BIT 0,H", opcode: 0x44, instruction: BIT_44, byteLength: 2)
        cbInstructions[0x45] = CPUInstruction(name: "BIT 0,L", opcode: 0x45, instruction: BIT_45, byteLength: 2)
        cbInstructions[0x46] = CPUInstruction(name: "BIT 0,(HL)", opcode: 0x46, instruction: BIT_46, byteLength: 2)
        cbInstructions[0x47] = CPUInstruction(name: "BIT 0,A", opcode: 0x47, instruction: BIT_47, byteLength: 2)
        cbInstructions[0x48] = CPUInstruction(name: "BIT 1,B", opcode: 0x48, instruction: BIT_48, byteLength: 2)
        cbInstructions[0x49] = CPUInstruction(name: "BIT 1,C", opcode: 0x49, instruction: BIT_49, byteLength: 2)
        cbInstructions[0x4a] = CPUInstruction(name: "BIT 1,D", opcode: 0x4a, instruction: BIT_4A, byteLength: 2)
        cbInstructions[0x4b] = CPUInstruction(name: "BIT 1,E", opcode: 0x4b, instruction: BIT_4B, byteLength: 2)
        cbInstructions[0x4c] = CPUInstruction(name: "BIT 1,H", opcode: 0x4c, instruction: BIT_4C, byteLength: 2)
        cbInstructions[0x4d] = CPUInstruction(name: "BIT 1,L", opcode: 0x4d, instruction: BIT_4D, byteLength: 2)
        cbInstructions[0x4e] = CPUInstruction(name: "BIT 1,(HL)", opcode: 0x4e, instruction: BIT_4E, byteLength: 2)
        cbInstructions[0x4f] = CPUInstruction(name: "BIT 1,A", opcode: 0x4f, instruction: BIT_4F, byteLength: 2)
        cbInstructions[0x50] = CPUInstruction(name: "BIT 2,B", opcode: 0x50, instruction: BIT_50, byteLength: 2)
        cbInstructions[0x51] = CPUInstruction(name: "BIT 2,C", opcode: 0x51, instruction: BIT_51, byteLength: 2)
        cbInstructions[0x52] = CPUInstruction(name: "BIT 2,D", opcode: 0x52, instruction: BIT_52, byteLength: 2)
        cbInstructions[0x53] = CPUInstruction(name: "BIT 2,E", opcode: 0x53, instruction: BIT_53, byteLength: 2)
        cbInstructions[0x54] = CPUInstruction(name: "BIT 2,H", opcode: 0x54, instruction: BIT_54, byteLength: 2)
        cbInstructions[0x55] = CPUInstruction(name: "BIT 2,L", opcode: 0x55, instruction: BIT_55, byteLength: 2)
        cbInstructions[0x56] = CPUInstruction(name: "BIT 2,(HL)", opcode: 0x56, instruction: BIT_56, byteLength: 2)
        cbInstructions[0x57] = CPUInstruction(name: "BIT 2,A", opcode: 0x57, instruction: BIT_57, byteLength: 2)
        cbInstructions[0x58] = CPUInstruction(name: "BIT 3,B", opcode: 0x58, instruction: BIT_58, byteLength: 2)
        cbInstructions[0x59] = CPUInstruction(name: "BIT 3,C", opcode: 0x59, instruction: BIT_59, byteLength: 2)
        cbInstructions[0x5a] = CPUInstruction(name: "BIT 3,D", opcode: 0x5a, instruction: BIT_5A, byteLength: 2)
        cbInstructions[0x5b] = CPUInstruction(name: "BIT 3,E", opcode: 0x5b, instruction: BIT_5B, byteLength: 2)
        cbInstructions[0x5c] = CPUInstruction(name: "BIT 3,H", opcode: 0x5c, instruction: BIT_5C, byteLength: 2)
        cbInstructions[0x5d] = CPUInstruction(name: "BIT 3,L", opcode: 0x5d, instruction: BIT_5D, byteLength: 2)
        cbInstructions[0x5e] = CPUInstruction(name: "BIT 3,(HL)", opcode: 0x5e, instruction: BIT_5E, byteLength: 2)
        cbInstructions[0x5f] = CPUInstruction(name: "BIT 3,A", opcode: 0x5f, instruction: BIT_5F, byteLength: 2)
        cbInstructions[0x60] = CPUInstruction(name: "BIT 4,B", opcode: 0x60, instruction: BIT_60, byteLength: 2)
        cbInstructions[0x61] = CPUInstruction(name: "BIT 4,C", opcode: 0x61, instruction: BIT_61, byteLength: 2)
        cbInstructions[0x62] = CPUInstruction(name: "BIT 4,D", opcode: 0x62, instruction: BIT_62, byteLength: 2)
        cbInstructions[0x63] = CPUInstruction(name: "BIT 4,E", opcode: 0x63, instruction: BIT_63, byteLength: 2)
        cbInstructions[0x64] = CPUInstruction(name: "BIT 4,H", opcode: 0x64, instruction: BIT_64, byteLength: 2)
        cbInstructions[0x65] = CPUInstruction(name: "BIT 4,L", opcode: 0x65, instruction: BIT_65, byteLength: 2)
        cbInstructions[0x66] = CPUInstruction(name: "BIT 4,(HL)", opcode: 0x66, instruction: BIT_66, byteLength: 2)
        cbInstructions[0x67] = CPUInstruction(name: "BIT 4,A", opcode: 0x67, instruction: BIT_67, byteLength: 2)
        cbInstructions[0x68] = CPUInstruction(name: "BIT 5,B", opcode: 0x68, instruction: BIT_68, byteLength: 2)
        cbInstructions[0x69] = CPUInstruction(name: "BIT 5,C", opcode: 0x69, instruction: BIT_69, byteLength: 2)
        cbInstructions[0x6a] = CPUInstruction(name: "BIT 5,D", opcode: 0x6a, instruction: BIT_6A, byteLength: 2)
        cbInstructions[0x6b] = CPUInstruction(name: "BIT 5,E", opcode: 0x6b, instruction: BIT_6B, byteLength: 2)
        cbInstructions[0x6c] = CPUInstruction(name: "BIT 5,H", opcode: 0x6c, instruction: BIT_6C, byteLength: 2)
        cbInstructions[0x6d] = CPUInstruction(name: "BIT 5,L", opcode: 0x6d, instruction: BIT_6D, byteLength: 2)
        cbInstructions[0x6e] = CPUInstruction(name: "BIT 5,(HL)", opcode: 0x6e, instruction: BIT_6E, byteLength: 2)
        cbInstructions[0x6f] = CPUInstruction(name: "BIT 5,A", opcode: 0x6f, instruction: BIT_6F, byteLength: 2)
        cbInstructions[0x70] = CPUInstruction(name: "BIT 6,B", opcode: 0x70, instruction: BIT_70, byteLength: 2)
        cbInstructions[0x71] = CPUInstruction(name: "BIT 6,C", opcode: 0x71, instruction: BIT_71, byteLength: 2)
        cbInstructions[0x72] = CPUInstruction(name: "BIT 6,D", opcode: 0x72, instruction: BIT_72, byteLength: 2)
        cbInstructions[0x73] = CPUInstruction(name: "BIT 6,E", opcode: 0x73, instruction: BIT_73, byteLength: 2)
        cbInstructions[0x74] = CPUInstruction(name: "BIT 6,H", opcode: 0x74, instruction: BIT_74, byteLength: 2)
        cbInstructions[0x75] = CPUInstruction(name: "BIT 6,L", opcode: 0x75, instruction: BIT_75, byteLength: 2)
        cbInstructions[0x76] = CPUInstruction(name: "BIT 6,(HL)", opcode: 0x76, instruction: BIT_76, byteLength: 2)
        cbInstructions[0x77] = CPUInstruction(name: "BIT 6,A", opcode: 0x77, instruction: BIT_77, byteLength: 2)
        cbInstructions[0x78] = CPUInstruction(name: "BIT 7,B", opcode: 0x78, instruction: BIT_78, byteLength: 2)
        cbInstructions[0x79] = CPUInstruction(name: "BIT 7,C", opcode: 0x79, instruction: BIT_79, byteLength: 2)
        cbInstructions[0x7a] = CPUInstruction(name: "BIT 7,D", opcode: 0x7a, instruction: BIT_7A, byteLength: 2)
        cbInstructions[0x7b] = CPUInstruction(name: "BIT 7,E", opcode: 0x7b, instruction: BIT_7B, byteLength: 2)
        cbInstructions[0x7c] = CPUInstruction(name: "BIT 7,H", opcode: 0x7c, instruction: BIT_7C, byteLength: 2)
        cbInstructions[0x7d] = CPUInstruction(name: "BIT 7,L", opcode: 0x7d, instruction: BIT_7D, byteLength: 2)
        cbInstructions[0x7e] = CPUInstruction(name: "BIT 7,(HL)", opcode: 0x7e, instruction: BIT_7E, byteLength: 2)
        cbInstructions[0x7f] = CPUInstruction(name: "BIT 7,A", opcode: 0x7f, instruction: BIT_7F, byteLength: 2)
        cbInstructions[0x80] = CPUInstruction(name: "RES 0,B", opcode: 0x80, instruction: RES_80, byteLength: 2)
        cbInstructions[0x81] = CPUInstruction(name: "RES 0,C", opcode: 0x81, instruction: RES_81, byteLength: 2)
        cbInstructions[0x82] = CPUInstruction(name: "RES 0,D", opcode: 0x82, instruction: RES_82, byteLength: 2)
        cbInstructions[0x83] = CPUInstruction(name: "RES 0,E", opcode: 0x83, instruction: RES_83, byteLength: 2)
        cbInstructions[0x84] = CPUInstruction(name: "RES 0,H", opcode: 0x84, instruction: RES_84, byteLength: 2)
        cbInstructions[0x85] = CPUInstruction(name: "RES 0,L", opcode: 0x85, instruction: RES_85, byteLength: 2)
        cbInstructions[0x86] = CPUInstruction(name: "RES 0,(HL)", opcode: 0x86, instruction: RES_86, byteLength: 2)
        cbInstructions[0x87] = CPUInstruction(name: "RES 0,A", opcode: 0x87, instruction: RES_87, byteLength: 2)
        cbInstructions[0x88] = CPUInstruction(name: "RES 1,B", opcode: 0x88, instruction: RES_88, byteLength: 2)
        cbInstructions[0x89] = CPUInstruction(name: "RES 1,C", opcode: 0x89, instruction: RES_89, byteLength: 2)
        cbInstructions[0x8a] = CPUInstruction(name: "RES 1,D", opcode: 0x8a, instruction: RES_8A, byteLength: 2)
        cbInstructions[0x8b] = CPUInstruction(name: "RES 1,E", opcode: 0x8b, instruction: RES_8B, byteLength: 2)
        cbInstructions[0x8c] = CPUInstruction(name: "RES 1,H", opcode: 0x8c, instruction: RES_8C, byteLength: 2)
        cbInstructions[0x8d] = CPUInstruction(name: "RES 1,L", opcode: 0x8d, instruction: RES_8D, byteLength: 2)
        cbInstructions[0x8e] = CPUInstruction(name: "RES 1,(HL)", opcode: 0x8e, instruction: RES_8E, byteLength: 2)
        cbInstructions[0x8f] = CPUInstruction(name: "RES 1,A", opcode: 0x8f, instruction: RES_8F, byteLength: 2)
        cbInstructions[0x90] = CPUInstruction(name: "RES 2,B", opcode: 0x90, instruction: RES_90, byteLength: 2)
        cbInstructions[0x91] = CPUInstruction(name: "RES 2,C", opcode: 0x91, instruction: RES_91, byteLength: 2)
        cbInstructions[0x92] = CPUInstruction(name: "RES 2,D", opcode: 0x92, instruction: RES_92, byteLength: 2)
        cbInstructions[0x93] = CPUInstruction(name: "RES 2,E", opcode: 0x93, instruction: RES_93, byteLength: 2)
        cbInstructions[0x94] = CPUInstruction(name: "RES 2,H", opcode: 0x94, instruction: RES_94, byteLength: 2)
        cbInstructions[0x95] = CPUInstruction(name: "RES 2,L", opcode: 0x95, instruction: RES_95, byteLength: 2)
        cbInstructions[0x96] = CPUInstruction(name: "RES 2,(HL)", opcode: 0x96, instruction: RES_96, byteLength: 2)
        cbInstructions[0x97] = CPUInstruction(name: "RES 2,A", opcode: 0x97, instruction: RES_97, byteLength: 2)
        cbInstructions[0x98] = CPUInstruction(name: "RES 3,B", opcode: 0x98, instruction: RES_98, byteLength: 2)
        cbInstructions[0x99] = CPUInstruction(name: "RES 3,C", opcode: 0x99, instruction: RES_99, byteLength: 2)
        cbInstructions[0x9a] = CPUInstruction(name: "RES 3,D", opcode: 0x9a, instruction: RES_9A, byteLength: 2)
        cbInstructions[0x9b] = CPUInstruction(name: "RES 3,E", opcode: 0x9b, instruction: RES_9B, byteLength: 2)
        cbInstructions[0x9c] = CPUInstruction(name: "RES 3,H", opcode: 0x9c, instruction: RES_9C, byteLength: 2)
        cbInstructions[0x9d] = CPUInstruction(name: "RES 3,L", opcode: 0x9d, instruction: RES_9D, byteLength: 2)
        cbInstructions[0x9e] = CPUInstruction(name: "RES 3,(HL)", opcode: 0x9e, instruction: RES_9E, byteLength: 2)
        cbInstructions[0x9f] = CPUInstruction(name: "RES 3,A", opcode: 0x9f, instruction: RES_9F, byteLength: 2)
        cbInstructions[0xa0] = CPUInstruction(name: "RES 4,B", opcode: 0xa0, instruction: RES_A0, byteLength: 2)
        cbInstructions[0xa1] = CPUInstruction(name: "RES 4,C", opcode: 0xa1, instruction: RES_A1, byteLength: 2)
        cbInstructions[0xa2] = CPUInstruction(name: "RES 4,D", opcode: 0xa2, instruction: RES_A2, byteLength: 2)
        cbInstructions[0xa3] = CPUInstruction(name: "RES 4,E", opcode: 0xa3, instruction: RES_A3, byteLength: 2)
        cbInstructions[0xa4] = CPUInstruction(name: "RES 4,H", opcode: 0xa4, instruction: RES_A4, byteLength: 2)
        cbInstructions[0xa5] = CPUInstruction(name: "RES 4,L", opcode: 0xa5, instruction: RES_A5, byteLength: 2)
        cbInstructions[0xa6] = CPUInstruction(name: "RES 4,(HL)", opcode: 0xa6, instruction: RES_A6, byteLength: 2)
        cbInstructions[0xa7] = CPUInstruction(name: "RES 4,A", opcode: 0xa7, instruction: RES_A7, byteLength: 2)
        cbInstructions[0xa8] = CPUInstruction(name: "RES 5,B", opcode: 0xa8, instruction: RES_A8, byteLength: 2)
        cbInstructions[0xa9] = CPUInstruction(name: "RES 5,C", opcode: 0xa9, instruction: RES_A9, byteLength: 2)
        cbInstructions[0xaa] = CPUInstruction(name: "RES 5,D", opcode: 0xaa, instruction: RES_AA, byteLength: 2)
        cbInstructions[0xab] = CPUInstruction(name: "RES 5,E", opcode: 0xab, instruction: RES_AB, byteLength: 2)
        cbInstructions[0xac] = CPUInstruction(name: "RES 5,H", opcode: 0xac, instruction: RES_AC, byteLength: 2)
        cbInstructions[0xad] = CPUInstruction(name: "RES 5,L", opcode: 0xad, instruction: RES_AD, byteLength: 2)
        cbInstructions[0xae] = CPUInstruction(name: "RES 5,(HL)", opcode: 0xae, instruction: RES_AE, byteLength: 2)
        cbInstructions[0xaf] = CPUInstruction(name: "RES 5,A", opcode: 0xaf, instruction: RES_AF, byteLength: 2)
        cbInstructions[0xb0] = CPUInstruction(name: "RES 6,B", opcode: 0xb0, instruction: RES_B0, byteLength: 2)
        cbInstructions[0xb1] = CPUInstruction(name: "RES 6,C", opcode: 0xb1, instruction: RES_B1, byteLength: 2)
        cbInstructions[0xb2] = CPUInstruction(name: "RES 6,D", opcode: 0xb2, instruction: RES_B2, byteLength: 2)
        cbInstructions[0xb3] = CPUInstruction(name: "RES 6,E", opcode: 0xb3, instruction: RES_B3, byteLength: 2)
        cbInstructions[0xb4] = CPUInstruction(name: "RES 6,H", opcode: 0xb4, instruction: RES_B4, byteLength: 2)
        cbInstructions[0xb5] = CPUInstruction(name: "RES 6,L", opcode: 0xb5, instruction: RES_B5, byteLength: 2)
        cbInstructions[0xb6] = CPUInstruction(name: "RES 6,(HL)", opcode: 0xb6, instruction: RES_B6, byteLength: 2)
        cbInstructions[0xb7] = CPUInstruction(name: "RES 6,A", opcode: 0xb7, instruction: RES_B7, byteLength: 2)
        cbInstructions[0xb8] = CPUInstruction(name: "RES 7,B", opcode: 0xb8, instruction: RES_B8, byteLength: 2)
        cbInstructions[0xb9] = CPUInstruction(name: "RES 7,C", opcode: 0xb9, instruction: RES_B9, byteLength: 2)
        cbInstructions[0xba] = CPUInstruction(name: "RES 7,D", opcode: 0xba, instruction: RES_BA, byteLength: 2)
        cbInstructions[0xbb] = CPUInstruction(name: "RES 7,E", opcode: 0xbb, instruction: RES_BB, byteLength: 2)
        cbInstructions[0xbc] = CPUInstruction(name: "RES 7,H", opcode: 0xbc, instruction: RES_BC, byteLength: 2)
        cbInstructions[0xbd] = CPUInstruction(name: "RES 7,L", opcode: 0xbd, instruction: RES_BD, byteLength: 2)
        cbInstructions[0xbe] = CPUInstruction(name: "RES 7,(HL)", opcode: 0xbe, instruction: RES_BE, byteLength: 2)
        cbInstructions[0xbf] = CPUInstruction(name: "RES 7,A", opcode: 0xbf, instruction: RES_BF, byteLength: 2)
        cbInstructions[0xc0] = CPUInstruction(name: "SET 0,B", opcode: 0xc0, instruction: SET_C0, byteLength: 2)
        cbInstructions[0xc1] = CPUInstruction(name: "SET 0,C", opcode: 0xc1, instruction: SET_C1, byteLength: 2)
        cbInstructions[0xc2] = CPUInstruction(name: "SET 0,D", opcode: 0xc2, instruction: SET_C2, byteLength: 2)
        cbInstructions[0xc3] = CPUInstruction(name: "SET 0,E", opcode: 0xc3, instruction: SET_C3, byteLength: 2)
        cbInstructions[0xc4] = CPUInstruction(name: "SET 0,H", opcode: 0xc4, instruction: SET_C4, byteLength: 2)
        cbInstructions[0xc5] = CPUInstruction(name: "SET 0,L", opcode: 0xc5, instruction: SET_C5, byteLength: 2)
        cbInstructions[0xc6] = CPUInstruction(name: "SET 0,(HL)", opcode: 0xc6, instruction: SET_C6, byteLength: 2)
        cbInstructions[0xc7] = CPUInstruction(name: "SET 0,A", opcode: 0xc7, instruction: SET_C7, byteLength: 2)
        cbInstructions[0xc8] = CPUInstruction(name: "SET 1,B", opcode: 0xc8, instruction: SET_C8, byteLength: 2)
        cbInstructions[0xc9] = CPUInstruction(name: "SET 1,C", opcode: 0xc9, instruction: SET_C9, byteLength: 2)
        cbInstructions[0xca] = CPUInstruction(name: "SET 1,D", opcode: 0xca, instruction: SET_CA, byteLength: 2)
        cbInstructions[0xcb] = CPUInstruction(name: "SET 1,E", opcode: 0xcb, instruction: SET_CB, byteLength: 2)
        cbInstructions[0xcc] = CPUInstruction(name: "SET 1,H", opcode: 0xcc, instruction: SET_CC, byteLength: 2)
        cbInstructions[0xcd] = CPUInstruction(name: "SET 1,L", opcode: 0xcd, instruction: SET_CD, byteLength: 2)
        cbInstructions[0xce] = CPUInstruction(name: "SET 1,(HL)", opcode: 0xce, instruction: SET_CE, byteLength: 2)
        cbInstructions[0xcf] = CPUInstruction(name: "SET 1,A", opcode: 0xcf, instruction: SET_CF, byteLength: 2)
        cbInstructions[0xd0] = CPUInstruction(name: "SET 2,B", opcode: 0xd0, instruction: SET_D0, byteLength: 2)
        cbInstructions[0xd1] = CPUInstruction(name: "SET 2,C", opcode: 0xd1, instruction: SET_D1, byteLength: 2)
        cbInstructions[0xd2] = CPUInstruction(name: "SET 2,D", opcode: 0xd2, instruction: SET_D2, byteLength: 2)
        cbInstructions[0xd3] = CPUInstruction(name: "SET 2,E", opcode: 0xd3, instruction: SET_D3, byteLength: 2)
        cbInstructions[0xd4] = CPUInstruction(name: "SET 2,H", opcode: 0xd4, instruction: SET_D4, byteLength: 2)
        cbInstructions[0xd5] = CPUInstruction(name: "SET 2,L", opcode: 0xd5, instruction: SET_D5, byteLength: 2)
        cbInstructions[0xd6] = CPUInstruction(name: "SET 2,(HL)", opcode: 0xd6, instruction: SET_D6, byteLength: 2)
        cbInstructions[0xd7] = CPUInstruction(name: "SET 2,A", opcode: 0xd7, instruction: SET_D7, byteLength: 2)
        cbInstructions[0xd8] = CPUInstruction(name: "SET 3,B", opcode: 0xd8, instruction: SET_D8, byteLength: 2)
        cbInstructions[0xd9] = CPUInstruction(name: "SET 3,C", opcode: 0xd9, instruction: SET_D9, byteLength: 2)
        cbInstructions[0xda] = CPUInstruction(name: "SET 3,D", opcode: 0xda, instruction: SET_DA, byteLength: 2)
        cbInstructions[0xdb] = CPUInstruction(name: "SET 3,E", opcode: 0xdb, instruction: SET_DB, byteLength: 2)
        cbInstructions[0xdc] = CPUInstruction(name: "SET 3,H", opcode: 0xdc, instruction: SET_DC, byteLength: 2)
        cbInstructions[0xdd] = CPUInstruction(name: "SET 3,L", opcode: 0xdd, instruction: SET_DD, byteLength: 2)
        cbInstructions[0xde] = CPUInstruction(name: "SET 3,(HL)", opcode: 0xde, instruction: SET_DE, byteLength: 2)
        cbInstructions[0xdf] = CPUInstruction(name: "SET 3,A", opcode: 0xdf, instruction: SET_DF, byteLength: 2)
        cbInstructions[0xe0] = CPUInstruction(name: "SET 4,B", opcode: 0xe0, instruction: SET_E0, byteLength: 2)
        cbInstructions[0xe1] = CPUInstruction(name: "SET 4,C", opcode: 0xe1, instruction: SET_E1, byteLength: 2)
        cbInstructions[0xe2] = CPUInstruction(name: "SET 4,D", opcode: 0xe2, instruction: SET_E2, byteLength: 2)
        cbInstructions[0xe3] = CPUInstruction(name: "SET 4,E", opcode: 0xe3, instruction: SET_E3, byteLength: 2)
        cbInstructions[0xe4] = CPUInstruction(name: "SET 4,H", opcode: 0xe4, instruction: SET_E4, byteLength: 2)
        cbInstructions[0xe5] = CPUInstruction(name: "SET 4,L", opcode: 0xe5, instruction: SET_E5, byteLength: 2)
        cbInstructions[0xe6] = CPUInstruction(name: "SET 4,(HL)", opcode: 0xe6, instruction: SET_E6, byteLength: 2)
        cbInstructions[0xe7] = CPUInstruction(name: "SET 4,A", opcode: 0xe7, instruction: SET_E7, byteLength: 2)
        cbInstructions[0xe8] = CPUInstruction(name: "SET 5,B", opcode: 0xe8, instruction: SET_E8, byteLength: 2)
        cbInstructions[0xe9] = CPUInstruction(name: "SET 5,C", opcode: 0xe9, instruction: SET_E9, byteLength: 2)
        cbInstructions[0xea] = CPUInstruction(name: "SET 5,D", opcode: 0xea, instruction: SET_EA, byteLength: 2)
        cbInstructions[0xeb] = CPUInstruction(name: "SET 5,E", opcode: 0xeb, instruction: SET_EB, byteLength: 2)
        cbInstructions[0xec] = CPUInstruction(name: "SET 5,H", opcode: 0xec, instruction: SET_EC, byteLength: 2)
        cbInstructions[0xed] = CPUInstruction(name: "SET 5,L", opcode: 0xed, instruction: SET_ED, byteLength: 2)
        cbInstructions[0xee] = CPUInstruction(name: "SET 5,(HL)", opcode: 0xee, instruction: SET_EE, byteLength: 2)
        cbInstructions[0xef] = CPUInstruction(name: "SET 5,A", opcode: 0xef, instruction: SET_EF, byteLength: 2)
        cbInstructions[0xf0] = CPUInstruction(name: "SET 6,B", opcode: 0xf0, instruction: SET_F0, byteLength: 2)
        cbInstructions[0xf1] = CPUInstruction(name: "SET 6,C", opcode: 0xf1, instruction: SET_F1, byteLength: 2)
        cbInstructions[0xf2] = CPUInstruction(name: "SET 6,D", opcode: 0xf2, instruction: SET_F2, byteLength: 2)
        cbInstructions[0xf3] = CPUInstruction(name: "SET 6,E", opcode: 0xf3, instruction: SET_F3, byteLength: 2)
        cbInstructions[0xf4] = CPUInstruction(name: "SET 6,H", opcode: 0xf4, instruction: SET_F4, byteLength: 2)
        cbInstructions[0xf5] = CPUInstruction(name: "SET 6,L", opcode: 0xf5, instruction: SET_F5, byteLength: 2)
        cbInstructions[0xf6] = CPUInstruction(name: "SET 6,(HL)", opcode: 0xf6, instruction: SET_F6, byteLength: 2)
        cbInstructions[0xf7] = CPUInstruction(name: "SET 6,A", opcode: 0xf7, instruction: SET_F7, byteLength: 2)
        cbInstructions[0xf8] = CPUInstruction(name: "SET 7,B", opcode: 0xf8, instruction: SET_F8, byteLength: 2)
        cbInstructions[0xf9] = CPUInstruction(name: "SET 7,C", opcode: 0xf9, instruction: SET_F9, byteLength: 2)
        cbInstructions[0xfa] = CPUInstruction(name: "SET 7,D", opcode: 0xfa, instruction: SET_FA, byteLength: 2)
        cbInstructions[0xfb] = CPUInstruction(name: "SET 7,E", opcode: 0xfb, instruction: SET_FB, byteLength: 2)
        cbInstructions[0xfc] = CPUInstruction(name: "SET 7,H", opcode: 0xfc, instruction: SET_FC, byteLength: 2)
        cbInstructions[0xfd] = CPUInstruction(name: "SET 7,L", opcode: 0xfd, instruction: SET_FD, byteLength: 2)
        cbInstructions[0xfe] = CPUInstruction(name: "SET 7,(HL)", opcode: 0xfe, instruction: SET_FE, byteLength: 2)
        cbInstructions[0xff] = CPUInstruction(name: "SET 7,A", opcode: 0xff, instruction: SET_FF, byteLength: 2)
    }
    
}
