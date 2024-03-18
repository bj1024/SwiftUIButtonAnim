//
// Copyright (c) 2024, ___ORGANIZATIONNAME___ All rights reserved.
//
//

import SwiftUI

extension Animation {
  func `repeat`(while expression: Bool, autoreverses: Bool = true) -> Animation {
    if expression {
      return self.repeatForever(autoreverses: autoreverses)
    } else {
      return self
    }
  }
}

struct RippleButton2: View {
  @State private var rippleOpacity: Double = 1.0
  @State private var rippleScale: CGFloat = 1.0
  @State private var isRippleActive = false

  var body: some View {
    Button(action: {
      withAnimation {
        rippleOpacity = 0.5
        rippleScale = 10.0
        isRippleActive = true
      }
      DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
        withAnimation {
          rippleOpacity = 0.0
          isRippleActive = false
        }
      }
    }) {
      Text("Tap me")
        .foregroundColor(.white)
        .padding()
        .background(Color.blue)
        .clipShape(RoundedRectangle(cornerRadius: 10))
    }
    .overlay(
      Circle()
        .stroke(Color.red.opacity(rippleOpacity), lineWidth: 2)
        .scaleEffect(rippleScale)
        .opacity(isRippleActive ? 1.0 : 1.0)
    )
  }
}

struct RippleButton3: View {
  @State private var isAnimating = true

  var body: some View {
    VStack {
      Button(action: {
        // ボタンがタップされた時の処理

        withAnimation(.easeInOut(duration: 3)) {
          isAnimating = true
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
//                    withAnimation {
          isAnimating = false
//                    }
        }
//                isAnimating.toggle()
      }) {
        Text("ボタン")
          .font(.title)
          .foregroundColor(.white)
          .padding()
          .background(Color.blue)
          .cornerRadius(10)
      }
      .overlay(
        Circle()
          .stroke(Color.blue, lineWidth: 1)
          .scaleEffect(isAnimating ? 2 : 0)
          .opacity(isAnimating ? 0.1 : 1)
//                    .animation(.easeOut, value: isAnimating)
//                    .onAppear {
//                        self.isAnimating = true
//                    }
      )
    }
  }
}

struct RippleButton4: View {
  @State private var isAnimating = true
  private var driveAnimation: Animation {
    .easeInOut
      .repeatCount(3, autoreverses: false)
      .speed(0.3)
  }

  var body: some View {
    ZStack {
      Button(action: {
        // ボタンがタップされた時の処理

        isAnimating.toggle()
      }) {
        Text("ボタン")
          .font(.title)
          .foregroundColor(.white)
          .padding()
          .background(Color.blue)
          .cornerRadius(10)
      }

      Circle()
        .stroke(Color.blue, lineWidth: 1)
        .scaleEffect(isAnimating ? 2 : 0)
        .opacity(isAnimating ? 1 : 0)
        .animation(driveAnimation, value: isAnimating)
        .frame(width: 100, height: 100)
    }
  }
}

struct RippleCircle_v1: View {
  @State private var isAnimating = false
  private var driveAnimation: Animation {
    .easeInOut
      .repeatForever(autoreverses: false)
      .speed(0.3)
  }

  var body: some View {
    ZStack {
      Circle()
        .stroke(Color.blue, lineWidth: 1)
        .scaleEffect(isAnimating ? 2 : 0)
        .opacity(isAnimating ? 0 : 1)
        .animation(driveAnimation
          .delay(0.2), value: isAnimating)
        .frame(width: 100, height: 100)
      Circle()
        .stroke(Color.blue, lineWidth: 1)
        .scaleEffect(isAnimating ? 2 : 0)
        .opacity(isAnimating ? 0 : 1)
        .animation(driveAnimation
          .delay(0.1), value: isAnimating)
        .frame(width: 100, height: 100)
      Circle()
        .stroke(Color.blue, lineWidth: 1)
        .scaleEffect(isAnimating ? 2 : 0)
        .opacity(isAnimating ? 0 : 1)
        .animation(driveAnimation, value: isAnimating)
        .frame(width: 100, height: 100)
        .onAppear {
          isAnimating = true
        }
    }
  }
}

struct RippleCircles_v1: View {
  @State private var isAnimating = false
  var circleCount: Int
  var colors: [Color]
  var offsetDiff: Double
  var duration: Double
  private let animationDelay: Double = 0.1

  private var driveAnimation: Animation {
    Animation.easeIn(duration: duration + Double.random(in: 0.0...0.1))
//            .repeatForever(autoreverses: false)
      .repeatCount(1, autoreverses: false)
//            .speed(0.1 + Double.random(in: 0.0...0.1))
  }

  var body: some View {
    ZStack {
      ForEach(0..<circleCount, id: \.self) { index in
        Circle()
          .offset(CGSize(width: 1 + Double.random(in: -offsetDiff...offsetDiff),
                         height: 1 + Double.random(in: -offsetDiff...offsetDiff)))
//                    .stroke(Color.blue, lineWidth: 1)
          .stroke(colors[index % colors.count], lineWidth: Double.random(in: 1.0...2.0))
          .scaleEffect(isAnimating ? 2 + Double.random(in: 0...1) : 0)
          .opacity(isAnimating ? 0 : 1)
          .animation(driveAnimation
            .delay(Double(index) * (animationDelay + Double.random(in: 0.0...0.1))),
            value: isAnimating)
      }
    }
    .onAppear {
      isAnimating = true
    }
  }
}

struct RippleCircle: View {
  @State private var isAnimating = false
  var id: UInt64
  var color: Color
  var offsetDiff: Double
  var duration: Double
  var delay: Double
  private let animationDelay: Double = 0.1

  private var driveAnimation: Animation {
    Animation.easeIn(duration: duration + Double.random(in: 0.0...0.1))
      .repeatCount(1, autoreverses: false)
//            .speed(0.1 + Double.random(in: 0.0...0.1))
  }

  var body: some View {
    ZStack {
      Circle()
        .stroke(color, lineWidth: Double.random(in: 1.0...2.0))
        .scaleEffect(isAnimating ? 2 + Double.random(in: 0...1) : 0)
        .opacity(isAnimating ? 0 : 1)
        .animation(driveAnimation
          .delay(delay),
          value: isAnimating)
    }
    .onAppear {
      isAnimating = true
      print("circle[\(id)] onAppear")
    }
  }
}

extension Color {
  func hsvComponents() -> (hue: Double, saturation: Double, brightness: Double) {
    var hue: CGFloat = 0
    var saturation: CGFloat = 0
    var brightness: CGFloat = 0
    var alpha: CGFloat = 0

    guard UIColor(self).getHue(&hue, saturation: &saturation, brightness: &brightness, alpha: &alpha) else {
      fatalError("Color space conversion error")
    }

    return (Double(hue), Double(saturation), Double(brightness))
  }
}

func interpolateColor(from startColor: Color, to endColor: Color, with fraction: Double) -> Color {
  let startComponents = startColor.hsvComponents()
  let endComponents = endColor.hsvComponents()

  let interpolatedHue = startComponents.hue + (endComponents.hue - startComponents.hue) * fraction
  let interpolatedSaturation = startComponents.saturation + (endComponents.saturation - startComponents.saturation) * fraction
  let interpolatedBrightness = startComponents.brightness + (endComponents.brightness - startComponents.brightness) * fraction

  return Color(hue: interpolatedHue, saturation: interpolatedSaturation, brightness: interpolatedBrightness)
}

func generateGradientColors(startColor: Color, endColor: Color, numberOfColors: Int) -> [Color] {
  var colors: [Color] = []

  for i in 0..<numberOfColors {
    let fraction = Double(i) / Double(numberOfColors - 1)
    let newColor = interpolateColor(from: startColor, to: endColor, with: fraction)
    colors.append(newColor)
  }

  return colors
}

func tickCount() -> UInt64 {
  return DispatchTime.now().uptimeNanoseconds / 1000000
}

struct RippleObject: Identifiable {
  var id: UInt64
  var tick: UInt64
  var delay: UInt64
}

struct ContentView_Array: View {
  @State private var rippleId: UInt64 = 0
  @State private var isRippleShow = false
  @State private var ripples: [RippleObject] = []
  @State private var tick: UInt64 = tickCount()
  let startColor = Color(#colorLiteral(red: 0, green: 0.6230022509, blue: 1, alpha: 0.8020036139))
  let endColor = Color(#colorLiteral(red: 0.05724914705, green: 0, blue: 1, alpha: 0.7992931548))
  let objnum = 10 + Int.random(in: 0...3)
  let duration: UInt64 = 1500
  let delay: UInt64 = 100
  var colors: [Color]

  init() {
    colors = generateGradientColors(startColor: startColor, endColor: endColor, numberOfColors: objnum)
  }

  var body: some View {
    ZStack {
      ForEach(ripples) { ripple in
//        let _ = print(Double(ripples[index] - tick)/1000 )
        let _ = print("ripple[\(ripple.id)]=\(ripple.tick)")
        if ripple.tick > tick {
          RippleCircle(id: ripple.id, color: Color.blue, offsetDiff: 10, duration: Double(duration / 1000), delay: Double(ripple.delay) / 1000)
            .frame(width: 50)
        }
//        Circle()
//          .stroke(Color.yellow)
//          .frame(width: 100)
//          .offset(x:CGFloat(index*2),y:CGFloat(index*2))
      }

      if isRippleShow {
//        RippleCircles(circleCount: objnum, colors: colors, offsetDiff: 1, duration: duration)
//          .frame(width: 50)
      }
      VStack {
        Button(action: {
          // ボタンがタップされた時の処理

          tick = tickCount()
          ripples = ripples.filter { $0.tick > tick - delay }
//          print("ripples(b)= \(ripples)")

          for i in 0..<10 {
            self.rippleId += 1
            ripples.append(RippleObject(id: rippleId, tick: tick + delay * UInt64(i), delay: delay * UInt64(i)))
          }
//          print("newRipples(a)= \(newRipples)")

//          ripples = newRipples
          print("ripples(a)= \(ripples)")

          //        isRippleShow = true
//          DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
//            //          isRippleShow = false
//          }
        }) {
          Text("ボタン")
            .font(.caption2)
            .foregroundColor(.white)
            .padding()
            .background(Color.blue)
            .cornerRadius(10)
        }

        Text("\(ripples.count)")
        Text("tick=\(tick)")
        Text("rippleId=\(rippleId)")
      }
    }
    .padding()
  }
}

// 1.  @State変数によってViewの状態を決める。
// 2. Animationを起こす。
//    withAnimation と animation modifierによる方法がある
struct RippleCircleExplicitTimer: View {
  @Binding var isShow: Bool
  @State var isExpanded: Bool = false
  var color: Color
  var offsetDiff: Double
  var duration: Double = 1.0
  @State var isRepeating = false
  var animationDelay: Double = 0.1

  var body: some View {
    VStack {
      ZStack {
        Circle()
          .stroke(color, lineWidth: 2.0)
          .scaleEffect(isExpanded ? 2 : 0)
          .opacity(isExpanded ? 0 : 1)
      }

//      Text("isExpanded = \(isExpanded)")
    }
    .onChange(of: isShow) { value in
      print("onChange isShow=\(value)")
      repeatAnimation()
    }
    .onAppear {
      print("onAppear isShow=\(isShow)")
      repeatAnimation()
    }
  }

  func repeatAnimation() {
    if isRepeating {
      print("repeatAnimation isRepeating=\(isRepeating) exit")
      return
    }
    print("repeatAnimation isShow=\(isShow)")
    isRepeating = true

    withAnimation(.easeIn(duration: duration).delay(animationDelay)) {
      isExpanded = true
    }
    // 上記のアニメーションを無限に繰り返す
//    DispatchQueue.main.asyncAfter(deadline: .now() + duration + animationDelay  ) {
//      isRepeating = false
//      isExpanded = false
//      if isShow {
//        repeatAnimation()
//      }
//    }
    Timer.scheduledTimer(withTimeInterval: duration + animationDelay, repeats: false) { _ in
      isRepeating = false
      isExpanded = false
      if isShow {
        repeatAnimation()
      }
    }
  }
}

struct RippleCircles: View {
  @Binding var isShow: Bool
  var number: Int
  var startColor: Color
  var endColor: Color
  var duration: Double
  var delay: Double
  var offsetDiff: Double

  let colors: [Color]

  @State var isExpandeds: [Bool]
  @State private var timer: Timer?
  @Environment(\.scenePhase) private var scenePhase

  init(isShow: Binding<Bool>, number: Int, startColor: Color, endColor: Color, duration: Double, delay: Double, offsetDiff: Double) {
    self._isShow = isShow
    self.number = number
    self.startColor = startColor
    self.endColor = endColor
    self.duration = duration
    self.delay = delay
    self.offsetDiff = offsetDiff
    self.colors = generateGradientColors(startColor: startColor, endColor: endColor, numberOfColors: number)
    self.isExpandeds = Array(repeating: false, count: number)
  }

  var body: some View {
    VStack {
      ZStack {
        ForEach(0..<isExpandeds.count, id: \.self) { index in
          Circle()
            .offset(CGSize(width: Double.random(in: -offsetDiff...offsetDiff),
                           height: Double.random(in: -offsetDiff...offsetDiff)))
            .stroke(colors[index % colors.count], lineWidth: Double.random(in: 1.0...3.0))
            .scaleEffect(isExpandeds[index] ? 1 : 0)
            .opacity(isExpandeds[index] ? 0 : 1)
        }
      }
      

//      Text("isExpanded = \(isExpanded)")
    }
    .onChange(of: isShow) { newValue in
      print("onChange isShow=\(newValue)")
      if newValue {
//        resetAnimPosition()
        repeatAnimation()
      }
      else{
       // 現在のアニメーションが終わった時のタイマーで停止するので、ここでは処理を行わない
      }
      
    }
    .onAppear {
      print("onAppear isShow=\(isShow)")
      repeatAnimation()
    }
    .onDisappear {
      print("onDisappear isShow=\(isShow)")
//      timer?.invalidate()
    }
    .onChange(of: scenePhase) { phase in
      switch phase {
      case .active:
        print("scenePhase active")
//        resetAnimPosition()
//        if isShow {
//          repeatAnimation()
//        }
      case .inactive:
//        resetAnimPosition()
//        timer?.invalidate()
        isShow = false
        
        print("scenePhase inactive")
      case .background:
        print("scenePhase background")
      @unknown default:
        print("scenePhase @unknown")
      }
    }
  }

  func repeatAnimation() {
    if self.timer != nil {
      print("repeatAnimation reenterd exit")
      return
    }
    self.timer = Timer.scheduledTimer(withTimeInterval: duration + Double(isExpandeds.count - 1) * delay, repeats: false) { _ in
      print("repeatAnimation timer")
      self.timer = nil
//      isRepeating = false
      resetAnimPosition()
      if isShow {
        repeatAnimation()
      }
      
    }
    //    print("repeatAnimation isShow=\(isShow)")
//    isRepeating = true

    for i in 0..<isExpandeds.count {
      withAnimation(.easeIn(duration: duration).delay(delay * Double(i))) {
        isExpandeds[i] = true
      }
    }

    //    // 上記のアニメーションを無限に繰り返す
    //    DispatchQueue.main.asyncAfter(deadline: .now() + duration + Double(isExpandeds.count - 1) * delay) {
    //      isRepeating = false
    //      isExpandeds = Array(repeating: false, count: isExpandeds.count)
    //      if isShow {
    //        repeatAnimation()
    //      }
    //    }

  }

  func resetAnimPosition() {
    isExpandeds = Array(repeating: false, count: isExpandeds.count)
  }
}

struct ContentView: View {
  @State var isShow = true
  let color = Color(#colorLiteral(red: 0, green: 0.6230022509, blue: 1, alpha: 0.8020036139))
  let startColor = Color(#colorLiteral(red: 0, green: 0.6230022509, blue: 1, alpha: 0.8020036139))
  let endColor = Color(#colorLiteral(red: 0.05724914705, green: 0, blue: 1, alpha: 0.7992931548))
  let duration: Double = 2.0
  let rippleNum: Int = 8
  var body: some View {
    VStack {
      ZStack {
        RippleCircles(isShow: $isShow, number: rippleNum, startColor: startColor, endColor: endColor, duration: duration, delay: duration / Double(rippleNum), offsetDiff: 3)
          .frame(width: 150,height: 150)
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
  ContentView()
}
