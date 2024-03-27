//
// Copyright (c) 2024, -  All rights reserved.
//
//

import Foundation

import UIKit

class UIBlendLayerView: UIView {
  var cgImage:CGImage?
  private var imageLayer =  CALayer()
  private var shapeLayer = CAShapeLayer()
  private var imageFilterLayer = CALayer()
  private var filterLayer =  CALayer()


  override init(frame: CGRect) {
    super.init(frame: frame)
    setup()
  }

  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    setup()
  }

  private func setup() {

    layer.addSublayer(imageLayer)
    layer.addSublayer(filterLayer)
    filterLayer.addSublayer(shapeLayer)
    filterLayer.addSublayer(imageFilterLayer)

  }

  override func layoutSubviews() {
    super.layoutSubviews()
    print("layoutSubviews = \(frame)")
    update()
  }

  func update() {
    guard let cgImage = cgImage else { return }

    imageLayer.contents = cgImage
    let frameSize = cgImage.width >= cgImage.height ? 
    CGSize(width: bounds.width, height: bounds.height * CGFloat(cgImage.height) / CGFloat(cgImage.width)) :
    CGSize(width: bounds.width * CGFloat(cgImage.width) / CGFloat(cgImage.height), height: bounds.height)
    
    imageLayer.frame = CGRect(x: 0, y: 0, width: frameSize.width, height: frameSize.height)
    print("layer = \(layer.frame) \(cgImage.width),\(cgImage.height)")

    imageFilterLayer.contents = cgImage
    imageFilterLayer.frame = imageLayer.frame
    imageFilterLayer.opacity = 0.5

    if let compositingFilter = CIFilter(name: "CIColorMonochrome") {
      print("CIColorMonochrome")
      imageFilterLayer.compositingFilter = compositingFilter
    }
    imageFilterLayer.compositingFilter = "colorDodgeBlendMode"
  

    let shapePath = UIBezierPath(
      ovalIn: CGRect(origin: CGPoint(x: 0, y: 0),
                     size: CGSize(width: 100,height: 100)))
    shapeLayer.path = shapePath.cgPath
    shapeLayer.strokeColor = UIColor.white.withAlphaComponent(0.7).cgColor
    shapeLayer.fillColor = UIColor.clear.cgColor
    shapeLayer.lineWidth = 2.0
    shapeLayer.shadowColor = UIColor.black.cgColor
    shapeLayer.shadowOffset = CGSize(width: 04, height: 4)
    shapeLayer.shadowOpacity = 0.8
    shapeLayer.shadowRadius = 3
    
    shapeLayer.shadowPath = shapePath.cgPath
    shapeLayer.position = CGPoint(x: bounds.midX, y: bounds.midY)
    shapeLayer.opacity = 0.5
    if let compositingFilter = CIFilter(name: "CIColorMonochrome") {
      shapeLayer.compositingFilter = compositingFilter
    }
    filterLayer.compositingFilter = "colorDodgeBlendMode"

    
//    
//    
//    let animation1 = CABasicAnimation(keyPath: "opacity")
//    animation1.fromValue = 0.0
//    animation1.toValue = 1.0


    let animation = CABasicAnimation(keyPath: "opacity")
    animation.fromValue = 1.0
    animation.toValue = 0.0


    

    let animGroup = CAAnimationGroup()
    animGroup.repeatCount = .infinity
    animGroup.autoreverses = true
    animGroup.isRemovedOnCompletion = false

    animGroup.duration = 3
//      print("[\(i)]=\(delay * Double(i + 1))")
//    animGroup.beginTime = currentMediaTime + delay * Double(i + 1)
    animGroup.animations = [ animation]
//      animGroup.animations = [animation1, animation2, animation3]

    animGroup.setValue("ripple", forKey: "animId")
    animGroup.setValue(shapeLayer, forKey: "parentLayer")
    animGroup.delegate = self
    imageFilterLayer.add(animGroup, forKey: "ripple")
    
    let animation2 = CABasicAnimation(keyPath: "opacity")
    animation2.fromValue = 0.1
    animation2.toValue = 1.0
    animation2.duration = 3
    animation2.autoreverses = true

    shapeLayer.add(animation2, forKey: "ripple")
  
    
   
  }
}

// アニメーション終了検知
extension UIBlendLayerView: CAAnimationDelegate {
  func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
    if flag, let layer = anim.value(forKey: "parentLayer") as? CALayer {
      layer.removeAllAnimations()
      layer.removeFromSuperlayer()
      DispatchQueue.main.asyncAfter(deadline: .now()) {
//        self.update()
      }
    }
  }
}
