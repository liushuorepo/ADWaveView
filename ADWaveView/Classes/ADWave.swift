//
//  ADWave.swift
//  ADWaveView
//
//  Created by Andy on 2019/2/19.
//

import UIKit

public class ADWave: UIView {

    // 设置参数
    /// 浪高 默认为5
    public var waveHeight: CGFloat = 5
    /// 浪曲度 默认为1
    public var waveCurve: CGFloat = 1
    /// 浪速 默认为1
    public var waveSpeed: CGFloat = 1
    /// 偏移 默认为0
    public var offset: CGFloat = 0
    /// 实浪颜色 默认为白色
    public var realWaveColor: UIColor = .white
    /// 遮罩浪颜色 默认为白色+0.5的透明度
    public var maskWaveColor: UIColor = UIColor.white.withAlphaComponent(0.5)
    /// 浮动的中间Y值的回调
    public var waveFloatCenterYBlock: ((CGFloat)->())?
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        initLayer()
    }
    
    public required init?(coder aDecoder: NSCoder) {
        // fatalError("init(coder:) has not been implemented")
        super.init(coder: aDecoder)
        initLayer()
    }
    
    /// 初始化图层
    private func initLayer() {
        // 添加图层
        layer.addSublayer(realWaveShapeLayer)
        layer.addSublayer(maskWaveShapeLayer)
    }
    
    /// 获取frame
    private func getFrame() -> CGRect {
        var frame = bounds
        frame.origin.y = frame.size.height - waveHeight;
        frame.size.height = waveHeight;
        return frame;
    }
    
    /// 波浪核心代码
    @objc func wave() {
        // 每次循环变动
        offset += waveSpeed
        
        let width = frame.size.width
        let height = waveHeight
        
        // 浮动的中间Y值的回调
        let centerX = width / 2.0
        let centerY = height * sin(waveCurve * centerX * CGFloat.pi / 180 + offset * CGFloat.pi / 180)
        if let block = waveFloatCenterYBlock {
            block(centerY)
        }
        
        // 创建真浪
        createWave(waveShapeLayer: realWaveShapeLayer, width: width, height: height, offset: offset, waveColor: realWaveColor)
        // 创建遮罩浪
        createWave(waveShapeLayer: maskWaveShapeLayer, width: width, height: height, offset: offset * 0.7, waveColor: maskWaveColor)
    }
    /// 创建浪
    private func createWave(waveShapeLayer: CAShapeLayer, width: CGFloat, height: CGFloat, offset: CGFloat, waveColor: UIColor) {
        // 创建浪的路径
        let wavePath = CGMutablePath()
        
        // 创建一个起点
        wavePath.move(to: CGPoint(x: 0, y: height))
        
        // 创建中间点
        for x in 0..<Int(width) {
            // y = Asin（ωx+φ）
            let y = height * sin(waveCurve * CGFloat(x) * CGFloat.pi / 180 + offset * CGFloat.pi / 180)
            wavePath.addLine(to: CGPoint(x: CGFloat(x), y: CGFloat(y)))
        }
        
        // 调整填充路径
        wavePath.addLine(to: CGPoint(x: width, y: height))
        wavePath.addLine(to: CGPoint(x: 0, y: height))
        
        // 结束路径
        wavePath.closeSubpath()
        
        // 用路径创建浪
        waveShapeLayer.path = wavePath
        waveShapeLayer.fillColor = waveColor.cgColor
        
    }
    
    /// 开始浪
    public func startWave() {
        displayLink.add(to: RunLoop.current, forMode: .commonModes)
    }
    
    /// 结束浪
    public func endWave() {
        displayLink.invalidate()
    }
    
    // 懒加载
    /// 实浪
    lazy var realWaveShapeLayer: CAShapeLayer = {
        let layer = CAShapeLayer()
        layer.frame = getFrame()
        return layer
    }()
    /// 遮罩浪
    lazy var maskWaveShapeLayer: CAShapeLayer = {
        let layer = CAShapeLayer()
        layer.frame = getFrame()
        return layer
    }()
    /// 帧对象
    lazy var displayLink: CADisplayLink = {
        let link = CADisplayLink(target: self, selector: #selector(wave))
        return link
    }()
    

}

