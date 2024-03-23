//
// Copyright (c) 2024, - All rights reserved.
//
//

import SwiftUI
struct ColorData: Identifiable {
  let id = UUID()
  let name: String
  let color: Color
  let variations: [ShadeData]

  struct ShadeData: Identifiable {
    let id = UUID()
    var brightness: Double
  }

  init(color: Color, name: String) {
    self.name = name
    self.color = color
    self.variations = stride(from: 0.0, to: 0.5, by: 0.1)
      .map { ShadeData(brightness: $0) }
  }
}

struct SectionHeaderView: View {
  var colorData: ColorData

  var body: some View {
    HStack {
      Text(colorData.name)
        .font(.headline)
        .foregroundColor(colorData.color)
      Spacer()
    }
    .padding()
    .background(Color(UIColor.systemBackground)
//      .colorInvert()
      .opacity(0.75))
  }
}

struct ColorList: View {
  let sections = [
    ColorData(color: .red, name: "Reds"),
    ColorData(color: .green, name: "Greens"),
    ColorData(color: .blue, name: "Blues")
  ]

  var body: some View {
    ScrollView {
      LazyVStack(spacing: 1) {
        ForEach(sections) { section in
          Section(header: SectionHeaderView(colorData: section)) {
            ForEach(section.variations) { variation in
              section.color
                .brightness(variation.brightness)
                .frame(height: 20)
            }
          }
        }
      }
    }
  }
}

#Preview {
  ColorList()
}
