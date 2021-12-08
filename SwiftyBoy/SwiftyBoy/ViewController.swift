//
//  ViewController.swift
//  SwiftyBoy
//
//  Created by Yigang Zhou on 2021/11/25.
//

import UIKit
import Foundation

class ViewController: UIViewController {
    
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        let mb = Motherboard()
        let gpu = GPU()
        
        var cycles = 0
//        while mb.cpu.pc >= 0 {
//            cycles = mb.cpu.fetchAndExecute()
//            gpu.tick(numOfCycles: cycles)
//        }
        print("\(cycles) passed")

        
    }
   
    


}

extension Array {
    func chunked(into size: Int) -> [[Element]] {
        return stride(from: 0, to: count, by: size).map {
            Array(self[$0 ..< Swift.min($0 + size, count)])
        }
    }

}


