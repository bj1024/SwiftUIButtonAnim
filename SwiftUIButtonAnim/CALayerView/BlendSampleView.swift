//
// Copyright (c) 2024, - All rights reserved.
//
//

import SwiftUI

struct BlendSampleView: View {
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
  
  enum Images: String, CaseIterable, Identifiable {
    case marbles, ball, bird
    var id: Self { self }
  }
  
  @State private var selectedImage: Images = .ball
  
  init() {}
  
  var body: some View {
    VStack {
      ZStack {}
      
      BlendView(image: UIImage(imageLiteralResourceName: selectedImage.rawValue))
        .frame(maxWidth: .infinity)
        .background(Color(uiColor: UIColor.systemBackground))
      
      List {
        Section(header: Text("Image")) {
          Picker("Image", selection: $selectedImage) {
            ForEach(Images.allCases) { images in
              Text(images.rawValue.capitalized)
                .tag(images.rawValue.capitalized)
            }
          }
        }
      }
    }
  }
}

#Preview {
  BlendSampleView()
}
