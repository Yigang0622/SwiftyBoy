//
//  FPSMetric.swift
//  SwiftyBoy
//
//  Created by Yigang on 2022/2/3.
//

import Foundation
import UIKit

class FPSMetric: NSObject {
    
    static let shared = FPSMetric()
    
    private var fpsCounter = 0
    private var _fps = 0
    
    private var fpsTimer: DispatchSourceTimer!
    private var queue = DispatchQueue(label: "it.miketech.SwiftyBoy.fpsMetric")
    
    var delegate: FPSMetricDelegate?
    
    private var gameboyDelegate: GameBoyDelegate?
    
    var fps: Int {
        get {
            return _fps
        }
    }
    
    func increaseCounter() {
        self.fpsCounter += 1
    }
    
    func startMoinitoring() {
        fpsTimer = DispatchSource.makeTimerSource(flags: .strict, queue: queue)
        fpsTimer.setEventHandler { [self] in
            _fps = self.fpsCounter
            self.fpsCounter = 0
            DispatchQueue.main.async {
                delegate?.fpsMetricDidUpdateFps(fps: _fps)
            }
        }
        self.fpsTimer.schedule(deadline: .now(), repeating: .seconds(1), leeway: .milliseconds(10))
        self.fpsTimer.resume()
        
    }
    
    func stopMonitoring() {
        if self.fpsTimer == nil {
            self.fpsCounter = 0
            fpsTimer.cancel()
        }
    }
    
    func bind(gameboyDelegate: GameBoyDelegate) {
        print("bind \(gameboyDelegate)")
        let originalSelector = #selector(gameboyDelegate.gameBoyDidDrawNewFrame(frame:))
        let swizzledSelector = #selector(self.swizzledGameBoyDidDrawNewFrame(frame:))
        
//        let aClass: AnyClass! = object_getClass(GameBoyDelegate())
        
//        let originalMethod = class_getInstanceMethod(gameboyDelegate, originalSelector)
//        let swizzledMethod = class_getInstanceMethod(FPSMetric.self, swizzledSelector)


    }
    
    @objc private func swizzledGameBoyDidDrawNewFrame(frame: UIImage) {
        print("swizzledGameBoyDidDrawNewFrame")
        
    }
    
}

protocol FPSMetricDelegate {
    func fpsMetricDidUpdateFps(fps: Int)
}
