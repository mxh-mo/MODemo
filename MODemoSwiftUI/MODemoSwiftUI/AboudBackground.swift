//
//  AboudBackground.swift
//  MODemoSwiftUI
//
//  Created by MikiMo on 2021/10/16.
//

import SwiftUI

struct AboudBackground: View {
    var body: some View {
        Text("Hello, world!")
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color.green)
            .edgesIgnoringSafeArea(.all)
    }
}

struct AboudBackground_Previews: PreviewProvider {
    static var previews: some View {
        AboudBackground()
    }
}
