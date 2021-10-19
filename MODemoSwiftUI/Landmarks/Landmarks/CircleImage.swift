//
//  CircleImage.swift
//  Landmarks
//
//  Created by MikiMo on 2021/10/17.
//

import SwiftUI

struct CircleImage: View {
    var body: some View {
        Image("turtlerock")
            .clipShape(Circle())    // 圆角
            .overlay(Circle().stroke(Color.gray, lineWidth: 4)) // 边框
            .shadow(radius: 7)  // 阴影
    }
}

struct CircleImage_Previews: PreviewProvider {
    static var previews: some View {
        CircleImage()
    }
}
