//
//  MOBottomDrawerView.m
//  MODemoOC
//
//  Created by MikiMo on 2020/12/18.
//

#import "MOBottomDrawerView.h"

@implementation MOBottomDrawerView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panBottomView:)];
        [self addGestureRecognizer:pan];
        
        UITapGestureRecognizer *tapBack = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapBack)];
        [self addGestureRecognizer:tapBack];
    }
    return self;
}

- (void)panBottomView:(UIPanGestureRecognizer *)pan {
    CGPoint translation = [pan translationInView:pan.view];
    CGPoint orgin = pan.view.frame.origin;
    NSLog(@"%f", translation.y);
    static CGFloat startY = 0;
    if (pan.state == UIGestureRecognizerStateBegan) {
        startY = pan.view.frame.origin.y;
    }
    CGFloat moveY = startY + translation.y;
    if (moveY > kBottomMinY && moveY < kBottomMaxY) { // 随手指移动
        pan.view.frame = CGRectMake(orgin.x, moveY, kSCREEN_WIDTH, 300);
    } else if (moveY <= kBottomMinY) {  // 收起
        pan.view.frame = CGRectMake(0, kBottomMinY, kSCREEN_WIDTH, 300);
    } if (moveY >= kBottomMaxY) { // 展开
        pan.view.frame = CGRectMake(0, kBottomMaxY, kSCREEN_WIDTH, 300);
    }
    int viewY = pan.view.frame.origin.y;
    if (pan.state == UIGestureRecognizerStateEnded) {
        if (translation.y < 0 && viewY < kBottomMaxY) {
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
        self.frame = CGRectMake(0, kBottomMaxY, kSCREEN_WIDTH, self.frame.size.height);
    } completion:nil];
}

- (void)open {
    [UIView animateWithDuration:0.2 animations:^{
        self.frame = CGRectMake(0, kBottomMinY, kSCREEN_WIDTH, 300);
    }];
}

@end
