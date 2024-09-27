//
//  MOImageOptimizeViewController.swift
//  MODemo
//
//  Created by mikimo on 2024/9/27.
//  Copyright © 2024 Mobi Technology. All rights reserved.
//

import UIKit

class MOImageOptimizeViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let url = "https://gips3.baidu.com/it/u=4283915297,3700662292&fm=3028&app=3028&f=JPEG&fmt=auto?w=1440&h=2560"
        guard let imageURL = URL(string: url) else {
            print("create url error")
            return
        }
        
        let imageView = UIImageView(frame: CGRectMake(50.0, 100.0, 300.0, 300.0))
        view.addSubview(imageView)
        
        // 方式1: 直接加载 43.1M
        loadImage(imageURL: imageURL) { image in
            imageView.image = image
        }
        // 方式2: 缩小图片 40.5M
        loadImage(imageURL: imageURL) { image in
            let renderer = UIGraphicsImageRenderer(size: imageView.frame.size)
            let renderImage = renderer.image { context in
                image?.draw(in: CGRect(origin: .zero, size: imageView.frame.size))
            }
            imageView.image = image
        }
        // 方式3: 进行采样 26.3M
        loadSampleImage(imageURL: imageURL, size: imageView.frame.size, scale: UIScreen.main.scale) { image in
            imageView.image = image
        }
    }
    
    // MARK: - 图片采样
    func loadSampleImage(imageURL: URL, size: CGSize, scale: CGFloat, complete: @escaping (UIImage?) -> ()) {
        if Thread.isMainThread {
            DispatchQueue.global().async { [weak self] in
                self?.loadSampleImage(imageURL: imageURL, size: size, scale: scale, complete: complete)
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
    
    // MARK: - 缩小图片
    func loadRenderImage(imageURL: URL, size: CGSize, complete: @escaping (UIImage?) -> ()) {
        if Thread.isMainThread {
            DispatchQueue.global().async { [weak self] in
                self?.loadRenderImage(imageURL: imageURL, size: size, complete: complete)
            }
            print("dispatch to global queue")
            return
        }
        guard let image = UIImage(contentsOfFile: imageURL.path) else {
            print("create image error")
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
    
    // MARK: - 直接加载
    func loadImage(imageURL: URL, complete: @escaping (UIImage?) -> ()) {
        if Thread.isMainThread {
            DispatchQueue.global().async { [weak self] in
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
}
