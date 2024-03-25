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

  if count == 1 {
    colors.append(startColor)
  }
  else {
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
  }

  return colors
}

// 使用例
let gradientColors = createGradientColors(from: Color.red, to: Color.blue, withCount: 5)

struct ListLabelText: View {
  var label: String
  var value: String
  var body: some View {
    Text("\(label):\(value)")
      .font(.system(.body, design: .rounded))
  }
}

struct CollorPair: Identifiable {
  var color1: Color
  var color2: Color
  var id = UUID()
}

struct RippleSample: View {
  @State var rippleWidth = 200.0
  @State var rippleHeight = 200.0

  @State var isShow = true
  @State var startColor = Color(#colorLiteral(red: 0, green: 0.6230022509, blue: 1, alpha: 0.8020036139))
  //  let endColor = Color(#colorLiteral(red: 0.05724914705, green: 0, blue: 1, alpha: 0.7992931548))
  @State var endColor = Color(#colorLiteral(red: 0.04023407099, green: 0.2384221714, blue: 0.5562983247, alpha: 0.8))
  @State var duration: Double = 3.0
  @State var delay: Double = 0.5
  @State var interval: Double = 0.0
  @State var numberOfCircles: Int = 5
  @State var positionDiff: Double = 10
  @State var lineWidthMin: Double = 1
  @State var lineWidthMax: Double = 10

  
  @State var isImageLightShow = false
  @State var imageSatuation:Double = 1.0
  @State var imageBlur:Double = 1.0
  
  @State private var keepAspect: Bool = true
  @State private var isAnimating: Bool = false

  
  
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

//  private let colorPairs: [CollorPair] = [
//    CollorPair(color1: Color.red.opacity(0.5), color2: Color.white.opacity(0.5)),
//    CollorPair(color1: Color.white.opacity(0.5), color2: Color.white.opacity(0.5)),
//    CollorPair(color1: Color.blue.opacity(0.5), color2: Color.white.opacity(0.5)),
//    CollorPair(color1: Color.red.opacity(0.5), color2: Color.white.opacity(0.5)),
//    CollorPair(color1: Color.green.opacity(0.5), color2: Color.white.opacity(0.5)),
//    CollorPair(color1: Color.orange.opacity(0.5), color2: Color.white.opacity(0.5)),
//    CollorPair(color1: Color.teal.opacity(0.5), color2: Color.white.opacity(0.5)),
//    CollorPair(color1: Color.yellow.opacity(0.5), color2: Color.white.opacity(0.5)),
//    CollorPair(color1: Color.purple.opacity(0.5), color2: Color.white.opacity(0.5)),
//    CollorPair(color1: Color.pink.opacity(0.5), color2: Color.white.opacity(0.5)),
//    CollorPair(color1: Color.red.opacity(0.5), color2: Color.white.opacity(0.5)),
//  ]
  private let colors: [[Color]] = [
    [Color.white.opacity(0.5), Color.white.opacity(0.5)],
    [Color.red.opacity(0.5), Color.white.opacity(0.5)],
    [Color.green.opacity(0.5), Color.white.opacity(0.5)],
    [Color.blue.opacity(0.5), Color.white.opacity(0.5)],
    [Color.black.opacity(0.5), Color.white.opacity(0.5)],
    [Color.yellow.opacity(0.5), Color.white.opacity(0.5)],
    [Color.orange.opacity(0.5), Color.white.opacity(0.5)],
    [Color.teal.opacity(0.5), Color.white.opacity(0.5)],
    [Color.purple.opacity(0.5), Color.white.opacity(0.5)],
    [Color.pink.opacity(0.5), Color.white.opacity(0.5)],

    [Color.white.opacity(0.9), Color.white.opacity(0.9)],
    [Color.red.opacity(0.9), Color.white.opacity(0.9)],
    [Color.green.opacity(0.9), Color.white.opacity(0.9)],
    [Color.blue.opacity(0.9), Color.white.opacity(0.9)],
    [Color.black.opacity(0.9), Color.white.opacity(0.9)],
    [Color.yellow.opacity(0.9), Color.white.opacity(0.9)],
    [Color.orange.opacity(0.9), Color.white.opacity(0.9)],
    [Color.teal.opacity(0.9), Color.white.opacity(0.9)],
    [Color.purple.opacity(0.9), Color.white.opacity(0.9)],
    [Color.pink.opacity(0.9), Color.white.opacity(0.9)],

    [Color.white.opacity(0.1), Color.white.opacity(0.1)],
    [Color.red.opacity(0.1), Color.white.opacity(0.1)],
    [Color.green.opacity(0.1), Color.white.opacity(0.1)],
    [Color.blue.opacity(0.1), Color.white.opacity(0.1)],
    [Color.black.opacity(0.1), Color.white.opacity(0.1)],
    [Color.yellow.opacity(0.1), Color.white.opacity(0.1)],
    [Color.orange.opacity(0.1), Color.white.opacity(0.1)],
    [Color.teal.opacity(0.1), Color.white.opacity(0.1)],
    [Color.purple.opacity(0.1), Color.white.opacity(0.1)],
    [Color.pink.opacity(0.1), Color.white.opacity(0.1)],

    [Color.white.opacity(1.0), Color.white.opacity(1.0)],
    [Color.red.opacity(1.0), Color.white.opacity(1.0)],
    [Color.green.opacity(1.0), Color.white.opacity(1.0)],
    [Color.blue.opacity(1.0), Color.white.opacity(1.0)],
    [Color.black.opacity(1.0), Color.white.opacity(1.0)],
    [Color.yellow.opacity(1.0), Color.white.opacity(1.0)],
    [Color.orange.opacity(1.0), Color.white.opacity(1.0)],
    [Color.teal.opacity(1.0), Color.white.opacity(1.0)],
    [Color.purple.opacity(1.0), Color.white.opacity(1.0)],
    [Color.pink.opacity(1.0), Color.white.opacity(1.0)],
  ]

  init() {}

  var body: some View {
    VStack {
      ZStack {
        ZStack {
          //        ForEach(0..<1,id: \.self) { index in
          //          Image("medium")
          //            .resizable()
          //            .aspectRatio(contentMode: .fit)
          //            .frame(width: 300, height: 300)
          //          //          .saturation(0)
          //            .zIndex(3.0)
          //            .opacity(1)
          //            .blendMode(.colorDodge)
          //        }
          //        Rectangle()
          //          LinearGradient(gradient: Gradient(colors: [startColor,endColor]),
          //                                            startPoint: .leading, endPoint: .trailing)
          //          .frame(width: rippleWidth, height: rippleHeight)
          //          .zIndex(4.0)
          //          .opacity(0.9)
          //          .blendMode(.colorDodge)

          Image("marbles")
            .resizable()
            .aspectRatio(contentMode: .fit)
            .frame(width: .infinity, height: 300)
            .saturation(imageSatuation)
            .blur(radius: (1 - imageBlur) * 20)
          if isImageLightShow {
            Image("marbles")
              .resizable()
              .aspectRatio(contentMode: .fit)
              .frame(width: .infinity, height: 300)
            //          .blendMode(isAnimating ? .colorDodge : .normal)
//              .saturation(0)
              .blendMode(.colorDodge)
              .opacity(isAnimating ? 0.9 : 0)
              .zIndex(3.0)
              .animation(
                .easeInOut(duration: 5.0)
                .repeatForever(autoreverses: true),
                value: isAnimating
              )
              .onAppear {
                isAnimating = true
              }
          }
        }
        .drawingGroup()

//
        RippleView(isShow: isShow,
                   numberOfCircles: numberOfCircles,
                   colors: createGradientColors(from: startColor, to: endColor, withCount: numberOfCircles),
                   duration: duration,
                   delay: delay,
                   interval: interval,
                   positionDiff: positionDiff,
                   lineWidthRange: lineWidthMin ... lineWidthMax)
          .frame(width: rippleWidth, height: rippleHeight)
          .blendMode(.colorDodge)
          .zIndex(2.0)

//

//        Capsule()
//          .fill(Color(UIColor.systemGray))
//          .frame(width: 60, height: 30)
//          .zIndex(20.0)
//          .shadow(radius: 30)
//          .blendMode(.colorDodge)
//          .opacity(isAnimating ? 1.0 : 0)
//          .animation(
//            .easeInOut(duration: 5.0)
//            .repeatForever(autoreverses: true),
//                     value: isAnimating)

//
//        Button(action: {
//          isShow.toggle()
//        }) {
//          Text(isShow ? "Stop" : "Start")
//            .foregroundColor(Color(uiColor: UIColor.white))
//            .font(.caption2)
//            .frame(width: 50, height: 20)
//            .background(isShow ? Color.red : Color.blue)
//            .cornerRadius(40)
//        }
//        .zIndex(20.0)
      }

      .frame(maxWidth: .infinity)
      .background(Color(uiColor: UIColor.systemBackground))
//      .clipped()
//      .border(Color.red)

//      Spacer()
//      List {
//        Section {
////          ListLabelText(label: "Show", value: isShow.description)
////            .listRowInsets(EdgeInsets(top: 0, leading: 8, bottom: 0, trailing: 8))
////            .listRowSeparator(.visible, edges: .all)
////          //
//
//          VStack(alignment:.leading, spacing: 0){
//            Divider()
//            Text("Apple")
//              .listRowSeparator(.hidden)
//            //            .listRowInsets(EdgeInsets(top: 0, leading: 8, bottom: 0, trailing: 8))
//          }
//          Text("SwiftUI")
//            .listRowSeparator(.hidden)
//        }
//        .listSectionSeparator(.hidden)
//      }
////      .listStyle(.grouped)
//      .listStyle(.inset)


//      Divider()
//        .background(Color.red)
//        .padding(0)

//      @State var imageSatuation:Double = 1.0
      
      
      List {
        Section(header: Text("Image")) {
          HStack {
            ListLabelText(label: "ImageLight", value: isImageLightShow.description)
              .listRowSeparator(.visible, edges: .all)
            Spacer()
            Toggle("", isOn: $isImageLightShow)
              .controlSize(.mini)
          }
          
          VStack {
            HStack {
              ListLabelText(label: "Sat", value: String(format:"%0.2f",imageSatuation))
                .frame(width: 100, alignment: .leading)
              Slider(value: $imageSatuation, in: 0.0 ... 1.0, step: 0.01)
            }
          }

          VStack {
            HStack {
              ListLabelText(label: "Blur", value: String(format:"%0.2f",imageBlur))
                .frame(width: 100, alignment: .leading)
              Slider(value: $imageBlur, in: 0.0 ... 1.0, step: 0.01)
            }
          }
        }
        Section(header: Text("Ripple")) {
          HStack {
            ListLabelText(label: "Show", value: isShow.description)
              .listRowSeparator(.visible, edges: .all)
 
            Spacer()
            ZStack {
              RippleView(isShow: isShow,
                         numberOfCircles: 3,
                         colors: createGradientColors(from: startColor, to: endColor, withCount: numberOfCircles),
                         duration: 2,
                         delay: 0.5,
                         interval: 2,
                         positionDiff: 2,
                         lineWidthRange: 1 ... 2)
                .frame(width: 38, height: 16)
              Button(action: {
                isShow.toggle()
              }) {
                Text(isShow ? "Stop" : "Start")
                  .foregroundColor(Color(uiColor: UIColor.white))
                  .font(.caption2)
                  .frame(width: 36, height: 16)
                  .background(isShow ? Color.red : Color.blue)
                  .cornerRadius(40)
              }
              .padding(0)
            }
            .padding(0)
          }
          .padding(0)

          VStack {
            HStack {
              ListLabelText(label: "Color", value: "")
              Spacer()
              ScrollView(.horizontal, showsIndicators: false) {
                HStack {
                  ForEach(colors.indices, id: \.self) { index in
                    Button(action: {
                      print("Button Tapped \(index)")
                      startColor = colors[index][0]
                      endColor = colors[index][1]
                    }) {
                      Rectangle()
                        .fill(
                          LinearGradient(gradient: Gradient(colors: colors[index]), startPoint: .leading, endPoint: .trailing)
                        )
                        //                  .foregroundColor(colors[index][0])
                        .frame(width: 24, height: 24)
                        //                  .cornerRadius(40)
                        .border(Color(UIColor.darkGray))
                    }
                    .buttonStyle(.plain)
                  }
                }
              }

              ColorPicker("Start", selection: $startColor, supportsOpacity: true)
                .labelsHidden()

              ColorPicker("End", selection: $endColor, supportsOpacity: true)
                .labelsHidden()
            }
          }
          VStack {
            HStack {
              ListLabelText(label: "Size", value: String(format: "%0.0fx%0.0f", rippleWidth, rippleHeight))
              Spacer()

              Toggle("Keep Aspect", isOn: $keepAspect)
            }
            HStack {
              Slider(value: $rippleWidth, in: 0.0 ... 300.0, step: 10.0)
                .onChange(of: rippleWidth) { _ in
                  if keepAspect {
                    rippleHeight = rippleWidth
                  }
                }
              Slider(value: $rippleHeight, in: 0.0 ... 300.0, step: 10.0)
                .onChange(of: rippleHeight) { _ in
                  if keepAspect {
                    rippleWidth = rippleHeight
                  }
                }
            }
          }
          .padding(0)
          .listRowSeparator(.visible, edges: .all)

          VStack {
            HStack {
              ListLabelText(label: "Num", value: "\(numberOfCircles)")
                .frame(width: 100, alignment: .leading)
              Slider(value: intProxy, in: 0.0 ... 100.0, step: 1.0)
            }
          }
          .padding(0)
          .listRowSeparator(.visible, edges: .all)

          VStack {
            HStack {
              //          Text("duration=\(String(format: "%0.1f", duration))")
              ListLabelText(label: "Duration", value: "\(String(format: "%0.1f", duration))")
                .frame(width: 100, alignment: .leading)
              Slider(value: $duration, in: 0.0 ... 10.0, step: 0.1)
            }
          }
          .padding(0)
          .listRowSeparator(.visible, edges: .all)

          VStack {
            HStack {
              ListLabelText(label: "Delay", value: "\(String(format: "%0.1f", delay))")
                .frame(width: 100, alignment: .leading)
              Slider(value: $delay, in: 0.0 ... 10.0, step: 0.1)
            }
          }
          .padding(0)
          .listRowSeparator(.visible, edges: .all)

          VStack {
            HStack {
              ListLabelText(label: "Interval", value: "\(String(format: "%0.1f", interval))")
                .frame(width: 100, alignment: .leading)
              Slider(value: $interval, in: 0.0 ... 10.0, step: 0.1)
            }
          }
          .padding(0)
          .listRowSeparator(.visible, edges: .all)

          VStack {
            HStack {
              ListLabelText(label: "PosDiff", value: "\(String(format: "%0.1f", positionDiff))")
                .frame(width: 100, alignment: .leading)
              Slider(value: $positionDiff, in: 0.0 ... 50.0, step: 1.0)
            }
          }
          .padding(0)
          .listRowSeparator(.visible, edges: .all)

          VStack {
            HStack {
              ListLabelText(label: "Line Width", value: "\(String(format: "%0.0f-%0.0f", lineWidthMin, lineWidthMax))")
                .frame(width: 100, alignment: .leading)
                .padding(0)
              RangeSlider(lowValue: $lineWidthMin,
                          highValue: $lineWidthMax,
                          valueBounds: 1 ... 20,
                          dispBounds: 0 ... 20,
                          isShowMinMaxLabel: false)
            }
          }
          .padding(0)
          .listRowSeparator(.visible, edges: .all)
        }
        .listSectionSeparator(.hidden)
      }
//      .listStyle(.inset)
    }
//    .background(Color(uiColor: UIColor.secondarySystemBackground))
//    .frame(width: .infinity, height: .infinity)
  }
}

#Preview {
  RippleSample()
}
