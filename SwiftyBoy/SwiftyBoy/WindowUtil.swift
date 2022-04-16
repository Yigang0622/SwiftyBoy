//
//  WindowUtil.swift
//  SwiftyBoy
//
//  Created by Yigang Zhou on 2022/4/16.
//

import UIKit

class WindowUtil: NSObject {

    private static let debugPannelWidth = 800
    private static let scale = 4
    
    
    static func setDevWidnowSize() {
        UIApplication.shared.connectedScenes.compactMap { $0 as? UIWindowScene }.forEach { windowScene in
            windowScene.sizeRestrictions?.minimumSize = CGSize(width: 160 * scale + debugPannelWidth, height:  144 * scale + 40)
            windowScene.sizeRestrictions?.maximumSize = CGSize(width: 160 * scale + debugPannelWidth, height:  144 * scale + 40)
        }
    }
    
    static func setNormalWindowSize() {
        UIApplication.shared.connectedScenes.compactMap { $0 as? UIWindowScene }.forEach { windowScene in
            windowScene.sizeRestrictions?.minimumSize = CGSize(width: 160 * scale, height:  144 * scale + 40)
            windowScene.sizeRestrictions?.maximumSize = CGSize(width: 160 * scale, height:  144 * scale + 40)
        }
    }
    
}
