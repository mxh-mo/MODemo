//
//  MOImageOptimizeViewController.swift
//  MODemo
//
//  Created by mikimo on 2024/9/27.
//  Copyright © 2024 Mobi Technology. All rights reserved.
//

import UIKit

class MOImageOptimizeViewController: UIViewController {
    
    var loadImageQueue = DispatchQueue(label: "load image", qos: .background)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // 3.4M 的图
        let url = "https://pic.rmb.bdstatic.com/bjh/240106/dump/ace6bb9c436f1d3169c29902bba5dfe1.jpeg?x-bce-process=image/watermark,bucket_baidu-rmb-video-cover-1,image_YmpoL25ld3MvNjUzZjZkMjRlMDJiNjdjZWU1NzEzODg0MDNhYTQ0YzQucG5n,type_RlpMYW5UaW5nSGVpU01HQg==,w_32,text_QOilv-WhmOWwkeS4uw==,size_32,x_25,y_25,interval_2,color_FFFFFF,effect_softoutline,shc_000000,blr_2,align_1"
        guard let imageURL = URL(string: url) else {
            print("create url error")
            return
        }
        // base 25.5 M
        
        let imageView = UIImageView(frame: CGRectMake(50.0, 100.0, 300.0, 300.0))
        view.addSubview(imageView)
        
        // 方式1: 直接加载 84.2M
//        loadImage(imageURL: imageURL) { image in
//            imageView.image = image
//        }
        // 方式2: 缩小图片 Image downscaling 
        // 26.3M, 最高28.4M
//        loadDownscalingImage(imageURL: imageURL, size: imageView.frame.size) { image in
//            imageView.image = image
//        }
        // 方式3: 进行采样 Image downsampling 
        // 28.3M, 最高29.5M
        loadDownsamplingImage(imageURL: imageURL, size: imageView.frame.size, scale: UIScreen.main.scale) { image in
            imageView.image = image
        }
        // 参考：
        // https://juejin.cn/post/6992477922993012744
        // https://github.com/RickeyBoy/Rickey-iOS-Notes/blob/master/Notes/Translation/%5B%E8%AF%91%5D%20iOS%20%E4%B8%AD%E7%9A%84%E5%9B%BE%E5%83%8F%E4%BC%98%E5%8C%96.md
    }
    
    // MARK: - 直接加载
    func loadImage(imageURL: URL, complete: @escaping (UIImage?) -> ()) {
        if Thread.isMainThread {
            self.loadImageQueue.async { [weak self] in
                self?.loadImage(imageURL: imageURL, complete: complete)
            }
            print("dispatch to global queue")
            return
        }
        guard let data = try? Data(contentsOf: imageURL) else {
            print("create data error")
            return
        }
        guard let image = UIImage(data: data) else {
            print("create image error")
            return
        }
        DispatchQueue.main.async {
            complete(image)
        }
    }
    
    // MARK: - 缩小图片
    func loadDownscalingImage(imageURL: URL, size: CGSize, complete: @escaping (UIImage?) -> ()) {
        if Thread.isMainThread {
            self.loadImageQueue.async { [weak self] in
                self?.loadDownscalingImage(imageURL: imageURL, size: size, complete: complete)
            }
            print("dispatch to global queue")
            return
        }
        loadImage(imageURL: imageURL) { image in
            guard let image = image else {
                print("load image is nil")
                complete(nil)
                return
            }
            let renderer = UIGraphicsImageRenderer(size: size)
            let renderImage = renderer.image { context in
                image.draw(in: CGRect(origin: .zero, size: size))
            }
            DispatchQueue.main.async {
                complete(renderImage)
            }
        }
    }
    
    // MARK: - 图片采样
    func loadDownsamplingImage(imageURL: URL, size: CGSize, scale: CGFloat, complete: @escaping (UIImage?) -> ()) {
        if Thread.isMainThread {
            self.loadImageQueue.async { [weak self] in
                self?.loadDownsamplingImage(imageURL: imageURL, size: size, scale: scale, complete: complete)
            }
            print("dispatch to global queue")
            return
        }
        // 1. 创建 CGImageSource 对象
        // kCGImageSourceShouldCache 是否需要解码缓存
        let imageSourceOptions = [kCGImageSourceShouldCache: false] as CFDictionary
        guard let imageSource = CGImageSourceCreateWithURL(imageURL as CFURL,
                                                           imageSourceOptions) else {
            print("create image source error")
            return
        }
        // 2. 计算采样像素
        let maxDimensionInPixels = max(size.width, size.height) * scale
        // 3. 配置采样参数
        let sampleOptions = [kCGImageSourceCreateThumbnailFromImageAlways: true,
                                     kCGImageSourceShouldCacheImmediately: true, // 进行解码和缓存
                               kCGImageSourceCreateThumbnailWithTransform: true,
                                      kCGImageSourceThumbnailMaxPixelSize: maxDimensionInPixels] as CFDictionary
        // 4. 创建缩略图
        guard let downsampledImage = CGImageSourceCreateThumbnailAtIndex(imageSource, 0, sampleOptions) else {
            print("create thumbnail image error")
            return
        }
        DispatchQueue.main.async {
            complete(UIImage(cgImage: downsampledImage))
        }
    }

}
