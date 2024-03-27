//
// Copyright (c) 2024, - All rights reserved.
//
//

import SwiftUI

struct Item: Identifiable {
  var id = UUID()
  var name: String
  var destination: AnyView // 遷移先の画面を表すAnyView
}

struct MainMenu: View {
  let items = [
    Item(name: "RippleSample",
         destination: AnyView(RippleSample())),
    Item(name: "RangeSlider", destination:
      AnyView(RangeSliderExample())),
    Item(name: "CALayerBlend", destination:
      AnyView(BlendSampleView()))
  ]

  var body: some View {
    NavigationView {
      List(items) { item in
        NavigationLink(destination: item.destination) {
          Text(item.name)
        }
      }
      .navigationTitle("Samples")
    }
  }
}

#Preview {
  MainMenu()
}
