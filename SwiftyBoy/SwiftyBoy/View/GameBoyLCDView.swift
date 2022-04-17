//
//  GameboyLCDView.swift
//  SwiftyBoy
//
//  Created by Yigang on 2022/2/4.
//

import Foundation
import UIKit


class GameBoyLCDView: UIView {
    
    var fpsLabel: UILabel!
    var mainImageView: UIImageView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupViews()
    }
    
    private func setupViews() {
        
        mainImageView = UIImageView()
        mainImageView.translatesAutoresizingMaskIntoConstraints = false
        mainImageView.backgroundColor = .black
        mainImageView.contentMode = .scaleAspectFit
        self.addSubview(mainImageView)
        
        mainImageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        fpsLabel = UILabel()
        fpsLabel.alpha = 0.3
        fpsLabel.translatesAutoresizingMaskIntoConstraints = false
        fpsLabel.font = UIFont.systemFont(ofSize: 30, weight: .bold)
        fpsLabel.backgroundColor = .black
        fpsLabel.textColor = .white
        self.addSubview(fpsLabel)
        fpsLabel.snp.makeConstraints { make in
            make.left.equalToSuperview()
            make.top.equalToSuperview()
            make.height.equalTo(30)
        }
        
    }
    
    func setFpsText(fps: Int) {
        self.fpsLabel.text = "\(fps)"
    }
    
    func setFrame(frame: UIImage) {
        self.mainImageView.image = frame
    }
    
}
