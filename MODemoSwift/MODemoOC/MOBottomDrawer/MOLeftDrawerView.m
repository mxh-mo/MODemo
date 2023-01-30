//
//  MOLeftDrawerView.m
//  MODemoOC
//
//  Created by MikiMo on 2020/12/18.
//

#import "MOLeftDrawerView.h"

@implementation MOLeftDrawerView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.userInteractionEnabled = YES;
        UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panBottomView:)];
        [self addGestureRecognizer:pan];
        
        UITapGestureRecognizer *tapBack = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapBack)];
        [self addGestureRecognizer:tapBack];
        [self close];
    }
    return self;
}

- (void)panBottomView:(UIPanGestureRecognizer *)pan {
    CGPoint translation = [pan translationInView:pan.view];
    if (pan.state == UIGestureRecognizerStateEnded) {
        if (translation.x > 0) {
            [self open];
        } else {
            [self close];
        }
    }
}

- (void)tapBack {
    [self open];
}

- (void)close {
    [UIView animateWithDuration: 0.7 // 总时长
                          delay:0  // 延迟执行时长
         usingSpringWithDamping:0.5 // 弹性（越小弹性越大）
          initialSpringVelocity:0.3   // 初速度
                        options:0
                     animations:^{
        self.frame = CGRectMake(kMinOrginX, self.frame.origin.y, self.frame.size.width, self.frame.size.height);
    } completion:nil];
}

- (void)open {
    [UIView animateWithDuration:0.2 animations:^{
        self.frame = CGRectMake(kMaxOrginX, self.frame.origin.y, self.frame.size.width, self.frame.size.height);
    }];
}

@end
