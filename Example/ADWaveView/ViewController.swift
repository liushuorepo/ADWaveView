//
//  ViewController.swift
//  ADWaveView
//
//  Created by 13124832031@163.com on 02/19/2019.
//  Copyright (c) 2019 13124832031@163.com. All rights reserved.
//

import UIKit
import ADWaveView

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        view.addSubview(wave)
        view.addSubview(imgView)
        view.addSubview(button)
        
        // 根据传回的centerY值修改小船的Y坐标
        wave.waveFloatCenterYBlock = { [weak self] (centerY) in
            if let weakSelf = self {
                var frame = weakSelf.imgView.frame
                frame.origin.y = 400 - 60 - 5 + centerY
                weakSelf.imgView.frame = frame
            }
        }
    }
    
    /// ADWave对象
    lazy var wave: ADWave = {
        let wave = ADWave(frame: CGRect(x: 0, y: 0, width: view.frame.size.width, height: 400))
        wave.backgroundColor = UIColor.blue
        wave.waveHeight = 5
        wave.waveSpeed = 5
        return wave
    }()
    
    /// 小船对象
    lazy var imgView: UIImageView = {
        let img = UIImageView(frame: CGRect(x: view.frame.size.width / 2.0 - 30, y: 400 - 60, width: 60, height: 60))
        img.image = #imageLiteral(resourceName: "ship")
        img.contentMode = .scaleAspectFill
        img.layer.cornerRadius = 30
        img.clipsToBounds = true
        img.layer.borderWidth = 1
        img.layer.borderColor = UIColor.red.cgColor
        return img
    }()
    
    /// 按钮
    lazy var button: UIButton = {
        let btn = UIButton(type: .custom)
        btn.backgroundColor = UIColor.red
        btn.frame = CGRect(x: view.frame.size.width / 2.0 - 50, y: 500, width: 100, height: 40)
        btn.setTitle("开始浪", for: .normal)
        btn.addTarget(self, action: #selector(Action(_:)), for: .touchUpInside)
        return btn
    }()
    
    @objc func Action(_ sender: UIButton) {
        wave.startWave()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

