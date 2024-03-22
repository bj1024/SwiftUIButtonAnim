//
// Copyright (c) 2024, - All rights reserved.
//
//

import SwiftUI

extension Color {
  var rgbComponents: (red: Double, green: Double, blue: Double, alpha: Double) {
    let uiColor = UIColor(self)
    var red: CGFloat = 0
    var green: CGFloat = 0
    var blue: CGFloat = 0
    var alpha: CGFloat = 0
    uiColor.getRed(&red, green: &green, blue: &blue, alpha: &alpha)

    return (Double(red), Double(green), Double(blue), Double(alpha))
  }
}

func createGradientColors(from startColor: Color, to endColor: Color, withCount count: Int) -> [Color] {
  // 開始色から終了色までの色相を計算
  let startComponents = startColor.rgbComponents
  let endComponents = endColor.rgbComponents

  var colors = [Color]()
  for i in 0 ..< count {
    // カウントに応じて色相を計算
    let ratio = CGFloat(i) / CGFloat(count - 1)
    let r = startComponents.0 + (endComponents.0 - startComponents.0) * ratio
    let g = startComponents.1 + (endComponents.1 - startComponents.1) * ratio
    let b = startComponents.2 + (endComponents.2 - startComponents.2) * ratio
    let a = startComponents.3 + (endComponents.3 - startComponents.3) * ratio

    // SwiftUIのColorに変換して配列に追加
    colors.append(Color(red: Double(r), green: Double(g), blue: Double(b), opacity: Double(a)))
  }

  return colors
}

// 使用例
let gradientColors = createGradientColors(from: Color.red, to: Color.blue, withCount: 5)

struct RippleSample: View {
  @State var rippleWidth = 200.0
  @State var rippleHeight = 200.0

  @State var isShow = true
  @State var startColor = Color(#colorLiteral(red: 0, green: 0.6230022509, blue: 1, alpha: 0.8020036139))
  //  let endColor = Color(#colorLiteral(red: 0.05724914705, green: 0, blue: 1, alpha: 0.7992931548))
  @State var endColor = Color(#colorLiteral(red: 0.04023407099, green: 0.2384221714, blue: 0.5562983247, alpha: 0.8))
  @State var duration: Double = 3.0
  @State var delay: Double = 0.5
  @State var interval: Double = 3.0
  @State var numberOfCircles: Int = 10
  @State var positionDiff: Double = 2

  var intProxy: Binding<Double> {
    Binding<Double>(get: {
      // returns the score as a Double
      Double(numberOfCircles)
    }, set: {
      // rounds the double to an Int
      print($0.description)
      numberOfCircles = Int($0)
    })
  }

  init() {}

  var startColorItem: some View {
    VStack {
      ColorPicker("startColor", selection: $startColor)
    }
  }

  var body: some View {
    VStack {
      ZStack {
        RippleView(isShow: isShow,
                   numberOfCircles: numberOfCircles,
                   colors: createGradientColors(from: startColor, to: endColor, withCount: numberOfCircles),
                   duration: duration,
                   delay: delay,
                   interval: interval,
                   positionDiff: positionDiff)
          .frame(width: rippleWidth, height: rippleHeight)

        Button(action: {
          isShow.toggle()
        }) {
          Text(isShow ? "Stop" : "Start")
            .foregroundColor(Color(uiColor: UIColor.white))
            .font(.caption2)
            .frame(width: 50, height: 20)
            .background(isShow ? Color.red : Color.blue)
            .cornerRadius(40)
        }
      }
      .background(Color(uiColor: UIColor.systemBackground))
      .clipped()
      .border(Color.red)
      Spacer()
      List {
        Text("isShow=\(isShow)")

        startColorItem

        ColorPicker("endColor", selection: $endColor)

        VStack {
          Text("size=\(String(format: "%0.0f,%0.0f", rippleWidth, rippleHeight))")

          Slider(value: $rippleWidth, in: 0.0 ... 300.0, step: 10.0)
          Slider(value: $rippleHeight, in: 0.0 ... 300.0, step: 10.0)
        }
        VStack {
          Text("numberOfCircles=\(numberOfCircles)")
          Slider(value: intProxy, in: 0.0 ... 300.0, step: 1.0)
          
        }
        .padding(10)
      
        VStack {
          Text("duration=\(String(format: "%0.1f", duration))")

          Slider(value: $duration, in: 0.0 ... 10.0, step: 0.1)
        }
        VStack {
          Text("delay=\(String(format: "%0.1f", delay))")
          Slider(value: $delay, in: 0.0 ... 10.0, step: 0.1)
        }

        VStack {
          Text("interval=\(String(format: "%0.1f", interval))")
          Slider(value: $interval, in: 0.0 ... 10.0, step: 0.1)
        }

        VStack {
          Text("positionDiff=\(String(format: "%0.1f", positionDiff))")
          Slider(value: $positionDiff, in: 0.0 ... 50.0, step: 1.0)
        }
      }
      .listStyle(.inset)
      .padding(8)
    }
    .background(Color(uiColor: UIColor.secondarySystemBackground))
    .frame(width: .infinity, height: .infinity)
  }
}

#Preview {
  RippleSample()
}
