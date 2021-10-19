//
//  ContentView.swift
//  Landmarks
//
//  Created by MikiMo on 2021/10/16.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        VStack {
            MapView()
                .ignoresSafeArea(edges: .top)   // 忽略top安全范围
                .frame(height: 300)
            
            CircleImage()
                .offset(y: -130)    // 图片偏移
                .padding(.bottom, -130)     // 下边距减少
                
            
            VStack(alignment: .leading) { // 左对齐
                Text("Turtle Rock")
                    .font(.title)
                HStack {
                    Text("Joshua Tree Notional Park")
                        .font(.subheadline)
                    Spacer()    // 撑开空闲区域
                    Text("California")
                        .font(.subheadline)
                }
                .font(.subheadline)
                .foregroundColor(.secondary)
                
                Divider()   // 间距
                
                Text("About Turtle Rock")
                    .font(.title2)
                Text("Descriptive text goes here.")
                
            }
            .padding() // 内边距
            
            Spacer()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
