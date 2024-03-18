//
// Copyright (c) 2024, ___ORGANIZATIONNAME___ All rights reserved.
//
//

import SwiftUI

struct RippleLayerCircles: View {
  @Binding var isShow: Bool
  var number: Int
  var startColor: Color
  var endColor: Color
  var duration: Double
  var delay: Double
  var offsetDiff: Double

  @State private var isAnimating = false

  let colors: [CGColor]

  init(isShow: Binding<Bool>, number: Int, startColor: Color, endColor: Color, duration: Double, delay: Double, offsetDiff: Double) {
    self._isShow = isShow
    self.number = number
    self.startColor = startColor
    self.endColor = endColor
    self.duration = duration
    self.delay = delay
    self.offsetDiff = offsetDiff
    self.colors = generateGradientColors(startColor: startColor, endColor: endColor, numberOfColors: number)
      .map { $0.cgColor ?? CGColor(red: 0, green: 0, blue: 0, alpha: 0) }
  }

  var body: some View {
    ZStack {
      GeometryReader { proxy in
        CircleLayerView(number: number, colors: colors, duration: duration, delay: delay, offsetDiff: offsetDiff)
//          .frame(width: .infinity,height: .infinity)
          .frame(width: 200 ,height: 200)
      }
    }
  }
}


struct CircleLayerView: UIViewRepresentable {
 
  var number: Int
  var colors: [CGColor]
  var duration: Double
  var delay: Double
  var offsetDiff: Double

  func makeUIView(context: Context) -> UIRippleView {
    let view = UIRippleView()
//    view.setContentHuggingPriority(.required, for: .horizontal) // << here !!
//    view.setContentHuggingPriority(.required, for: .vertical)

    return view
  }


  func updateUIView(_ uiView: UIRippleView, context: Context) {
//    uiView.frame = frame
    uiView.strokeColor = colors[0]
    uiView.number = number
//    uiView.update()
//    uiView.frame = frame
  }
}

class UIRippleView: UIView {
  
  var number:Int = 0
  var strokeColor: CGColor = UIColor.black.cgColor
  var offsetDiff:Double = 5
  private var  layers:[CAShapeLayer] =  []
//  
//  override init(frame: CGRect) {
//    print("init frame=\(frame)")
//    super.init(frame: frame)
////    self.frame = frame
////    self.backgroundColor = UIColor.clear
//    initLanyer()
//  }
//  
//  required init?(coder aDecoder: NSCoder) {
//    print("init coder")
//    super.init(coder: aDecoder)
////    initLanyer()
//  }

  func initLanyer() {
    self.layer.borderWidth = 3
    self.layer.borderColor = UIColor.red.cgColor

    let duration = 5.0
   
    let delaybase = duration / Double(number) * 0.9
//    let delaybase = 0.1
    print("initLayer = \(frame)")
    layers = []
    for i in 0 ..< number {
      let layer = addCircleLayer(position: CGPoint(x: Double.random(in: -offsetDiff...offsetDiff), y: Double.random(in: -offsetDiff...offsetDiff)),
                      size: bounds.size,
                                  strokeColor: strokeColor,
                      duration: duration,
                      delay: delaybase * Double(i))
      
      layers.append(layer)
    }
  }

  func addCircleLayer(position: CGPoint, size: CGSize,
                       strokeColor: CGColor, duration: Double, delay: Double)->CAShapeLayer
  {
//    print("addCircleLanyer[\(i)]")
    let circleLayer = CAShapeLayer()
//    circleLayer.anchorPoint = CGPoint(x: 0.5, y: 0.5)
    circleLayer.position = position

    let circlePath = UIBezierPath(ovalIn: CGRect(origin: position, size: size))
    circleLayer.path = circlePath.cgPath
    circleLayer.strokeColor = strokeColor
    circleLayer.fillColor = UIColor.clear.cgColor
    circleLayer.opacity = 0

//        circleLayer.fillColor = UIColor.red.cgColor // 円の色を設定します

    self.layer.addSublayer(circleLayer)
    

//    let animation = CABasicAnimation(keyPath: "transform.scale")
//    animation.fromValue = 0
//    animation.toValue = 1
//    animation.duration = 3
    // animation.beginTime = CACurrentMediaTime() + 0.1
//    animation.timingFunction = CAMediaTimingFunction(name: .easeIn)
//
//    let groupAnimation = CAAnimationGroup()
//    groupAnimation.animations = [animation]
//    groupAnimation.duration = 3
//    groupAnimation.repeatCount = .infinity
//
//    circleLayer.add(groupAnimation, forKey: "scaleAnimation")

    let animationGroup = CAAnimationGroup()
    animationGroup.duration = 2.0
    animationGroup.beginTime = CACurrentMediaTime() + delay
    animationGroup.fillMode = CAMediaTimingFillMode.forwards
    animationGroup.repeatCount = .infinity
    animationGroup.isRemovedOnCompletion = false

    let animation1 = CABasicAnimation(keyPath: "transform.scale")
    animation1.fromValue = 0
    animation1.toValue = 1.0

    let animation2 = CABasicAnimation(keyPath: "opacity")
    animation2.fromValue = 1.0
    animation2.toValue = 0.0

    let animation3 = CABasicAnimation(keyPath: "position")
    animation3.fromValue = [bounds.midX, bounds.midY]
    animation3.toValue = [position.x, position.y]
//    CGPoint(x: bounds.midX, y: bounds.midY)

//    let animation3 = CABasicAnimation(keyPath: "transform.rotation")
//    animation3.fromValue = 0.0
//    animation3.toValue = Double.pi * 2.0
//    animation3.speed = 1.0

    animationGroup.animations = [animation1, animation2, animation3]
    circleLayer.add(animationGroup, forKey: nil)
//    circleLayer.add(animation, forKey: nil)
    return circleLayer
  }
  
  override func layoutSubviews() {
    print("layoutSubviews = \(frame)")
    
     
      initLanyer()
   
  }
  
   
  
}







struct RIppleLayerView: View {
  @State var isShow = true
  let color = Color(#colorLiteral(red: 0, green: 0.6230022509, blue: 1, alpha: 0.8020036139))
  let startColor = Color(#colorLiteral(red: 0, green: 0.6230022509, blue: 1, alpha: 0.8020036139))
  let endColor = Color(#colorLiteral(red: 0.05724914705, green: 0, blue: 1, alpha: 0.7992931548))
  let duration = 2.0
  let rippleNum = 10

  var body: some View {
    VStack {
      ZStack {
        RippleLayerCircles(isShow: $isShow, number: rippleNum, startColor: startColor, endColor: endColor, duration: duration, delay: duration / Double(rippleNum), offsetDiff: 3)
          .frame(width: 200, height: 200)

        //          .border(Color.green)
        Button(action: {
          isShow.toggle()
        }) {
          Text(isShow ? "Stop" : "Start")

            .font(.caption2)
            .foregroundColor(.white)
            .frame(width: 50, height: 20)
            //            .padding()
            .background(isShow ? Color.red : Color.blue)
            .cornerRadius(40)
        }
        //      .padding(.top, 50)
      }

      Text("isShow = \(isShow)")
    }
    .padding()
  }
}

#Preview {
  RIppleLayerView()
}
