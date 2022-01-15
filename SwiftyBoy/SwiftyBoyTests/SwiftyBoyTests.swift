//
//  SwiftyBoyTests.swift
//  SwiftyBoyTests
//
//  Created by Yigang Zhou on 2021/11/25.
//

import XCTest
@testable import SwiftyBoy

class SwiftyBoyTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        testSub()
        testPopAndPushStack()
       
    }
    
    func testSub() {
        let mb = Motherboard()
        mb.cpu.a = 0x3e
        mb.cpu.e = 0x3e
        mb.cpu.SUB_93()
        
        XCTAssert(mb.cpu.a == 0)
        XCTAssert(mb.cpu.fZ == true)
        XCTAssert(mb.cpu.fH == false)
        XCTAssert(mb.cpu.fN == true)
        XCTAssert(mb.cpu.fC == false)
    }
    
    func testPopAndPushStack() {
        let mb = Motherboard()
        mb.cpu.pc = 0xABCD
        let spAddress = 65530
        mb.cpu.sp = spAddress
        mb.cpu.pushPCToStack()
        XCTAssert(mb.cpu.sp == spAddress - 2)
        mb.cpu.pc = 0
        XCTAssert(mb.cpu.pc == 0)
        mb.cpu.popPCFromStack()
        XCTAssert(mb.cpu.pc == 0xABCD)
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
