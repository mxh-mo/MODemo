//
//  UIImage+image.m
//  1、替换方法
//
//  Created by MikiMo on 2018/3/29.
//  Copyright © 2018年 莫小言. All rights reserved.
//

#import <objc/runtime.h>

#import "UIImage+image.h"

@implementation UIImage (image)

#pragma mark - 把类加载进内存时调用，只会调用一次

+ (void)load {
    // class_getClassMethod 获取某个类的方法
    // method_exchangedImplementations 交换两个方法的地址
    
    // 1、获取系统方法
    Method imageNamedMethod = class_getClassMethod(self, @selector(imageNamed:));
    // 2、获取自定义的方法
    Method in_imageNamedMethod = class_getClassMethod(self, @selector(in_imageNamed:));
    // 3、交换方法地址
    method_exchangeImplementations(imageNamedMethod, in_imageNamedMethod);
}

+ (UIImage *)in_imageNamed:(NSString *)name {
    // 这里调用的是系统的imageNamed，因为已经替换过了
    UIImage *image = [UIImage in_imageNamed:name];
    if (image) {
        NSLog(@"图片加载成功");
    } else {
        NSLog(@"图片加载失败");
    }
    return image;
}

@end
