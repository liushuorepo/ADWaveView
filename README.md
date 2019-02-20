# ADWaveView

[![CI Status](https://img.shields.io/travis/13124832031@163.com/ADWaveView.svg?style=flat)](https://travis-ci.org/13124832031@163.com/ADWaveView)
[![Version](https://img.shields.io/cocoapods/v/ADWaveView.svg?style=flat)](https://cocoapods.org/pods/ADWaveView)
[![License](https://img.shields.io/cocoapods/l/ADWaveView.svg?style=flat)](https://cocoapods.org/pods/ADWaveView)
[![Platform](https://img.shields.io/cocoapods/p/ADWaveView.svg?style=flat)](https://cocoapods.org/pods/ADWaveView)

## Example

To run the example project, clone the repo, and run `pod install` from the Example directory first.

## Requirements

iOS 8.0，Swift4.0 以上

## Installation

ADWaveView is available through [CocoaPods](https://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod 'ADWaveView'
```

## 理论准备：三角函数

正弦函数：y = Asin（ωx+φ）+ C
A 表示振幅，也就是使用这个变量来调整波浪的最大的高度
ω 与周期相关，周期 T = 2 x pi / ω ，这个变量用来调整同宽度内显示的波浪的数量
φ 表示波浪横向的偏移，也就是使用这个变量来调整波浪的流动
C 表示波浪纵向偏移的位置

CADisplayLink：一种精确到帧的定时器，其原理是利用刷帧和屏幕频率来重绘渲染画面

## 实现思路

1. 自定义 View
2. 使用 CGMutablePath 和 CAShapeLayer 绘制静态正弦函数
3. 使用帧显示类 CADisplayLink，不断刷新路径上的各个点，让波浪动起来
4. 回调每一帧的中点值，动态改变随浪而动的自定义视图

## 核心代码

```ruby
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
```

## Author

13124832031@163.com, liushuo@alaxiaoyou.com

## License

ADWaveView is available under the MIT license. See the LICENSE file for more info.
