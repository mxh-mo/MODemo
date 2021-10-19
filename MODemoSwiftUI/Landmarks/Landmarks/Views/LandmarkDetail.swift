//
//  LandmarkDetail.swift
//  Landmarks
//
//  Created by MikiMo on 2021/10/19.
//

import SwiftUI

struct LandmarkDetail: View {
    var landmark: Landmark
    
    var body: some View {
        ScrollView {
            MapView(coordinate: landmark.locationCoordinate)    /// 经纬度
                .ignoresSafeArea(edges: .top)   // 忽略top安全范围
                .frame(height: 300)
            
            CircleImage(image: landmark.image)  /// 图片
                .offset(y: -130)    // 图片偏移
                .padding(.bottom, -130)     // 下边距减少
                
            
            VStack(alignment: .leading) { // 左对齐
                Text(landmark.name) /// 地名
                    .font(.title)
                
                HStack {
                    Text(landmark.park) /// 公园
                        .font(.subheadline)
                    Spacer()    // 撑开空闲区域
                    Text(landmark.state)    /// 州
                        .font(.subheadline)
                }
                .font(.subheadline)
                .foregroundColor(.secondary)
                
                Divider()   // 间距
                
                Text("About \(landmark.name)")
                    .font(.title2)
                Text(landmark.description) /// 描述
                
            }
            .padding() // 内边距
            
            Spacer()
        }
        .navigationTitle(landmark.name)
        .navigationBarTitleDisplayMode(.inline) // .inline 小标题 .large 大标题(上滑动会变成小标题)
    }
}

struct LandmarkDetail_Previews: PreviewProvider {
    static var previews: some View {
        LandmarkDetail(landmark: landmarks[0])
    }
}
