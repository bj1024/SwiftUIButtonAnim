//
// Copyright (c) 2024, - All rights reserved.
//
//

import SwiftUI

extension Double {
  // 値を特定の範囲に制限（クランプ）する
  func clamped(to limits: ClosedRange<Double>) -> Double {
    return min(max(self, limits.lowerBound), limits.upperBound)
  }
}

//
// struct DoubleThumbSlider: View {
//    @Binding var lowerValue: Double
//    @Binding var upperValue: Double
//    var bounds: ClosedRange<Double>
//
//    var body: some View {
//        GeometryReader { geometry in
//            ZStack {
//                Color.gray.opacity(0.3)
//                    .frame(height: 3)
//                Color.blue
//                    .frame(width: CGFloat(upperValue - lowerValue) * geometry.size.width, height: 3)
//                    .offset(x: CGFloat(lowerValue) * geometry.size.width)
//                Circle()
//                    .frame(width: 20, height: 20)
//                    .foregroundColor(.white)
//                    .shadow(radius: 5)
//                    .offset(x: CGFloat(lowerValue) * geometry.size.width)
//                    .gesture(DragGesture().onChanged { value in
//                        lowerValue = Double(value.location.x / geometry.size.width).clamped(to: bounds.lowerBound...min(upperValue, bounds.upperBound))
//                    })
//                Circle()
//                    .frame(width: 20, height: 20)
//                    .foregroundColor(.white)
//                    .shadow(radius: 5)
//                    .offset(x: CGFloat(upperValue) * geometry.size.width)
//                    .gesture(DragGesture().onChanged { value in
//                        upperValue = Double(value.location.x / geometry.size.width).clamped(to: max(lowerValue, bounds.lowerBound)...bounds.upperBound)
//                    })
//            }
//        }
//        .padding(.horizontal)
//    }
// }

struct RangeSlider: View {
  @State private var lowValue: Double = 5.0
  @State private var highValue: Double = 90.0
  @State private var step: Double = 1.0
  var valueBounds: ClosedRange<Double>
  var dispBounds: ClosedRange<Double>

  private let thumbSize: Double = 24.0
  private let marginL = 32.0
  private let marginR = 32.0
  private let barHeight = 4.0
  var body: some View {
   
    ZStack(alignment: Alignment(horizontal: .leading, vertical: .center)) {
      GeometryReader { geometry in
        let sliderWidth = geometry.size.width - marginL - marginR
        let minX = marginL
    //          let maxX = geometry.size.width + marginL + marginR
        let dispBoundLen = dispBounds.upperBound - dispBounds.lowerBound
        let lowThumbPos = minX + CGFloat(self.lowValue / dispBoundLen * sliderWidth - thumbSize / 2.0)
        let highThumbPos = minX + CGFloat(self.highValue / dispBoundLen * sliderWidth - thumbSize / 2.0)
        let middleThumbPos = thumbSize / 2.0 - barHeight / 2.0


        HStack { //
          Text(String(format: "%.0f", dispBounds.lowerBound))
            .font(.caption)
            .foregroundColor(Color(uiColor: UIColor.label))
            
          Spacer()

          Text(String(format: "%.0f", dispBounds.upperBound))
            .font(.caption)
            .foregroundColor(Color(uiColor: UIColor.label))
        }
//        .offset( y: middleThumbPos)

        Capsule()
          .fill(Color(UIColor.systemGray))
          .offset(x: minX, y: middleThumbPos)
          .frame(width: sliderWidth, height: 4)

        Capsule()
          .fill(Color(UIColor.systemBlue))
          .offset(x: lowThumbPos, y: middleThumbPos)
          //            .offset(x: CGFloat(self.minValue))
          .frame(width: highThumbPos - lowThumbPos, height: 4)

        Circle()
          .fill(Color(UIColor.white))
          .shadow(color: Color(UIColor.gray), radius: 10)
//            .opacity(0.8)
          //            .border(Color.white, width: 5)
          .frame(width: thumbSize, height: thumbSize)
          //            .background(Circle().stroke(Color.white, lineWidth: 5))
          .overlay(
            Text(String(format: "%.0f", lowValue))
              .font(.caption)
              .offset(y: -28)
          )
          .offset(x: lowThumbPos)
          .gesture(DragGesture(minimumDistance: 1.0)
            .onChanged { value in
              let dragValue = Double((value.location.x - minX) / sliderWidth) * dispBoundLen
              lowValue = dragValue.clamped(to: valueBounds.lowerBound...highValue)
              print("gesture drag : loc=\(String(format: "%.2f", value.location.x)) drag=\(String(format: "%.2f", dragValue)) lowValue=\(String(format: "%.2f", lowValue))")
            })

        Circle()
          .fill(Color(UIColor.white))
          .shadow(color: Color(UIColor.gray), radius: 10)
//            .opacity(0.8)
          .frame(width: thumbSize, height: thumbSize)
          .overlay(
            Text(String(format: "%.0f", highValue))
              .font(.caption)
              .offset(y: -28)
          )
          .offset(x: highThumbPos)
          .gesture(DragGesture(minimumDistance: 1.0)
            .onChanged { value in
              let dragValue = Double((value.location.x - minX) / sliderWidth) * dispBoundLen
              highValue = dragValue.clamped(to: lowValue...valueBounds.upperBound)
              print("gesture drag : loc=\(String(format: "%.2f", value.location.x)) drag=\(String(format: "%.2f", dragValue)) highValue=\(String(format: "%.2f", highValue))")
            })
      }
    }.padding(.horizontal, 6)
  }
}

struct RangeSliderCircle: View {
  @State var minValue: Double = 0.0
  @State var maxValue: Double = .init(UIScreen.main.bounds.width - 50.0)

  var body: some View {
    // setup slider view
    VStack {
      HStack {
        Text("0")
          .offset(x: 28, y: 20)
          .frame(width: 30, height: 30, alignment: .leading)
          .foregroundColor(Color.black)

        Spacer()

        Text("100")
          .offset(x: -18, y: 20)
          .frame(width: 30, height: 30, alignment: .trailing)
          .foregroundColor(Color.black)
      }

      ZStack(alignment: Alignment(horizontal: .leading, vertical: .center), content: {
        Capsule()
          .fill(Color.black.opacity(25))
          .frame(width: CGFloat((UIScreen.main.bounds.width - 50) + 10), height: 30)

        Capsule()
          .fill(Color.black.opacity(25))
          .offset(x: CGFloat(self.minValue))
          .frame(width: CGFloat((self.maxValue) - self.minValue), height: 30)

        Circle()
          .fill(Color.orange)
          .frame(width: 30, height: 30)
          .background(Circle().stroke(Color.white, lineWidth: 5))
          .offset(x: CGFloat(self.minValue))
          .gesture(DragGesture().onChanged { value in
            if value.location.x > 8, value.location.x <= (UIScreen.main.bounds.width - 50),
               value.location.x < CGFloat(self.maxValue - 30)
            {
              self.minValue = Double(value.location.x - 8)
            }
          })

        Text(String(format: "%.0f", (CGFloat(self.minValue) / (UIScreen.main.bounds.width - 50)) * 100))
          .offset(x: CGFloat(self.minValue))
          .frame(width: 30, height: 30, alignment: .center)
          .foregroundColor(Color.black)

        Circle()
          .fill(Color.orange)
          .frame(width: 30, height: 30)
          .background(Circle().stroke(Color.white, lineWidth: 5))
          .offset(x: CGFloat(self.maxValue - 18))
          .gesture(DragGesture().onChanged { value in
            if value.location.x - 8 <= (UIScreen.main.bounds.width - 50), value.location.x > CGFloat(self.minValue + 50) {
              self.maxValue = Double(value.location.x - 8)
            }
          })

        Text(String(format: "%.0f", (CGFloat(self.maxValue) / (UIScreen.main.bounds.width - 50)) * 100))
          .offset(x: CGFloat(self.maxValue - 18))
          .frame(width: 30, height: 30, alignment: .center)
          .foregroundColor(Color.black)
      })
      .padding()
    }
  }
}

struct RangeSliderExample: View {
  @State private var sliderValue: ClosedRange<Double> = 0...100

  @State private var lowerValue: Double = 0.2
  @State private var upperValue: Double = 0.8

  @State private var position = CGSize.zero

  var body: some View {
    VStack {
//      RangeSliderCircle(value: $sliderValue, bounds: 0...100)
      RangeSlider(valueBounds: 5...90, dispBounds: 0...100)

      Circle()
        .stroke(Color.blue, lineWidth: 2)
        .frame(width: 100, height: 100)
        .overlay(Text("Hello"))
        .offset(position)
        .gesture(
          DragGesture()
            .onChanged { gesture in
              self.position = gesture.translation
            }
            .onEnded { _ in
              self.position = CGSize.zero
            }
        )
    }
  }
}

#Preview {
  RangeSliderExample()
}
