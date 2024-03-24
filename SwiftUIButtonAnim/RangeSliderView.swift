//
// Copyright (c) 2024, - All rights reserved.
//
//

import SwiftUI
import UIKit
extension Double {
  // 値を特定の範囲に制限（クランプ）する
  func clamped(to limits: ClosedRange<Double>) -> Double {
    return min(max(self, limits.lowerBound), limits.upperBound)
  }

  func rounded(toStep step: Double) -> Double {
    let divisor = self / step
    return divisor.rounded(.towardZero) * step
  }
}

struct SizePreferenceKey: PreferenceKey {
  static var defaultValue: CGSize = .zero
  static func reduce(value: inout CGSize, nextValue: () -> CGSize) {
    value = nextValue()
  }
}

struct RangeSlider: View {
  @Binding var lowValue: Double
  @Binding var highValue: Double
  @State var step: Double = 1
  @State var maxFormat: String = "%.0f"
  @State var minFormat: String = "%.0f"

  @State var lowValueFormat: String = "%.0f"
  @State var highValueFormat: String = "%.0f"
  var valueBounds: ClosedRange<Double>
  var dispBounds: ClosedRange<Double>

  @State private var barsize: CGSize = .zero

  private let thumbSize: Double = 16.0

  private let marginL = 8.0
  private let marginR = 8.0
  private let barHeight = 4.0

  @State private var lowValueDragStart: Double?
  @State private var lowValueDragPrev: Double?
  @State private var highValueDragStart: Double?
  @State private var highValueDragPrev: Double?

  func playHapticFeedback(_ style: UIImpactFeedbackGenerator.FeedbackStyle) {
    let generator = UIImpactFeedbackGenerator(style: style)
    generator.impactOccurred()
  }

  var slider: some View {
    ZStack {
      GeometryReader { geometry in
        let sliderWidth = geometry.size.width - marginL - marginR
        // 値は左側つまみの右端から右側つまみの左端を使う
        let valueWidth = sliderWidth - thumbSize * 2
        let dispBoundDiff = dispBounds.upperBound - dispBounds.lowerBound

        // つまみの右端
        let lowValuePos = marginL + thumbSize + CGFloat(self.lowValue / dispBoundDiff * valueWidth)
        // つまみの左端
        let highValuePos = marginL + thumbSize + CGFloat(self.highValue / dispBoundDiff * valueWidth)

        let middleThumbPos = thumbSize / 2.0 - barHeight / 2.0

        Capsule()
          .fill(Color(UIColor.systemGray))
          .frame(width: sliderWidth, height: barHeight)
          .offset(x: marginL, y: middleThumbPos)
        //            .offset(x: CGFloat(self.minValue))

        Capsule()
          .fill(Color(UIColor.systemBlue))
          .offset(x: lowValuePos, y: middleThumbPos)
          //            .offset(x: CGFloat(self.minValue))
          .frame(width: highValuePos - lowValuePos, height: barHeight)

        Circle()
          .fill(Color(UIColor.white))
          .shadow(color: Color(UIColor.gray), radius: 10)
//          .opacity(0.8)
          //            .border(Color.white, width: 5)
          .frame(width: thumbSize, height: thumbSize)
          //            .background(Circle().stroke(Color.white, lineWidth: 5))
          .overlay(
            Text(String(format: lowValueFormat, lowValue))
              .font(.caption)
              .frame(width: 100)
              .offset(y: -28)
          )

          .offset(x: lowValuePos - thumbSize)
          .gesture(DragGesture(minimumDistance: 1.0)
            .onChanged { value in

              if lowValueDragStart == nil {
                lowValueDragStart = lowValue
              }
              guard let lowValueDragStart = lowValueDragStart else { return }

              let dragValue = lowValueDragStart + (Double(value.translation.width / valueWidth) * dispBoundDiff)
                .rounded(toStep: step)

              if (dragValue + step) > highValue, (dragValue + step) <= valueBounds.upperBound {
                print("set High")
                highValue = (dragValue + step).clamped(to: lowValue + step...(valueBounds.upperBound))
              }
              lowValue = dragValue.clamped(to: valueBounds.lowerBound...(highValue - step))

              print("gesture drag: lowValueDragStart=\(String(format: "%.2f", lowValueDragStart)) st=\(String(format: "%.2f", value.startLocation.x)) loc=\(String(format: "%.2f", value.location.x)) translation=\(String(format: "%.2f", value.translation.width))  drag=\(String(format: "%.2f", dragValue)) lowValue=\(String(format: "%.2f", lowValue)) highValue=\(String(format: "%.2f", highValue))")

              if lowValueDragPrev == nil || lowValueDragPrev != lowValue {
                playHapticFeedback(.light)
              }
              lowValueDragPrev = lowValue
            }
            .onEnded { _ in
              lowValueDragStart = nil
              lowValueDragPrev = nil
            }
          )

        Circle()
          .fill(Color(UIColor.white))
          .shadow(color: Color(UIColor.gray), radius: 10)
//          .opacity(0.8)
          .frame(width: thumbSize, height: thumbSize)
          .overlay(
            Text(String(format: highValueFormat, highValue))
              .font(.caption)
              .frame(width: 100)
              .offset(y: -28)
          )
          .offset(x: highValuePos)
          .gesture(DragGesture(minimumDistance: 1.0)
            .onChanged { value in
              if highValueDragStart == nil {
                highValueDragStart = highValue
              }
              guard let highValueDragStart = highValueDragStart else { return }

              let dragValue = highValueDragStart + (Double(value.translation.width / valueWidth) * dispBoundDiff)
                .rounded(toStep: step)
              if (dragValue - step) < lowValue, (dragValue - step) >= valueBounds.lowerBound {
                lowValue = (dragValue - step).clamped(to: valueBounds.lowerBound...(highValue + step))
              }

              highValue = min(max(dragValue, lowValue + step), valueBounds.upperBound)
              print("gesture drag : loc=\(String(format: "%.2f", value.location.x)) drag=\(String(format: "%.2f", dragValue)) lowValue=\(String(format: "%.2f", lowValue)) highValue=\(String(format: "%.2f", highValue))")

              if highValueDragPrev == nil || highValueDragPrev != highValue {
                playHapticFeedback(.light)
              }
              highValueDragPrev = highValue
            }
            .onEnded { _ in
              highValueDragStart = nil
              highValueDragPrev = nil
            }
          )
      }
    }
    .frame(height: thumbSize)
  }

  var body: some View {
//    ZStack(alignment: Alignment(horizontal: .leading, vertical: .center)) {

    VStack {
      Spacer()
      //          let maxX = geometry.size.width + marginL + marginR
//        let dispBoundLen = dispBounds.upperBound - dispBounds.lowerBound
//        let lowThumbPos = minX + CGFloat(self.lowValue / dispBoundLen * sliderWidth - thumbSize / 2.0)
//        let highThumbPos = minX + CGFloat(self.highValue / dispBoundLen * sliderWidth - thumbSize / 2.0)
//        let middleThumbPos = thumbSize / 2.0 - barHeight / 2.0

      HStack { //
        Text(String(format: minFormat, dispBounds.lowerBound))
          .font(.caption)
          .foregroundColor(Color(uiColor: UIColor.label))
          .frame(width: 32)
//          .border(Color.red)

        slider
//          .border(Color.red)

        Text(String(format: maxFormat, dispBounds.upperBound))
          .font(.caption)
          .foregroundColor(Color(uiColor: UIColor.label))
//              .frame(width: 32)
//          .border(Color.red)

        //        .offset( y: middleThumbPos)
      }

      Spacer()

//      Text(String(format: "%.2f %.2f", barsize.width, barsize.height))
//        .font(.caption)
//        .foregroundColor(Color(uiColor: UIColor.label))
//        .frame(width: 32)
//        .border(Color.red)

//      ZStack
//      {
//        Capsule()
//          .fill(Color(UIColor.systemBlue))
//          .offset(x: lowThumbPos, y: middleThumbPos)
//          //            .offset(x: CGFloat(self.minValue))
//          .frame(width: highThumbPos - lowThumbPos, height: 4)
//
//        Circle()
//          .fill(Color(UIColor.white))
//          .shadow(color: Color(UIColor.gray), radius: 10)
      ////            .opacity(0.8)
//          //            .border(Color.white, width: 5)
//          .frame(width: thumbSize, height: thumbSize)
//          //            .background(Circle().stroke(Color.white, lineWidth: 5))
//          .overlay(
//            Text(String(format: format, lowValue))
//              .border(Color.red)
//              .font(.caption)
//              .frame(width: 100)
//              .offset(y: -28)
//
//          )
//          .offset(x: lowThumbPos)
//          .gesture(DragGesture(minimumDistance: 1.0)
//            .onChanged { value in
//              let dragValue = Double((value.location.x - minX) / sliderWidth) * dispBoundLen
//
//              lowValue = dragValue.clamped(to: valueBounds.lowerBound...(highValue-step))
//              print("gesture drag : loc=\(String(format: "%.2f", value.location.x)) drag=\(String(format: "%.2f", dragValue)) lowValue=\(String(format: "%.2f", lowValue)) highValue=\(String(format: "%.2f", highValue))")
//            })
//
//        Circle()
//          .fill(Color(UIColor.white))
//          .shadow(color: Color(UIColor.gray), radius: 10)
      ////            .opacity(0.8)
//          .frame(width: thumbSize, height: thumbSize)
//          .overlay(
//            Text(String(format: format, highValue))
//              .font(.caption)
//              .frame(width: 100)
//              .offset(y: -28)
//          )
//          .offset(x: highThumbPos)
//          .gesture(DragGesture(minimumDistance: 1.0)
//            .onChanged { value in
//              let dragValue = Double((value.location.x - minX) / sliderWidth) * dispBoundLen
//
//              highValue = min(max(dragValue,lowValue + step ) , valueBounds.upperBound )
      ////
      ////              dragValue
      ////                .clamped(to: (lowValue + step)...valueBounds.upperBound)
//              print("gesture drag : loc=\(String(format: "%.2f", value.location.x)) drag=\(String(format: "%.2f", dragValue)) lowValue=\(String(format: "%.2f", lowValue)) highValue=\(String(format: "%.2f", highValue))")
//            })
//      }
    }.padding(.horizontal, 6)
  }
}

struct RangeSliderExample: View {
  @State private var sliderValue: ClosedRange<Double> = 0...100

  @State private var lowerValue: Double = 10
  @State private var upperValue: Double = 80

  @State private var position = CGSize.zero

  var body: some View {
    VStack {
//      RangeSliderCircle(value: $sliderValue, bounds: 0...100)
      RangeSlider(lowValue: $lowerValue, highValue: $upperValue,
                  valueBounds: 0...100, dispBounds: 0...100)

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
