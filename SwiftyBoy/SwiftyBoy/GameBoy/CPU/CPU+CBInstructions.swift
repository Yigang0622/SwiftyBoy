import Foundation

extension CPU {
    
    // 0x00 RLC B
    func RLC_00() -> Int {
        _rlc(reg: .b)
        pc += 2
        return 8
    }
    // 0x01 RLC C
    func RLC_01() -> Int {
        _rlc(reg: .c)
        pc += 2
        return 8
    }
    // 0x02 RLC D
    func RLC_02() -> Int {
        _rlc(reg: .d)
        pc += 2
        return 8
    }
    // 0x03 RLC E
    func RLC_03() -> Int {
        _rlc(reg: .e)
        pc += 2
        return 8
    }
    // 0x04 RLC H
    func RLC_04() -> Int {
        _rlc(reg: .h)
        pc += 2
        return 8
    }
    // 0x05 RLC L
    func RLC_05() -> Int {
        _rlc(reg: .l)
        pc += 2
        return 8
    }
    // 0x06 RLC (HL)
    func RLC_06() -> Int {
        _rlc(addr: hl)
        pc += 2
        return 16
    }
    // 0x07 RLC A
    func RLC_07() -> Int {
        _rlc(reg: .a)
        pc += 2
        return 8
    }
    // 0x08 RRC B
    func RRC_08() -> Int {
        _rrc(reg: .b)
        pc += 2
        return 8
    }
    // 0x09 RRC C
    func RRC_09() -> Int {
        _rrc(reg: .c)
        pc += 2
        return 8
    }
    // 0x0a RRC D
    func RRC_0A() -> Int {
        _rrc(reg: .d)
        pc += 2
        return 8
    }
    // 0x0b RRC E
    func RRC_0B() -> Int {
        _rrc(reg: .e)
        pc += 2
        return 8
    }
    // 0x0c RRC H
    func RRC_0C() -> Int {
        _rrc(reg: .h)
        pc += 2
        return 8
    }
    // 0x0d RRC L
    func RRC_0D() -> Int {
        _rrc(reg: .l)
        pc += 2
        return 8
    }
    // 0x0e RRC (HL)
    func RRC_0E() -> Int {
        _rrc(addr: hl)
        pc += 2
        return 16
    }
    // 0x0f RRC A
    func RRC_0F() -> Int {
        _rrc(reg: .a)
        pc += 2
        return 8
    }
    // 0x10 RL B
    func RL_10() -> Int {
        _rl(reg: .b)
        pc += 2
        return 8
    }
    // 0x11 RL C
    func RL_11() -> Int {
        _rl(reg: .c)
        pc += 2
        return 8
    }
    // 0x12 RL D
    func RL_12() -> Int {
        _rl(reg: .d)
        pc += 2
        return 8
    }
    // 0x13 RL E
    func RL_13() -> Int {
        _rl(reg: .e)
        pc += 2
        return 8
    }
    // 0x14 RL H
    func RL_14() -> Int {
        _rl(reg: .h)
        pc += 2
        return 8
    }
    // 0x15 RL L
    func RL_15() -> Int {
        _rl(reg: .l)
        pc += 2
        return 8
    }
    // 0x16 RL (HL)
    func RL_16() -> Int {
        _rl(addr: hl)
        pc += 2
        return 16
    }
    // 0x17 RL A
    func RL_17() -> Int {
        _rl(reg: .a)
        pc += 2
        return 8
    }
    // 0x18 RR B
    func RR_18() -> Int {
        _rr(reg: .b)
        pc += 2
        return 8
    }
    // 0x19 RR C
    func RR_19() -> Int {
        _rr(reg: .c)
        pc += 2
        return 8
    }
    // 0x1a RR D
    func RR_1A() -> Int {
        _rr(reg: .d)
        pc += 2
        return 8
    }
    // 0x1b RR E
    func RR_1B() -> Int {
        _rr(reg: .e)
        pc += 2
        return 8
    }
    // 0x1c RR H
    func RR_1C() -> Int {
        _rr(reg: .h)
        pc += 2
        return 8
    }
    // 0x1d RR L
    func RR_1D() -> Int {
        _rr(reg: .l)
        pc += 2
        return 8
    }
    // 0x1e RR (HL)
    func RR_1E() -> Int {
        _rr(addr: hl)
        pc += 2
        return 16
    }
    // 0x1f RR A
    func RR_1F() -> Int {
        _rr(reg: .a)
        pc += 2
        return 8
    }
    // 0x20 SLA B
    func SLA_20() -> Int {
        _sla(reg: .b)
        pc += 2
        return 8
    }
    // 0x21 SLA C
    func SLA_21() -> Int {
        _sla(reg: .c)
        pc += 2
        return 8
    }
    // 0x22 SLA D
    func SLA_22() -> Int {
        _sla(reg: .d)
        pc += 2
        return 8
    }
    // 0x23 SLA E
    func SLA_23() -> Int {
        _sla(reg: .e)
        pc += 2
        return 8
    }
    // 0x24 SLA H
    func SLA_24() -> Int {
        _sla(reg: .h)
        pc += 2
        return 8
    }
    // 0x25 SLA L
    func SLA_25() -> Int {
        _sla(reg: .l)
        pc += 2
        return 8
    }
    // 0x26 SLA (HL)
    func SLA_26() -> Int {
        _sla(addr: hl)
        pc += 2
        return 16
    }
    // 0x27 SLA A
    func SLA_27() -> Int {
        _sla(reg: .a)
        pc += 2
        return 8
    }
    // 0x28 SRA B
    func SRA_28() -> Int {
        _sra(reg: .b)
        pc += 2
        return 8
    }
    // 0x29 SRA C
    func SRA_29() -> Int {
        _sra(reg: .c)
        pc += 2
        return 8
    }
    // 0x2a SRA D
    func SRA_2A() -> Int {
        _sra(reg: .d)
        pc += 2
        return 8
    }
    // 0x2b SRA E
    func SRA_2B() -> Int {
        _sra(reg: .e)
        pc += 2
        return 8
    }
    // 0x2c SRA H
    func SRA_2C() -> Int {
        _sra(reg: .h)
        pc += 2
        return 8
    }
    // 0x2d SRA L
    func SRA_2D() -> Int {
        _sra(reg: .l)
        pc += 2
        return 8
    }
    // 0x2e SRA (HL)
    func SRA_2E() -> Int {
        _sra(addr: hl)
        pc += 2
        return 16
    }
    // 0x2f SRA A
    func SRA_2F() -> Int {
        _sra(reg: .a)
        pc += 2
        return 8
    }
    // 0x30 SWAP B
    func SWAP_30() -> Int {
        _swap(reg: .b)
        pc += 2
        return 8
    }
    // 0x31 SWAP C
    func SWAP_31() -> Int {
        _swap(reg: .c)
        pc += 2
        return 8
    }
    // 0x32 SWAP D
    func SWAP_32() -> Int {
        _swap(reg: .d)
        pc += 2
        return 8
    }
    // 0x33 SWAP E
    func SWAP_33() -> Int {
        _swap(reg: .e)
        pc += 2
        return 8
    }
    // 0x34 SWAP H
    func SWAP_34() -> Int {
        _swap(reg: .h)
        pc += 2
        return 8
    }
    // 0x35 SWAP L
    func SWAP_35() -> Int {
        _swap(reg: .l)
        pc += 2
        return 8
    }
    // 0x36 SWAP (HL)
    func SWAP_36() -> Int {
        _swap(addr: hl)
        pc += 2
        return 16
    }
    // 0x37 SWAP A
    func SWAP_37() -> Int {
        _swap(reg: .a)
        pc += 2
        return 8
    }
    // 0x38 SRL B
    func SRL_38() -> Int {
        _srl(reg: .b)
        pc += 2
        return 8
    }
    // 0x39 SRL C
    func SRL_39() -> Int {
        _srl(reg: .c)
        pc += 2
        return 8
    }
    // 0x3a SRL D
    func SRL_3A() -> Int {
        _srl(reg: .d)
        pc += 2
        return 8
    }
    // 0x3b SRL E
    func SRL_3B() -> Int {
        _srl(reg: .e)
        pc += 2
        return 8
    }
    // 0x3c SRL H
    func SRL_3C() -> Int {
        _srl(reg: .h)
        pc += 2
        return 8
    }
    // 0x3d SRL L
    func SRL_3D() -> Int {
        _srl(reg: .l)
        pc += 2
        return 8
    }
    // 0x3e SRL (HL)
    func SRL_3E() -> Int {
        _srl(addr: hl)
        pc += 2
        return 16
    }
    // 0x3f SRL A
    func SRL_3F() -> Int {
        _srl(reg: .a)
        pc += 2
        return 8
    }
    // 0x40 BIT 0,B
    func BIT_40() -> Int {
        _bit(n: 0, reg: .b)
        pc += 2
        return 8
    }
    // 0x41 BIT 0,C
    func BIT_41() -> Int {
        _bit(n: 0, reg: .c)
        pc += 2
        return 8
    }
    // 0x42 BIT 0,D
    func BIT_42() -> Int {
        _bit(n: 0, reg: .d)
        pc += 2
        return 8
    }
    // 0x43 BIT 0,E
    func BIT_43() -> Int {
        _bit(n: 0, reg: .e)
        pc += 2
        return 8
    }
    // 0x44 BIT 0,H
    func BIT_44() -> Int {
        _bit(n: 0, reg: .h)
        pc += 2
        return 8
    }
    // 0x45 BIT 0,L
    func BIT_45() -> Int {
        _bit(n: 0, reg: .l)
        pc += 2
        return 8
    }
    // 0x46 BIT 0,(HL)
    func BIT_46() -> Int {
        _bit(n: 0, addr: hl)
        pc += 2
        return 16
    }
    // 0x47 BIT 0,A
    func BIT_47() -> Int {
        _bit(n: 0, reg: .a)
        pc += 2
        return 8
    }
    // 0x48 BIT 1,B
    func BIT_48() -> Int {
        _bit(n: 1, reg: .b)
        pc += 2
        return 8
    }
    // 0x49 BIT 1,C
    func BIT_49() -> Int {
        _bit(n: 1, reg: .c)
        pc += 2
        return 8
    }
    // 0x4a BIT 1,D
    func BIT_4A() -> Int {
        _bit(n: 1, reg: .d)
        pc += 2
        return 8
    }
    // 0x4b BIT 1,E
    func BIT_4B() -> Int {
        _bit(n: 1, reg: .e)
        pc += 2
        return 8
    }
    // 0x4c BIT 1,H
    func BIT_4C() -> Int {
        _bit(n: 1, reg: .h)
        pc += 2
        return 8
    }
    // 0x4d BIT 1,L
    func BIT_4D() -> Int {
        _bit(n: 1, reg: .l)
        pc += 2
        return 8
    }
    // 0x4e BIT 1,(HL)
    func BIT_4E() -> Int {
        _bit(n: 1, addr: hl)
        pc += 2
        return 16
    }
    // 0x4f BIT 1,A
    func BIT_4F() -> Int {
        _bit(n: 1, reg: .a)
        pc += 2
        return 8
    }
    // 0x50 BIT 2,B
    func BIT_50() -> Int {
        _bit(n: 2, reg: .b)
        pc += 2
        return 8
    }
    // 0x51 BIT 2,C
    func BIT_51() -> Int {
        _bit(n: 2, reg: .c)
        pc += 2
        return 8
    }
    // 0x52 BIT 2,D
    func BIT_52() -> Int {
        _bit(n: 2, reg: .d)
        pc += 2
        return 8
    }
    // 0x53 BIT 2,E
    func BIT_53() -> Int {
        _bit(n: 2, reg: .e)
        pc += 2
        return 8
    }
    // 0x54 BIT 2,H
    func BIT_54() -> Int {
        _bit(n: 2, reg: .h)
        pc += 2
        return 8
    }
    // 0x55 BIT 2,L
    func BIT_55() -> Int {
        _bit(n: 2, reg: .l)
        pc += 2
        return 8
    }
    // 0x56 BIT 2,(HL)
    func BIT_56() -> Int {
        _bit(n: 2, addr: hl)
        pc += 2
        return 16
    }
    // 0x57 BIT 2,A
    func BIT_57() -> Int {
        _bit(n: 2, reg: .a)
        pc += 2
        return 8
    }
    // 0x58 BIT 3,B
    func BIT_58() -> Int {
        _bit(n: 3, reg: .b)
        pc += 2
        return 8
    }
    // 0x59 BIT 3,C
    func BIT_59() -> Int {
        _bit(n: 3, reg: .c)
        pc += 2
        return 8
    }
    // 0x5a BIT 3,D
    func BIT_5A() -> Int {
        _bit(n: 3, reg: .d)
        pc += 2
        return 8
    }
    // 0x5b BIT 3,E
    func BIT_5B() -> Int {
        _bit(n: 3, reg: .e)
        pc += 2
        return 8
    }
    // 0x5c BIT 3,H
    func BIT_5C() -> Int {
        _bit(n: 3, reg: .h)
        pc += 2
        return 8
    }
    // 0x5d BIT 3,L
    func BIT_5D() -> Int {
        _bit(n: 3, reg: .l)
        pc += 2
        return 8
    }
    // 0x5e BIT 3,(HL)
    func BIT_5E() -> Int {
        _bit(n: 3, addr: hl)
        pc += 2
        return 16
    }
    // 0x5f BIT 3,A
    func BIT_5F() -> Int {
        _bit(n: 3, reg: .a)
        pc += 2
        return 8
    }
    // 0x60 BIT 4,B
    func BIT_60() -> Int {
        _bit(n: 4, reg: .b)
        pc += 2
        return 8
    }
    // 0x61 BIT 4,C
    func BIT_61() -> Int {
        _bit(n: 4, reg: .c)
        pc += 2
        return 8
    }
    // 0x62 BIT 4,D
    func BIT_62() -> Int {
        _bit(n: 4, reg: .d)
        pc += 2
        return 8
    }
    // 0x63 BIT 4,E
    func BIT_63() -> Int {
        _bit(n: 4, reg: .e)
        pc += 2
        return 8
    }
    // 0x64 BIT 4,H
    func BIT_64() -> Int {
        _bit(n: 4, reg: .h)
        pc += 2
        return 8
    }
    // 0x65 BIT 4,L
    func BIT_65() -> Int {
        _bit(n: 4, reg: .l)
        pc += 2
        return 8
    }
    // 0x66 BIT 4,(HL)
    func BIT_66() -> Int {
        _bit(n: 4, addr: hl)
        pc += 2
        return 16
    }
    // 0x67 BIT 4,A
    func BIT_67() -> Int {
        _bit(n: 4, reg: .a)
        pc += 2
        return 8
    }
    // 0x68 BIT 5,B
    func BIT_68() -> Int {
        _bit(n: 5, reg: .b)
        pc += 2
        return 8
    }
    // 0x69 BIT 5,C
    func BIT_69() -> Int {
        _bit(n: 5, reg: .c)
        pc += 2
        return 8
    }
    // 0x6a BIT 5,D
    func BIT_6A() -> Int {
        _bit(n: 5, reg: .d)
        pc += 2
        return 8
    }
    // 0x6b BIT 5,E
    func BIT_6B() -> Int {
        _bit(n: 5, reg: .e)
        pc += 2
        return 8
    }
    // 0x6c BIT 5,H
    func BIT_6C() -> Int {
        _bit(n: 5, reg: .h)
        pc += 2
        return 8
    }
    // 0x6d BIT 5,L
    func BIT_6D() -> Int {
        _bit(n: 5, reg: .l)
        pc += 2
        return 8
    }
    // 0x6e BIT 5,(HL)
    func BIT_6E() -> Int {
        _bit(n: 5, addr: hl)
        pc += 2
        return 16
    }
    // 0x6f BIT 5,A
    func BIT_6F() -> Int {
        _bit(n: 5, reg: .a)
        pc += 2
        return 8
    }
    // 0x70 BIT 6,B
    func BIT_70() -> Int {
        _bit(n: 6, reg: .b)
        pc += 2
        return 8
    }
    // 0x71 BIT 6,C
    func BIT_71() -> Int {
        _bit(n: 6, reg: .c)
        pc += 2
        return 8
    }
    // 0x72 BIT 6,D
    func BIT_72() -> Int {
        _bit(n: 6, reg: .d)
        pc += 2
        return 8
    }
    // 0x73 BIT 6,E
    func BIT_73() -> Int {
        _bit(n: 6, reg: .e)
        pc += 2
        return 8
    }
    // 0x74 BIT 6,H
    func BIT_74() -> Int {
        _bit(n: 6, reg: .h)
        pc += 2
        return 8
    }
    // 0x75 BIT 6,L
    func BIT_75() -> Int {
        _bit(n: 6, reg: .l)
        pc += 2
        return 8
    }
    // 0x76 BIT 6,(HL)
    func BIT_76() -> Int {
        _bit(n: 6, addr: hl)
        pc += 2
        return 16
    }
    // 0x77 BIT 6,A
    func BIT_77() -> Int {
        _bit(n: 6, reg: .a)
        pc += 2
        return 8
    }
    // 0x78 BIT 7,B
    func BIT_78() -> Int {
        _bit(n: 7, reg: .b)
        pc += 2
        return 8
    }
    // 0x79 BIT 7,C
    func BIT_79() -> Int {
        _bit(n: 7, reg: .c)
        pc += 2
        return 8
    }
    // 0x7a BIT 7,D
    func BIT_7A() -> Int {
        _bit(n: 7, reg: .d)
        pc += 2
        return 8
    }
    // 0x7b BIT 7,E
    func BIT_7B() -> Int {
        _bit(n: 7, reg: .e)
        pc += 2
        return 8
    }
    // 0x7c BIT 7,H
    func BIT_7C() -> Int {
        _bit(n: 7, reg: .h)
        pc += 2
        return 8
    }
    // 0x7d BIT 7,L
    func BIT_7D() -> Int {
        _bit(n: 7, reg: .l)
        pc += 2
        return 8
    }
    // 0x7e BIT 7,(HL)
    func BIT_7E() -> Int {
        _bit(n: 7, addr: hl)
        pc += 2
        return 16
    }
    // 0x7f BIT 7,A
    func BIT_7F() -> Int {
        _bit(n: 7, reg: .a)
        pc += 2
        return 8
    }
    // 0x80 RES 0,B
    func RES_80() -> Int {
        _res(n: 0, reg: .b)
        pc += 2
        return 8
    }
    // 0x81 RES 0,C
    func RES_81() -> Int {
        _res(n: 0, reg: .c)
        pc += 2
        return 8
    }
    // 0x82 RES 0,D
    func RES_82() -> Int {
        _res(n: 0, reg: .d)
        pc += 2
        return 8
    }
    // 0x83 RES 0,E
    func RES_83() -> Int {
        _res(n: 0, reg: .e)
        pc += 2
        return 8
    }
    // 0x84 RES 0,H
    func RES_84() -> Int {
        _res(n: 0, reg: .h)
        pc += 2
        return 8
    }
    // 0x85 RES 0,L
    func RES_85() -> Int {
        _res(n: 0, reg: .l)
        pc += 2
        return 8
    }
    // 0x86 RES 0,(HL)
    func RES_86() -> Int {
        _res(n: 0, addr: hl)
        pc += 2
        return 16
    }
    // 0x87 RES 0,A
    func RES_87() -> Int {
        _res(n: 0, reg: .a)
        pc += 2
        return 8
    }
    // 0x88 RES 1,B
    func RES_88() -> Int {
        _res(n: 1, reg: .b)
        pc += 2
        return 8
    }
    // 0x89 RES 1,C
    func RES_89() -> Int {
        _res(n: 1, reg: .c)
        pc += 2
        return 8
    }
    // 0x8a RES 1,D
    func RES_8A() -> Int {
        _res(n: 1, reg: .d)
        pc += 2
        return 8
    }
    // 0x8b RES 1,E
    func RES_8B() -> Int {
        _res(n: 1, reg: .e)
        pc += 2
        return 8
    }
    // 0x8c RES 1,H
    func RES_8C() -> Int {
        _res(n: 1, reg: .h)
        pc += 2
        return 8
    }
    // 0x8d RES 1,L
    func RES_8D() -> Int {
        _res(n: 1, reg: .l)
        pc += 2
        return 8
    }
    // 0x8e RES 1,(HL)
    func RES_8E() -> Int {
        _res(n: 1, addr: hl)
        pc += 2
        return 16
    }
    // 0x8f RES 1,A
    func RES_8F() -> Int {
        _res(n: 1, reg: .a)
        pc += 2
        return 8
    }
    // 0x90 RES 2,B
    func RES_90() -> Int {
        _res(n: 2, reg: .b)
        pc += 2
        return 8
    }
    // 0x91 RES 2,C
    func RES_91() -> Int {
        _res(n: 2, reg: .c)
        pc += 2
        return 8
    }
    // 0x92 RES 2,D
    func RES_92() -> Int {
        _res(n: 2, reg: .d)
        pc += 2
        return 8
    }
    // 0x93 RES 2,E
    func RES_93() -> Int {
        _res(n: 2, reg: .e)
        pc += 2
        return 8
    }
    // 0x94 RES 2,H
    func RES_94() -> Int {
        _res(n: 2, reg: .h)
        pc += 2
        return 8
    }
    // 0x95 RES 2,L
    func RES_95() -> Int {
        _res(n: 2, reg: .l)
        pc += 2
        return 8
    }
    // 0x96 RES 2,(HL)
    func RES_96() -> Int {
        _res(n: 2, addr: hl)
        pc += 2
        return 16
    }
    // 0x97 RES 2,A
    func RES_97() -> Int {
        _res(n: 2, reg: .a)
        pc += 2
        return 8
    }
    // 0x98 RES 3,B
    func RES_98() -> Int {
        _res(n: 3, reg: .b)
        pc += 2
        return 8
    }
    // 0x99 RES 3,C
    func RES_99() -> Int {
        _res(n: 3, reg: .c)
        pc += 2
        return 8
    }
    // 0x9a RES 3,D
    func RES_9A() -> Int {
        _res(n: 3, reg: .d)
        pc += 2
        return 8
    }
    // 0x9b RES 3,E
    func RES_9B() -> Int {
        _res(n: 3, reg: .e)
        pc += 2
        return 8
    }
    // 0x9c RES 3,H
    func RES_9C() -> Int {
        _res(n: 3, reg: .h)
        pc += 2
        return 8
    }
    // 0x9d RES 3,L
    func RES_9D() -> Int {
        _res(n: 3, reg: .l)
        pc += 2
        return 8
    }
    // 0x9e RES 3,(HL)
    func RES_9E() -> Int {
        _res(n: 3, addr: hl)
        pc += 2
        return 16
    }
    // 0x9f RES 3,A
    func RES_9F() -> Int {
        _res(n: 3, reg: .a)
        pc += 2
        return 8
    }
    // 0xa0 RES 4,B
    func RES_A0() -> Int {
        _res(n: 4, reg: .b)
        pc += 2
        return 8
    }
    // 0xa1 RES 4,C
    func RES_A1() -> Int {
        _res(n: 4, reg: .c)
        pc += 2
        return 8
    }
    // 0xa2 RES 4,D
    func RES_A2() -> Int {
        _res(n: 4, reg: .d)
        pc += 2
        return 8
    }
    // 0xa3 RES 4,E
    func RES_A3() -> Int {
        _res(n: 4, reg: .e)
        pc += 2
        return 8
    }
    // 0xa4 RES 4,H
    func RES_A4() -> Int {
        _res(n: 4, reg: .h)
        pc += 2
        return 8
    }
    // 0xa5 RES 4,L
    func RES_A5() -> Int {
        _res(n: 4, reg: .l)
        pc += 2
        return 8
    }
    // 0xa6 RES 4,(HL)
    func RES_A6() -> Int {
        _res(n: 4, addr: hl)
        pc += 2
        return 16
    }
    // 0xa7 RES 4,A
    func RES_A7() -> Int {
        _res(n: 4, reg: .a)
        pc += 2
        return 8
    }
    // 0xa8 RES 5,B
    func RES_A8() -> Int {
        _res(n: 5, reg: .b)
        pc += 2
        return 8
    }
    // 0xa9 RES 5,C
    func RES_A9() -> Int {
        _res(n: 5, reg: .c)
        pc += 2
        return 8
    }
    // 0xaa RES 5,D
    func RES_AA() -> Int {
        _res(n: 5, reg: .d)
        pc += 2
        return 8
    }
    // 0xab RES 5,E
    func RES_AB() -> Int {
        _res(n: 5, reg: .e)
        pc += 2
        return 8
    }
    // 0xac RES 5,H
    func RES_AC() -> Int {
        _res(n: 5, reg: .h)
        pc += 2
        return 8
    }
    // 0xad RES 5,L
    func RES_AD() -> Int {
        _res(n: 5, reg: .l)
        pc += 2
        return 8
    }
    // 0xae RES 5,(HL)
    func RES_AE() -> Int {
        _res(n: 5, addr: hl)
        pc += 2
        return 16
    }
    // 0xaf RES 5,A
    func RES_AF() -> Int {
        _res(n: 5, reg: .a)
        pc += 2
        return 8
    }
    // 0xb0 RES 6,B
    func RES_B0() -> Int {
        _res(n: 6, reg: .b)
        pc += 2
        return 8
    }
    // 0xb1 RES 6,C
    func RES_B1() -> Int {
        _res(n: 6, reg: .c)
        pc += 2
        return 8
    }
    // 0xb2 RES 6,D
    func RES_B2() -> Int {
        _res(n: 6, reg: .d)
        pc += 2
        return 8
    }
    // 0xb3 RES 6,E
    func RES_B3() -> Int {
        _res(n: 6, reg: .e)
        pc += 2
        return 8
    }
    // 0xb4 RES 6,H
    func RES_B4() -> Int {
        _res(n: 6, reg: .h)
        pc += 2
        return 8
    }
    // 0xb5 RES 6,L
    func RES_B5() -> Int {
        _res(n: 6, reg: .l)
        pc += 2
        return 8
    }
    // 0xb6 RES 6,(HL)
    func RES_B6() -> Int {
        _res(n: 6, addr: hl)
        pc += 2
        return 16
    }
    // 0xb7 RES 6,A
    func RES_B7() -> Int {
        _res(n: 6, reg: .a)
        pc += 2
        return 8
    }
    // 0xb8 RES 7,B
    func RES_B8() -> Int {
        _res(n: 7, reg: .b)
        pc += 2
        return 8
    }
    // 0xb9 RES 7,C
    func RES_B9() -> Int {
        _res(n: 7, reg: .c)
        pc += 2
        return 8
    }
    // 0xba RES 7,D
    func RES_BA() -> Int {
        _res(n: 7, reg: .d)
        pc += 2
        return 8
    }
    // 0xbb RES 7,E
    func RES_BB() -> Int {
        _res(n: 7, reg: .e)
        pc += 2
        return 8
    }
    // 0xbc RES 7,H
    func RES_BC() -> Int {
        _res(n: 7, reg: .h)
        pc += 2
        return 8
    }
    // 0xbd RES 7,L
    func RES_BD() -> Int {
        _res(n: 7, reg: .l)
        pc += 2
        return 8
    }
    // 0xbe RES 7,(HL)
    func RES_BE() -> Int {
        _res(n: 7, addr: hl)
        pc += 2
        return 16
    }
    // 0xbf RES 7,A
    func RES_BF() -> Int {
        _res(n: 7, reg: .a)
        pc += 2
        return 8
    }
    // 0xc0 SET 0,B
    func SET_C0() -> Int {
        _set(n: 0, reg: .b)
        pc += 2
        return 8
    }
    // 0xc1 SET 0,C
    func SET_C1() -> Int {
        _set(n: 0, reg: .c)
        pc += 2
        return 8
    }
    // 0xc2 SET 0,D
    func SET_C2() -> Int {
        _set(n: 0, reg: .d)
        pc += 2
        return 8
    }
    // 0xc3 SET 0,E
    func SET_C3() -> Int {
        _set(n: 0, reg: .e)
        pc += 2
        return 8
    }
    // 0xc4 SET 0,H
    func SET_C4() -> Int {
        _set(n: 0, reg: .h)
        pc += 2
        return 8
    }
    // 0xc5 SET 0,L
    func SET_C5() -> Int {
        _set(n: 0, reg: .l)
        pc += 2
        return 8
    }
    // 0xc6 SET 0,(HL)
    func SET_C6() -> Int {
        _set(n: 0, addr: hl)
        pc += 2
        return 16
    }
    // 0xc7 SET 0,A
    func SET_C7() -> Int {
        _set(n: 0, reg: .a)
        pc += 2
        return 8
    }
    // 0xc8 SET 1,B
    func SET_C8() -> Int {
        _set(n: 1, reg: .b)
        pc += 2
        return 8
    }
    // 0xc9 SET 1,C
    func SET_C9() -> Int {
        _set(n: 1, reg: .c)
        pc += 2
        return 8
    }
    // 0xca SET 1,D
    func SET_CA() -> Int {
        _set(n: 1, reg: .d)
        pc += 2
        return 8
    }
    // 0xcb SET 1,E
    func SET_CB() -> Int {
        _set(n: 1, reg: .e)
        pc += 2
        return 8
    }
    // 0xcc SET 1,H
    func SET_CC() -> Int {
        _set(n: 1, reg: .h)
        pc += 2
        return 8
    }
    // 0xcd SET 1,L
    func SET_CD() -> Int {
        _set(n: 1, reg: .l)
        pc += 2
        return 8
    }
    // 0xce SET 1,(HL)
    func SET_CE() -> Int {
        _set(n: 1, addr: hl)
        pc += 2
        return 16
    }
    // 0xcf SET 1,A
    func SET_CF() -> Int {
        _set(n: 1, reg: .a)
        pc += 2
        return 8
    }
    // 0xd0 SET 2,B
    func SET_D0() -> Int {
        _set(n: 2, reg: .b)
        pc += 2
        return 8
    }
    // 0xd1 SET 2,C
    func SET_D1() -> Int {
        _set(n: 2, reg: .c)
        pc += 2
        return 8
    }
    // 0xd2 SET 2,D
    func SET_D2() -> Int {
        _set(n: 2, reg: .d)
        pc += 2
        return 8
    }
    // 0xd3 SET 2,E
    func SET_D3() -> Int {
        _set(n: 2, reg: .e)
        pc += 2
        return 8
    }
    // 0xd4 SET 2,H
    func SET_D4() -> Int {
        _set(n: 2, reg: .h)
        pc += 2
        return 8
    }
    // 0xd5 SET 2,L
    func SET_D5() -> Int {
        _set(n: 2, reg: .l)
        pc += 2
        return 8
    }
    // 0xd6 SET 2,(HL)
    func SET_D6() -> Int {
        _set(n: 2, addr: hl)
        pc += 2
        return 16
    }
    // 0xd7 SET 2,A
    func SET_D7() -> Int {
        _set(n: 2, reg: .a)
        pc += 2
        return 8
    }
    // 0xd8 SET 3,B
    func SET_D8() -> Int {
        _set(n: 3, reg: .b)
        pc += 2
        return 8
    }
    // 0xd9 SET 3,C
    func SET_D9() -> Int {
        _set(n: 3, reg: .c)
        pc += 2
        return 8
    }
    // 0xda SET 3,D
    func SET_DA() -> Int {
        _set(n: 3, reg: .d)
        pc += 2
        return 8
    }
    // 0xdb SET 3,E
    func SET_DB() -> Int {
        _set(n: 3, reg: .e)
        pc += 2
        return 8
    }
    // 0xdc SET 3,H
    func SET_DC() -> Int {
        _set(n: 3, reg: .h)
        pc += 2
        return 8
    }
    // 0xdd SET 3,L
    func SET_DD() -> Int {
        _set(n: 3, reg: .l)
        pc += 2
        return 8
    }
    // 0xde SET 3,(HL)
    func SET_DE() -> Int {
        _set(n: 3, addr: hl)
        pc += 2
        return 16
    }
    // 0xdf SET 3,A
    func SET_DF() -> Int {
        _set(n: 3, reg: .a)
        pc += 2
        return 8
    }
    // 0xe0 SET 4,B
    func SET_E0() -> Int {
        _set(n: 4, reg: .b)
        pc += 2
        return 8
    }
    // 0xe1 SET 4,C
    func SET_E1() -> Int {
        _set(n: 4, reg: .c)
        pc += 2
        return 8
    }
    // 0xe2 SET 4,D
    func SET_E2() -> Int {
        _set(n: 4, reg: .d)
        pc += 2
        return 8
    }
    // 0xe3 SET 4,E
    func SET_E3() -> Int {
        _set(n: 4, reg: .e)
        pc += 2
        return 8
    }
    // 0xe4 SET 4,H
    func SET_E4() -> Int {
        _set(n: 4, reg: .h)
        pc += 2
        return 8
    }
    // 0xe5 SET 4,L
    func SET_E5() -> Int {
        _set(n: 4, reg: .l)
        pc += 2
        return 8
    }
    // 0xe6 SET 4,(HL)
    func SET_E6() -> Int {
        _set(n: 4, addr: hl)
        pc += 2
        return 16
    }
    // 0xe7 SET 4,A
    func SET_E7() -> Int {
        _set(n: 4, reg: .a)
        pc += 2
        return 8
    }
    // 0xe8 SET 5,B
    func SET_E8() -> Int {
        _set(n: 5, reg: .b)
        pc += 2
        return 8
    }
    // 0xe9 SET 5,C
    func SET_E9() -> Int {
        _set(n: 5, reg: .c)
        pc += 2
        return 8
    }
    // 0xea SET 5,D
    func SET_EA() -> Int {
        _set(n: 5, reg: .d)
        pc += 2
        return 8
    }
    // 0xeb SET 5,E
    func SET_EB() -> Int {
        _set(n: 5, reg: .e)
        pc += 2
        return 8
    }
    // 0xec SET 5,H
    func SET_EC() -> Int {
        _set(n: 5, reg: .h)
        pc += 2
        return 8
    }
    // 0xed SET 5,L
    func SET_ED() -> Int {
        _set(n: 5, reg: .l)
        pc += 2
        return 8
    }
    // 0xee SET 5,(HL)
    func SET_EE() -> Int {
        _set(n: 5, addr: hl)
        pc += 2
        return 16
    }
    // 0xef SET 5,A
    func SET_EF() -> Int {
        _set(n: 5, reg: .a)
        pc += 2
        return 8
    }
    // 0xf0 SET 6,B
    func SET_F0() -> Int {
        _set(n: 6, reg: .b)
        pc += 2
        return 8
    }
    // 0xf1 SET 6,C
    func SET_F1() -> Int {
        _set(n: 6, reg: .c)
        pc += 2
        return 8
    }
    // 0xf2 SET 6,D
    func SET_F2() -> Int {
        _set(n: 6, reg: .d)
        pc += 2
        return 8
    }
    // 0xf3 SET 6,E
    func SET_F3() -> Int {
        _set(n: 6, reg: .e)
        pc += 2
        return 8
    }
    // 0xf4 SET 6,H
    func SET_F4() -> Int {
        _set(n: 6, reg: .h)
        pc += 2
        return 8
    }
    // 0xf5 SET 6,L
    func SET_F5() -> Int {
        _set(n: 6, reg: .l)
        pc += 2
        return 8
    }
    // 0xf6 SET 6,(HL)
    func SET_F6() -> Int {
        _set(n: 6, addr: hl)
        pc += 2
        return 16
    }
    // 0xf7 SET 6,A
    func SET_F7() -> Int {
        _set(n: 6, reg: .a)
        pc += 2
        return 8
    }
    // 0xf8 SET 7,B
    func SET_F8() -> Int {
        _set(n: 7, reg: .b)
        pc += 2
        return 8
    }
    // 0xf9 SET 7,C
    func SET_F9() -> Int {
        _set(n: 7, reg: .c)
        pc += 2
        return 8
    }
    // 0xfa SET 7,D
    func SET_FA() -> Int {
        _set(n: 7, reg: .d)
        pc += 2
        return 8
    }
    // 0xfb SET 7,E
    func SET_FB() -> Int {
        _set(n: 7, reg: .e)
        pc += 2
        return 8
    }
    // 0xfc SET 7,H
    func SET_FC() -> Int {
        _set(n: 7, reg: .h)
        pc += 2
        return 8
    }
    // 0xfd SET 7,L
    func SET_FD() -> Int {
        _set(n: 7, reg: .l)
        pc += 2
        return 8
    }
    // 0xfe SET 7,(HL)
    func SET_FE() -> Int {
        _set(n: 7, addr: hl)
        pc += 2
        return 16
    }
    // 0xff SET 7,A
    func SET_FF() -> Int {
        _set(n: 7, reg: .a)
        pc += 2
        return 8
    }
    
    
}
