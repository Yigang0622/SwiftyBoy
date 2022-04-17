//
//  DevPannelView.swift
//  SwiftyBoy
//
//  Created by Yigang Zhou on 2022/4/16.
//

import UIKit

class DevPanelView: UIView {

    var backgroundLayer: UIImageView!
    var windowLayer: UIImageView!
    var spriteLayer: UIImageView!
    let stack = UIStackView()
    
    var updateSoundChannelStatus: ((_ soundChannel: SoundChannelType, _ enable: Bool) -> Void)?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupViews()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.setupViews()
    }
    
    private func setupViews() {
        self.backgroundColor = .systemGray6
       
        let vramLabel = UILabel()
        vramLabel.font = UIFont.systemFont(ofSize: 25, weight: .medium)
        vramLabel.text = "Video RAM"
        self.addSubview(vramLabel)
        vramLabel.snp.makeConstraints { make in
            make.height.equalTo(50)
            make.width.equalTo(200)
            make.left.equalTo(10)
            make.top.equalTo(50)
        }
        
        self.addSubview(stack)
        stack.snp.makeConstraints { make in
            make.top.equalTo(vramLabel.snp.bottom).offset(10)
            make.left.equalToSuperview().offset(10)
            make.right.equalToSuperview().offset(-10)
            make.height.equalTo(250)
        }
        stack.axis = .horizontal
        stack.alignment = .center
        stack.distribution = .equalSpacing
        
        backgroundLayer = layerImageView(title: "background")
        stack.addArrangedSubview(backgroundLayer)
        
        windowLayer = layerImageView(title: "window")
        stack.addArrangedSubview(windowLayer)
        
        spriteLayer = layerImageView(title: "sprites")
        stack.addArrangedSubview(spriteLayer)
        
        
        let soundLabel = UILabel()
        soundLabel.font = UIFont.systemFont(ofSize: 25, weight: .medium)
        soundLabel.text = "Sound"
        self.addSubview(soundLabel)
        soundLabel.snp.makeConstraints { make in
            make.height.equalTo(30)
            make.width.equalTo(200)
            make.left.equalTo(10)
            make.top.equalTo(stack.snp.bottom).offset(10)
        }
        
        let sound1 = SwitchWithTitle()
        sound1.title = "Sound Channel 1 (Square 1)"
        addSubview(sound1)
        sound1.snp.makeConstraints { make in
            make.left.equalTo(10)
            make.top.equalTo(soundLabel.snp.bottom).offset(10)
        }
        sound1.onSwitchToggle = { isOn in
            self.updateSoundChannelStatus?(.channel1, isOn)
        }
        
        let sound2 = SwitchWithTitle()
        sound2.title = "Sound Channel 2 (Square 2)"
        addSubview(sound2)
        sound2.snp.makeConstraints { make in
            make.left.equalTo(10)
            make.top.equalTo(sound1.snp.bottom)
        }
        sound2.onSwitchToggle = { isOn in
            self.updateSoundChannelStatus?(.channel2, isOn)
        }
        
        let sound3 = SwitchWithTitle()
        sound3.title = "Sound Channel 3 (Wave)"
        addSubview(sound3)
        sound3.snp.makeConstraints { make in
            make.left.equalTo(10)
            make.top.equalTo(sound2.snp.bottom)
        }
        sound3.onSwitchToggle = { isOn in
            self.updateSoundChannelStatus?(.channel3, isOn)
        }
        
        let sound4 = SwitchWithTitle()
        sound4.title = "Sound Channel 4 (Noise)"
        addSubview(sound4)
        sound4.snp.makeConstraints { make in
            make.left.equalTo(10)
            make.top.equalTo(sound3.snp.bottom)
        }
        sound4.onSwitchToggle = { isOn in
            self.updateSoundChannelStatus?(.channel4, isOn)
        }
    }
    
    func layerImageView(title: String) -> UIImageView {
        let v = UIImageView()
        v.backgroundColor = .gray
        v.snp.makeConstraints { make in
            make.width.height.equalTo(250)
        }
        
        let label = UILabel()
        label.alpha = 0.8
        label.backgroundColor = .gray
        label.textColor = .white
        label.text = title
        label.sizeToFit()
        v.addSubview(label)
        label.snp.makeConstraints { make in
            make.right.equalToSuperview()
            make.bottom.equalToSuperview()
        }
    
        return v
    }
    

}


