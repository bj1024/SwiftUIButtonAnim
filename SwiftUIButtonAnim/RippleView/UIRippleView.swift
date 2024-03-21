//
// Copyright (c) 2024, -  All rights reserved.
//
//

import Foundation

import UIKit

func createGradientColors(from startColor: UIColor, to endColor: UIColor, withCount count: Int) -> [UIColor] {
  var gradientColors = [UIColor]()

  // Ensure count is at least 2 to create a gradient
  guard count > 1 else {
    return gradientColors
  }

  // Convert start and end colors to RGB components
  guard let startComponents = startColor.cgColor.components,
        let endComponents = endColor.cgColor.components
  else {
    return gradientColors
  }

  // Calculate the color difference between start and end colors
  let stepR = (endComponents[0] - startComponents[0]) / CGFloat(count - 1)
  let stepG = (endComponents[1] - startComponents[1]) / CGFloat(count - 1)
  let stepB = (endComponents[2] - startComponents[2]) / CGFloat(count - 1)

  // Generate gradient colors
  for i in 0 ..< count {
    let color = UIColor(red: startComponents[0] + (stepR * CGFloat(i)),
                        green: startComponents[1] + (stepG * CGFloat(i)),
                        blue: startComponents[2] + (stepB * CGFloat(i)),
                        alpha: 1.0)
    gradientColors.append(color)
  }

  return gradientColors
}

class UIRippleView: UIView {
  var isShow: Bool = true

//  var strokeColor: CGColor = UIColor.black.cgColor

  var circleColors: [UIColor] = [UIColor.blue]
  private var nextCircleColorIndex:Int = 0

  var numberOfCircles: Int = 20

  
//  private var baseLayer: CALayer = CALayer()
  private var rootLayer: CALayer = .init()
//  private var shapeLayers: [CAShapeLayer] = []
  private var offsetDiff: Double = 10

  
  
  
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

    return
//    // Create a new layer
//    let circleLayer = CAShapeLayer()
//    circleLayer.bounds = CGRect(x: 0, y: 0, width: 100, height: 100)
//    circleLayer.position = center
//    circleLayer.borderColor = UIColor.yellow.cgColor
//    circleLayer.borderWidth = 1.0
//    layer.addSublayer(circleLayer)
//
//    // Create circle path
//    let radius: CGFloat = 50
////    let circlePath = UIBezierPath(arcCenter: CGPoint(x: circleLayer.bounds.midX, y: circleLayer.bounds.midY), radius: radius, startAngle: 0, endAngle: CGFloat(Double.pi * 2), clockwise: true)
////
//    let shapePath = UIBezierPath(ovalIn: CGRect(x: 0, y: 0, width: 100, height: 100))
//
//    // Set path
//    circleLayer.path = shapePath.cgPath
//    circleLayer.fillColor = UIColor.clear.cgColor
//    circleLayer.strokeColor = UIColor.green.cgColor
//    circleLayer.lineWidth = 2.0
//
//    // Animate the layer
//    let animation = CABasicAnimation(keyPath: "transform.scale")
//    animation.fromValue = 0
//    animation.toValue = 1
//    animation.duration = 2
//    animation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
//    animation.fillMode = .both
//    animation.isRemovedOnCompletion = false
//    circleLayer.add(animation, forKey: "scaleAnimation")
  }

  func update() {
    guard isShow else {
      return
    }

//    let colors = createGradientColors(from: startColor, to: endColor, withCount: numberOfCircles)

    self.layer.borderWidth = 1
    self.layer.borderColor = UIColor.lightGray.cgColor
    rootLayer.borderWidth = 1
    rootLayer.borderColor = UIColor.green.cgColor

//    shapeLayers.forEach { $0.removeFromSuperlayer() }
//    shapeLayers = []

    let duration = 3.0
    let delay = (duration * 0.7) / Double(numberOfCircles)
    let currentCircleNum = rootLayer.sublayers?.count ?? 0
//    print("currentCircleNum = \(currentCircleNum),   numberOfCircles = \(numberOfCircles)")
    let circleNum = max(numberOfCircles - currentCircleNum,0)
    
    print("currentCircleNum = \(currentCircleNum),   circleNum = \(circleNum)")
    // Create circle layers
    for i in 0 ..< circleNum {
      print(" insrt i = \(i)")
      let shapeLayer = CAShapeLayer()
      let shapePath = UIBezierPath(
        ovalIn: CGRect(origin: CGPoint(x: -1.0 * bounds.midX,
                                       y: -1.0 * bounds.midY), size: bounds.size))

      shapeLayer.position = center
      shapeLayer.path = shapePath.cgPath
      
      var strokeCGColor = UIColor.blue.cgColor
      if circleColors.count > nextCircleColorIndex {
        strokeCGColor = circleColors[nextCircleColorIndex].cgColor
        nextCircleColorIndex+=1
      }
      if nextCircleColorIndex >= circleColors.count {
        nextCircleColorIndex = 0
      }
      
      shapeLayer.strokeColor = strokeCGColor
      
      shapeLayer.lineWidth = 2
      shapeLayer.fillColor = UIColor.clear.cgColor
      shapeLayer.opacity = 0

      let animation1 = CABasicAnimation(keyPath: "transform.scale")
      animation1.fromValue = 0
      animation1.toValue = 1.0

      let animation2 = CABasicAnimation(keyPath: "opacity")
      animation2.fromValue = 1.0
      animation2.toValue = 0.0

      let animGroup = CAAnimationGroup()
      animGroup.repeatCount = 1
      animGroup.isRemovedOnCompletion = false

      animGroup.duration = duration
      animGroup.beginTime = CACurrentMediaTime() + delay * Double(i)
      animGroup.animations = [animation1, animation2]

      animGroup.setValue("ripple", forKey: "animId")
      animGroup.setValue(shapeLayer, forKey: "parentLayer")
      animGroup.delegate = self

      shapeLayer.add(animGroup, forKey: "ripple")

      rootLayer.addSublayer(shapeLayer)
//      shapeLayers.append(shapeLayer)
    }

//    startAnimation()
//    let duration = 5.0
//    let delaybase = duration / Double(number) * 0.9
//    print("initLayer = \(frame)")
//    layers = []
//    for i in 0 ..< number {
//      let layer = addCircleLayer(position: CGPoint(x: Double.random(in: -offsetDiff...offsetDiff), y: Double.random(in: -offsetDiff...offsetDiff)),
//                                 size: bounds.size,
//                                 strokeColor: strokeColor,
//                                 duration: duration,
//                                 delay: delaybase * Double(i))
//
//      layers.append(layer)
//    }
//    self.layer.addSublayer(baseLayer)
  }
//
//  func startAnimation() {
//    guard !isAnimating else { return }
//    isAnimating = true
//
//    let duration = 3.0
//    let delay = (duration * 0.7) / Double(numberOfCircles)
//
//    for (index, shapeLayer) in shapeLayers.enumerated() {
//
//      let animation1 = CABasicAnimation(keyPath: "transform.scale")
//      animation1.fromValue = 0
//      animation1.toValue = 1.0
//
//      let animation2 = CABasicAnimation(keyPath: "opacity")
//      animation2.fromValue = 1.0
//      animation2.toValue = 0.0
//
//
//      let animGroup = CAAnimationGroup()
//      animGroup.repeatCount = 1
//      animGroup.isRemovedOnCompletion = false
//
//      animGroup.duration = duration
//      animGroup.beginTime = CACurrentMediaTime() + delay * Double(index)
//      animGroup.animations = [animation1, animation2]
//
//      animGroup.setValue("ripple", forKey: "animId")
//      animGroup.setValue(shapeLayer, forKey: "parentLayer")
//      animGroup.delegate = self
  ////      shapeLayer.add(animGroup, forKey: "ripple")
//    }
//  }

//  func stopAnimation() {
//    guard isAnimating else { return }
//    isAnimating = false
//    for shapeLayer in shapeLayers {
//      shapeLayer.removeAllAnimations()
  ////      if let key = shapeLayer.animationKeys()?.first {
//      ////        shapeLayer.pauseAnimation(forKey: key)
  ////      }
//    }
//  }

//  func removeAllLayers() {
//    // layerがあればfadeoutさせ、removeFromSuperlayerで取り除く
//    print("removeAllLayers")
//    // layers.forEach {
//
//    let animation = CABasicAnimation(keyPath: "opacity")
//    animation.fromValue = 1
//    animation.toValue = 0
//    animation.duration = 3
//    animation.timingFunction = CAMediaTimingFunction(name: .easeIn)
//    animation.isRemovedOnCompletion = false
//    animation.repeatCount = 1
//    animation.setValue("baseLayerFadeout", forKey: "animId")
//    animation.setValue(baseLayer, forKey: "parentLayer")
//    animation.delegate = self
//    baseLayer.add(animation, forKey: "baseLayerFadeout")
//    // }
//    DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
//      // self.layers.forEach {
//      //   // layerを削除
//      //   $0.removeFromSuperlayer()
//      // }
//      // self.layers = []
  ////      self.baseLayer.removeFromSuperlayer()
  ////      self.baseLayer = CALayer()
//
//      print("removeAllLayers remove")
//      for layer in self.layers {
//        // layerを削除
//        print("removeAllLayers remove layer")
//
//        layer.removeAllAnimations()
//        layer.removeFromSuperlayer()
//      }
//
//      self.layers = []
//    }
//
//    //
  ////    layers.forEach {
  ////      let animation = CABasicAnimation(keyPath: "opacity")
  ////      animation.fromValue = 1
  ////      animation.toValue = 0
  ////      animation.duration = 1
  ////      animation.timingFunction = CAMediaTimingFunction(name: .easeIn)
  ////      $0.add(animation, forKey: "fadeOut")
  ////      $0.opacity = 0
  ////    }
//
  ////
  ////    layers.forEach {
  ////      // layerを削除
  ////      $0.removeFromSuperlayer()
  ////    }
  ////
  ////    layers = []
//  }
//
//  func createAnim(position: CGPoint, delay: Double) -> CAAnimationGroup {
//    let animGroup = CAAnimationGroup()
//    animGroup.duration = 2.0
//    animGroup.beginTime = CACurrentMediaTime() + delay
//    animGroup.fillMode = CAMediaTimingFillMode.forwards
//    animGroup.repeatCount = 1
//    animGroup.isRemovedOnCompletion = false
//
//    let animation1 = CABasicAnimation(keyPath: "transform.scale")
//    animation1.fromValue = 0
//    animation1.toValue = 1.0
//
//    let animation2 = CABasicAnimation(keyPath: "opacity")
//    animation2.fromValue = 1.0
//    animation2.toValue = 0.0
//
//    let animation3 = CABasicAnimation(keyPath: "position")
//    animation3.fromValue = [bounds.midX, bounds.midY]
//    animation3.toValue = [position.x, position.y]
//
//    animGroup.animations = [animation1, animation2, animation3]
//
//    return animGroup
//  }

//
//  func addCircleLayer(position: CGPoint, size: CGSize,
//                      strokeColor: CGColor, duration: Double, delay: Double) -> CAShapeLayer
//  {
  ////    print("addCircleLanyer[\(i)]")
//    let circleLayer = CAShapeLayer()
  ////    circleLayer.anchorPoint = CGPoint(x: 0.5, y: 0.5)
//    circleLayer.position = position
//
//    let circlePath = UIBezierPath(ovalIn: CGRect(origin: position, size: size))
//    circleLayer.path = circlePath.cgPath
//    circleLayer.strokeColor = strokeColor
//    circleLayer.lineWidth = 10
//    circleLayer.fillColor = UIColor.clear.cgColor
//    circleLayer.opacity = 0
//
  ////        circleLayer.fillColor = UIColor.red.cgColor // 円の色を設定します
//
//    baseLayer.addSublayer(circleLayer)
//
  ////    let animation = CABasicAnimation(keyPath: "transform.scale")
  ////    animation.fromValue = 0
  ////    animation.toValue = 1
  ////    animation.duration = 3´˝
//    // animation.beginTime = CACurrentMediaTime() + 0.1
  ////    animation.timingFunction = CAMediaTimingFunction(name: .easeIn)
  ////
  ////    let groupAnimation = CAAnimationGroup()
  ////    groupAnimation.animations = [animation]
  ////    groupAnimation.duration = 3
  ////    groupAnimation.repeatCount = .infinity
  ////
  ////    circleLayer.add(groupAnimation, forKey: "scaleAnimation")
//
//    let animGroup = createAnim(position: position, delay: delay)
//    animGroup.setValue("ripple", forKey: "animId")
//    animGroup.setValue(circleLayer, forKey: "parentLayer")
//    animGroup.delegate = self
//    circleLayer.add(animGroup, forKey: "ripple")
//    return circleLayer
//  }
}

// アニメーション終了検知
extension UIRippleView: CAAnimationDelegate {
  func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
    var animId = ""
    if let id = anim.value(forKey: "animId") as? String {
      animId = id
    }
    print("animation DidStop \(flag ? "true" : "false") id=[\(animId)]")
    if flag, let layer = anim.value(forKey: "parentLayer") as? CALayer {
      layer.removeAllAnimations()
      layer.removeFromSuperlayer()
      let lnum = rootLayer.sublayers?.count ?? 0
      print("layer removeAnimation \(lnum) \(animId)")
//      update()
      if isShow{
        update()
      }
    }
  }
}
