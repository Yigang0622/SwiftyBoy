//
//  ViewController.swift
//  AudioKitDemo
//
//  Created by Yigang Zhou on 2022/4/9.
//

import UIKit
import AudioKit

class ViewController: UIViewController {
    
    let engin = AudioEngine()
    let osc = DynamicOscillator()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        engin.output = osc
        
        var lsfr = LSFR(length: 15)
        let table = Table(lsfr.next(step: 10699).map({ each in
            return Float(each)
        }))
        
        osc.frequency = 1
        osc.amplitude = 0.5
        osc.setWaveTable(waveform: table)
        osc.start()
        
        do {
            try engin.start()
        } catch let err {
            print(err.localizedDescription)
        }
//        print("play")
        
        
    }

    
    func audioKitTable(dutyCycle: Double) -> Table {
        let size = 4_096
        var content = [Table.Element](zeros: size)
        for i in 0..<Int(Double(size) * dutyCycle) {
            content[i] = 1.0
        }
        return Table(content)
    }


}

