//
//  UILabel+Swizzling.m
//  04.Runtime
//
//  Created by moxiaoyan on 2020/2/24.
//  Copyright © 2020 moxiaoyan. All rights reserved.
//

#import "UILabel+Swizzling.h"
#import "NSObject+Swizzling.h"

@implementation UILabel (Swizzling)

+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [self methodSwizzlingWithOriginalSelector:@selector(init) bySwizzledSelector:@selector(mo_Init)];
        [self methodSwizzlingWithOriginalSelector:@selector(initWithFrame:) bySwizzledSelector:@selector(mo_InitWithFrame:)];
        [self methodSwizzlingWithOriginalSelector:@selector(awakeFromNib) bySwizzledSelector:@selector(mo_AwakeFromNib)];
    });
}

- (instancetype)mo_Init {
    id __self = [self mo_Init];
    UIFont *font = [UIFont fontWithName:@"Zapfino" size:self.font.pointSize];
    if (font) {
        self.font = font;
    }
    return __self;
}

- (instancetype)mo_InitWithFrame:(CGRect)rect {
    id __self = [self mo_InitWithFrame:rect];
    UIFont *font = [UIFont fontWithName:@"Zapfino" size:self.font.pointSize];
    if (font) {
        self.font = font;
    }
    return __self;
}

- (void)mo_AwakeFromNib {
    [self mo_AwakeFromNib];
    UIFont *font = [UIFont fontWithName:@"Zapfino" size:self.font.pointSize];
    if (font) {
        self.font = font;
    }
}

@end
