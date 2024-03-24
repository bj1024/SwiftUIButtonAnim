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

struct VerticalLine: Shape {
  func path(in rect: CGRect) -> Path {
    var path = Path()
    // 線を描画
    path.move(to: CGPoint(x: rect.midX, y: rect.minY))
    path.addLine(to: CGPoint(x: rect.midX, y: rect.maxY))
    return path
  }
}

struct RangeSlider: View {
  @Binding var lowValue: Double
  @Binding var highValue: Double
  var valueBounds: ClosedRange<Double>
  var dispBounds: ClosedRange<Double>
  var step: Double = 1
  var maxFormat: String = "%.0f"
  var minFormat: String = "%.0f"
  var lowValueFormat: String = "%.0f"
  var highValueFormat: String = "%.0f"
  var isShowMinMaxLabel: Bool = true

  private let thumbSize: Double = 16.0

  private let marginL = 8.0
  private let marginR = 8.0
  private let barHeight = 6.0

  @State private var barsize: CGSize = .zero
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
        let dispValueWidth = sliderWidth - thumbSize * 2
        let dispBoundDiff = dispBounds.upperBound - dispBounds.lowerBound

        // つまみの右端
        let lowValuePos = marginL + thumbSize + CGFloat(self.lowValue / dispBoundDiff * dispValueWidth)
        // つまみの左端
        let highValuePos = marginL + thumbSize + CGFloat(self.highValue / dispBoundDiff * dispValueWidth)

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

        if dispBounds.lowerBound < valueBounds.lowerBound {
          VerticalLine()
            .stroke(style: StrokeStyle(lineWidth: 2, dash: [10])) // 線のスタイルを指定
            .frame(width: 2, height: barHeight) // 線の幅を指定
            .offset(x: (valueBounds.lowerBound - dispBounds.lowerBound) / dispBoundDiff * dispValueWidth + thumbSize,
                    y: middleThumbPos)
            .foregroundColor(Color.red.opacity(0.8)) // 線の色を指定
        }
        if valueBounds.upperBound < dispBounds.upperBound {
          VerticalLine()
            .stroke(style: StrokeStyle(lineWidth: 2, dash: [10])) // 線のスタイルを指定
            .frame(width: 2, height: barHeight) // 線の幅を指定
            .offset(x: (valueBounds.upperBound - dispBounds.lowerBound) / dispBoundDiff * dispValueWidth + marginL + thumbSize + thumbSize / 2,
                    y: middleThumbPos)
            .foregroundColor(Color.red.opacity(0.8)) // 線の色を指定
        }

//        if dispBounds.lowerBound < valueBounds.lowerBound {
//          Capsule()
//            .fill(Color(UIColor.black.withAlphaComponent(0.7)))
//            .offset(x: marginL, y: middleThumbPos)
//            .frame(width: (valueBounds.lowerBound - dispBounds.lowerBound) / dispBoundDiff * dispValueWidth + thumbSize , height: barHeight)
//        }
//        if dispBounds.upperBound > valueBounds.upperBound {
//          Capsule()
//            .fill(Color(UIColor.black.withAlphaComponent(0.7)))
//            .offset(x:  (valueBounds.upperBound - dispBounds.lowerBound) / dispBoundDiff * dispValueWidth + marginL + thumbSize, y: middleThumbPos)
//            .frame(width: (dispBounds.upperBound - valueBounds.upperBound) / dispBoundDiff * dispValueWidth + thumbSize , height: barHeight)
//        }

        Circle()
          .fill(Color(UIColor.white))
          .shadow(color: Color(UIColor.gray), radius: 3)
//          .opacity(0.8)
          //            .border(Color.white, width: 5)
          .frame(width: thumbSize, height: thumbSize)
          //            .background(Circle().stroke(Color.white, lineWidth: 5))
          .overlay(
            Text(String(format: lowValueFormat, lowValue))
              .font(.system(.subheadline, design: .rounded))
              .frame(width: 100)
              .offset(y: -1.0 * thumbSize / 2 - 16.0)
          )

          .offset(x: lowValuePos - thumbSize)
          .gesture(DragGesture(minimumDistance: 1.0)
            .onChanged { value in

              if lowValueDragStart == nil {
                lowValueDragStart = lowValue
              }
              guard let lowValueDragStart = lowValueDragStart else { return }

              let dragValue = lowValueDragStart + (Double(value.translation.width / dispValueWidth) * dispBoundDiff)
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
          .shadow(color: Color(UIColor.gray), radius: 3)
//          .opacity(0.8)
          .frame(width: thumbSize, height: thumbSize)
          .overlay(
            Text(String(format: highValueFormat, highValue))
              .font(.system(.subheadline, design: .rounded))
              .frame(width: 100)
              .offset(y: -1.0 * thumbSize / 2 - 16.0)
          )
          .offset(x: highValuePos)
          .gesture(DragGesture(minimumDistance: 1.0)
            .onChanged { value in
              if highValueDragStart == nil {
                highValueDragStart = highValue
              }
              guard let highValueDragStart = highValueDragStart else { return }

              let dragValue = highValueDragStart + (Double(value.translation.width / dispValueWidth) * dispBoundDiff)
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
    VStack {
      Spacer()
      HStack {
        if isShowMinMaxLabel {
          Text(String(format: minFormat, dispBounds.lowerBound))
            .font(.system(.subheadline, design: .rounded))
            .foregroundColor(Color(uiColor: UIColor.label))
            .frame(width: 32)
        }
        slider

        if isShowMinMaxLabel {
          Text(String(format: maxFormat, dispBounds.upperBound))
            .font(.system(.subheadline, design: .rounded))
            .foregroundColor(Color(uiColor: UIColor.label))
        }
      }
      .padding(.top, 32)
      .padding(.bottom, 8)
//      .frame(height: 60)

//      .border(Color.red)
      Spacer()

    }.padding(.horizontal, 6)
//      .border(Color.red)
  }
}

struct RangeSliderExample: View {
  @State private var sliderValue: ClosedRange<Double> = 0...100

  @State private var lowerValue: Double = 20
  @State private var upperValue: Double = 80

  @State private var position = CGSize.zero

  var body: some View {
    VStack {
//      RangeSliderCircle(value: $sliderValue, bounds: 0...100)
      RangeSlider(
        lowValue: $lowerValue, 
        highValue: $upperValue,
        valueBounds: 10...80,
        dispBounds: 0...100,
        isShowMinMaxLabel: false
      )

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
