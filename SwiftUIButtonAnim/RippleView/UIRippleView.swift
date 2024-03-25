//
// Copyright (c) 2024, -  All rights reserved.
//
//

import Foundation

import UIKit

class UIRippleView: UIView {
  var isShow: Bool = true
  var lineWidthRange: ClosedRange<Double> = 1...2
  var circleColors: [UIColor] = [UIColor.blue]
  var numberOfCircles: Int = 1
  var duration: Double = 2.0
  var delay: Double = 0.5
  var interval: Double = 0.5
  var positionDiff: Double = 10

  private var nextCircleColorIndex: Int = 0
  private var rootLayer: CALayer = .init()

  override init(frame: CGRect) {
    super.init(frame: frame)
    setup()
  }

  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    setup()
  }

  private func setup() {
    layer.addSublayer(rootLayer)
  }

  override func layoutSubviews() {
    super.layoutSubviews()
    print("layoutSubviews = \(frame)")
    update()
  }

  func update() {
    guard isShow else {
      return
    }

//    self.layer.borderWidth = 1
//    self.layer.borderColor = UIColor.lightGray.cgColor
//    rootLayer.borderWidth = 1
//    rootLayer.borderColor = UIColor.green.cgColor

    let currentCircleNum = rootLayer.sublayers?.count ?? 0
//    print("currentCircleNum = \(currentCircleNum),   numberOfCircles = \(numberOfCircles)")
    let circleNum = max(numberOfCircles - currentCircleNum, 0)

    let currentMediaTime = CACurrentMediaTime()
    print("currentCircleNum = \(currentCircleNum),   circleNum = \(circleNum)")
    // Create circle layers
    for i in 0 ..< circleNum {
//      print(" insrt i = \(i)")
      let shapeLayer = CAShapeLayer()
      let shapePath = UIBezierPath(
        ovalIn: CGRect(origin: CGPoint(x: 0,
                                       y: 0), size: CGSize.zero))

      shapeLayer.position = CGPoint(x: bounds.midX + Double.random(in: -positionDiff...positionDiff),
                                    y: bounds.midY + Double.random(in: -positionDiff...positionDiff))
      shapeLayer.path = shapePath.cgPath

      var strokeCGColor = UIColor.blue.cgColor
      if circleColors.count > nextCircleColorIndex {
        strokeCGColor = circleColors[nextCircleColorIndex].cgColor
        nextCircleColorIndex += 1
      }
      if nextCircleColorIndex >= circleColors.count {
        nextCircleColorIndex = 0
      }

      shapeLayer.strokeColor = strokeCGColor

      ///      shapeLayer.lineWidth = Double.random(in: lineWidthRange)
      let lineWidth = Double.random(in: lineWidthRange).rounded(.toNearestOrAwayFromZero)
//      print("lineWidth=\(lineWidth)")
      shapeLayer.lineWidth = lineWidth
      shapeLayer.fillColor = UIColor.clear.cgColor
      shapeLayer.opacity = 0

//      let animation1 = CABasicAnimation(keyPath: "transform.scale")
//      animation1.fromValue = 0
//      animation1.toValue = 1.0
      let animation1 = CABasicAnimation(keyPath: "path")
      let shapePath2 = UIBezierPath(
        ovalIn: CGRect(origin: CGPoint(x: -1.0 * bounds.midX,
                                       y: -1.0 * bounds.midY),
                       size: bounds.size))

//      animation1.fromValue = shapePath.cgPath
      animation1.toValue = shapePath2.cgPath

      let animation2 = CABasicAnimation(keyPath: "opacity")
      animation2.fromValue = 1.0
      animation2.toValue = 0.0

      let animation3 = CABasicAnimation(keyPath: "lineWidth")
      animation3.toValue = 1.0

      let animGroup = CAAnimationGroup()
      animGroup.repeatCount = 1
      animGroup.isRemovedOnCompletion = false

      animGroup.duration = duration
//      print("[\(i)]=\(delay * Double(i + 1))")
      animGroup.beginTime = currentMediaTime + delay * Double(i + 1)
      animGroup.animations = [animation1, animation2]
//      animGroup.animations = [animation1, animation2, animation3]

      animGroup.setValue("ripple", forKey: "animId")
      animGroup.setValue(shapeLayer, forKey: "parentLayer")
      animGroup.delegate = self

      shapeLayer.add(animGroup, forKey: "ripple")

      rootLayer.addSublayer(shapeLayer)
    }
  }
}

// アニメーション終了検知
extension UIRippleView: CAAnimationDelegate {
  func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
//    var animId = ""
//    if let id = anim.value(forKey: "animId") as? String {
//      animId = id
//    }
//    print("animation DidStop \(flag ? "true" : "false") id=[\(animId)]")
    if flag, let layer = anim.value(forKey: "parentLayer") as? CALayer {
      layer.removeAllAnimations()
      layer.removeFromSuperlayer()
//      let lnum = rootLayer.sublayers?.count ?? 0
//      print("layer removeAnimation \(lnum) \(animId)")

      if isShow {
        // + interval 遅れて次を表示
        DispatchQueue.main.asyncAfter(deadline: .now() + interval) {
          self.update()
        }
      }
    }
  }
}
