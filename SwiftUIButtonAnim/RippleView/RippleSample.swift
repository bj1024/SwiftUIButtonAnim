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
  @State var size = 100.0


  @State var isShow = true
  @State var startColor = Color(#colorLiteral(red: 0, green: 0.6230022509, blue: 1, alpha: 0.8020036139))
  //  let endColor = Color(#colorLiteral(red: 0.05724914705, green: 0, blue: 1, alpha: 0.7992931548))
  @State var endColor = Color(#colorLiteral(red: 0.04023407099, green: 0.2384221714, blue: 0.5562983247, alpha: 0.8))
  @State var duration: Double = 3.0
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

  init() {
   
  }

  var body: some View {
    VStack {
      ZStack {
        RippleView(isShow: isShow,
                   numberOfCircles: numberOfCircles,
                   colors: createGradientColors(from: startColor, to: endColor, withCount: numberOfCircles),
                   duration: duration,
                   delay:  (duration * 0.9) / Double(numberOfCircles),
                   interval: duration / 1,
                   positionDiff: positionDiff)
          .frame(width: size, height: size)

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
        .foregroundColor(.white)

      Text("size = \(String(format:"%0f",size))")
        .foregroundColor(.white)
      Slider(value: $size, in: 0.0 ... 300.0, step: 1.0)

      
      Text("numberOfCircles = \(numberOfCircles)")
        .foregroundColor(.white)
      Slider(value: intProxy, in: 0.0 ... 300.0, step: 1.0)

      Text("duration = \(String(format:"%0.1f",duration))")
        .foregroundColor(.white)
      Slider(value: $duration, in: 0.0 ... 10.0, step: 0.1)

      Text("positionDiff = \(String(format:"%0.1f",positionDiff))")
        .foregroundColor(.white)
      Slider(value: $positionDiff, in: 0.0 ... 50.0, step: 1.0)

      
    }
    .padding()

    .background(Color.black)
//    .frame(width: .infinity, height: .infinity)
  }
}

#Preview {
  RippleSample()
}
