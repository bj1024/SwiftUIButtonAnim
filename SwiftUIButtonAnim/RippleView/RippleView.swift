//
// Copyright (c) 2024, - All rights reserved. 
// 
//

import Foundation
import SwiftUI


struct RippleView: UIViewRepresentable {
  var isShow: Bool
  var numberOfCircles: Int
  var colors: [Color]
  var duration: Double
  var delay: Double
  var interval: Double = 0.5
  var positionDiff: Double
  var lineWidthRange:ClosedRange<Double> = 1...2


  func makeUIView(context: Context) -> UIRippleView {
    let view = UIRippleView()
//    view.setContentHuggingPriority(.required, for: .horizontal) // << here !!
//    view.setContentHuggingPriority(.required, for: .vertical)

    return view
  }

  func updateUIView(_ uiView: UIRippleView, context: Context) {
//    uiView.frame = frame
    // isShow でアニメーションを止める
    print("updateUIView isShow=\(isShow) ")
    uiView.isShow = isShow
    uiView.numberOfCircles = numberOfCircles
    uiView.duration = duration
    uiView.interval = interval
    uiView.positionDiff = positionDiff
    uiView.lineWidthRange = lineWidthRange
    uiView.circleColors = colors.map{
      UIColor($0)
    }
    uiView.update()
    
//    if isShow {
//      uiView.initLanyer()
//    } else {
//      uiView.removeAllLayers()
//    }
//    uiView.strokeColor = colors[0]
//    uiView.number = number
//    uiView.isShow = isShow

//    uiView.update()
//    uiView.frame = frame
  }
}
