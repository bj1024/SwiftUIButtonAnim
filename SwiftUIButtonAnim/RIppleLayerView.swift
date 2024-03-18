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
      .map { $0.cgColor ?? CGColor.init(red: 0, green: 0, blue: 0, alpha: 0)}
  }

  var body: some View {
    ZStack {
      if isShow {
        CircleLayerView(number: number, colors: colors, duration: duration, delay: delay, offsetDiff: offsetDiff)
      }
    }
    .onAppear {
      isAnimating = true
    }
    .onDisappear {
      isAnimating = false
    }
  }
}

struct CircleLayerView: UIViewRepresentable {
  var number: Int
  var colors: [CGColor]
  var duration: Double
  var delay: Double
  var offsetDiff: Double

  func makeUIView(context: Context) -> UIView {
    let containerView = UIView()
    let containerLayer = CALayer()
    containerView.layer.addSublayer(containerLayer)

    for i in 0..<number {
      let circleLayer = CAShapeLayer()
      let diameter = CGFloat.random(in: 30...100)
      let circlePath = UIBezierPath(ovalIn: CGRect(x: 0, y: 0, width: diameter, height: diameter))
      circleLayer.path = circlePath.cgPath
      circleLayer.fillColor = UIColor.clear.cgColor
      circleLayer.strokeColor = colors[i % colors.count]
      circleLayer.lineWidth = CGFloat.random(in: 1.0...3.0)

      let animation = CABasicAnimation(keyPath: "transform.scale")
      animation.fromValue = 0
      animation.toValue = 1
      animation.duration = duration
      animation.beginTime = CACurrentMediaTime() + delay * Double(i)
      animation.timingFunction = CAMediaTimingFunction(name: .easeIn)

      let groupAnimation = CAAnimationGroup()
      groupAnimation.animations = [animation]
      groupAnimation.duration = duration + delay * Double(number - 1)
      groupAnimation.repeatCount = .infinity

      circleLayer.add(groupAnimation, forKey: "scaleAnimation")

      let randomX = CGFloat.random(in: -offsetDiff...offsetDiff)
      let randomY = CGFloat.random(in: -offsetDiff...offsetDiff)
      circleLayer.position = CGPoint(x: containerView.bounds.midX + randomX, y: containerView.bounds.midY + randomY)

      containerLayer.addSublayer(circleLayer)
    }

    return containerView
  }

  func updateUIView(_ uiView: UIView, context: Context) {}
}

//func generateGradientColors(startColor: Color, endColor: Color, numberOfColors: Int) -> [Color] {
//  let startComponents = startColor.cgColor.components ?? []
//  let endComponents = endColor.cgColor.components ?? []
//
//  var colors: [Color] = []
//
//  for i in 0..<numberOfColors {
//    let progress = CGFloat(i) / CGFloat(numberOfColors - 1)
//    let r = startComponents[0] + (endComponents[0] - startComponents[0]) * progress
//    let g = startComponents[1] + (endComponents[1] - startComponents[1]) * progress
//    let b = startComponents[2] + (endComponents[2] - startComponents[2]) * progress
//    let color = Color(red: Double(r), green: Double(g), blue: Double(b))
//    colors.append(color)
//  }
//
//  return colors
//}

struct RIppleLayerView: View {
  @State var isShow = true
  let color = Color(#colorLiteral(red: 0, green: 0.6230022509, blue: 1, alpha: 0.8020036139))
  let startColor = Color(#colorLiteral(red: 0, green: 0.6230022509, blue: 1, alpha: 0.8020036139))
  let endColor = Color(#colorLiteral(red: 0.05724914705, green: 0, blue: 1, alpha: 0.7992931548))
  let duration = 2.0
  let rippleNum = 8

  var body: some View {
    VStack {
      ZStack {
        RippleLayerCircles(isShow: $isShow, number: rippleNum, startColor: startColor, endColor: endColor, duration: duration, delay: duration / Double(rippleNum), offsetDiff: 3)
          .frame(width: 150, height: 150)
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
