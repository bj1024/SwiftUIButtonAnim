//
// Copyright (c) 2024, - All rights reserved.
//
//

import Foundation
import SwiftUI


struct BlendView: UIViewRepresentable {
  var image:UIImage
  
  func makeUIView(context: Context) -> UIBlendLayerView {
    let view = UIBlendLayerView()
    return view
  }

  func updateUIView(_ uiView: UIBlendLayerView, context: Context) {
    uiView.cgImage = image.cgImage
    
    uiView.update()
  }
}
