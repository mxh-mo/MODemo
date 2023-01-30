//
//  MOFollowLightView.m
//  MODemoOC
//
//  Created by MikiMo on 2021/10/31.
//

#import "MOFollowLightView.h"

@implementation MOFollowLightView {
    NSTimer *_timer;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupView];
    }
    return self;
}

- (void)setupView {
    self.layer.cornerRadius = 4.0;
    self.layer.masksToBounds = YES;

    CAGradientLayer *gradientLayer = [CAGradientLayer layer];
    gradientLayer.frame = self.bounds;
    gradientLayer.colors = @[(__bridge id)[UIColor redColor].CGColor,
                             (__bridge id)[UIColor blueColor].CGColor];
//    gradientLayer.colors = @[(__bridge id)[UIColor colorWithRed:255.0/255.0 green:2.0/255.0 blue:65.0/255.0 alpha:1].CGColor,
//                             (__bridge id)[UIColor colorWithRed:255.0/255.0 green:165.0/255.0 blue:37.0/255.0 alpha:1].CGColor];
    gradientLayer.startPoint = CGPointMake(0.0, 0.0);
    gradientLayer.endPoint = CGPointMake(1.0, 1.0);
    [self.layer addSublayer:gradientLayer];

    NSArray *points = [self sidePoints];

    __block NSUInteger index = 0;
    _timer = [NSTimer scheduledTimerWithTimeInterval:0.1 repeats:YES block:^(NSTimer * _Nonnull timer) {

        NSUInteger redIndex = index % (points.count - 1);
        NSUInteger yelIndex = (index + (points.count / 2 + 1)) % (points.count - 1);

        NSArray *redArr = points[redIndex];
        NSArray *yelArr = points[yelIndex];

        NSNumber *redX = redArr[0];
        NSNumber *redY = redArr[1];
        NSNumber *yelX = yelArr[0];
        NSNumber *yelY = yelArr[1];

        gradientLayer.startPoint = CGPointMake(redX.floatValue, redY.floatValue);
        gradientLayer.endPoint = CGPointMake(yelX.floatValue, yelY.floatValue);

        index++;
        index = index % (points.count - 1);
    }];
    [_timer setFireDate:[NSDate date]];

    
    CGFloat borderWidth = 10.0;
    CGRect imageFrame = CGRectMake(self.bounds.origin.x + borderWidth,
                                   self.bounds.origin.y + borderWidth,
                                   self.bounds.size.width - borderWidth * 2,
                                   self.bounds.size.height - borderWidth * 2);
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:imageFrame];
    imageView.image = [UIImage imageNamed:@"金晨"];
    imageView.layer.cornerRadius = 4.0;
    imageView.layer.masksToBounds = YES;
    [self addSubview:imageView];
}

- (NSArray *)sidePoints {
    NSMutableArray *points = [NSMutableArray array];
    CGFloat min = 0.0;
    CGFloat max = 1.0;
    CGFloat spacing = 0.25;
    // top side
    for (CGFloat x = min; x <= max; x += spacing) {
        [points addObject:@[@(x), @(0)]];
    }
    // right side
    for (CGFloat y = min + spacing; y <= max; y += spacing) {
        [points addObject:@[@(1), @(y)]];
    }
    // bottom side
    for (CGFloat x = max - spacing; x >= min; x -= spacing) {
        [points addObject:@[@(x), @(1)]];
    }
    // left side
    for (CGFloat y = max - spacing; y >= min; y -= spacing) {
        [points addObject:@[@(0), @(y)]];
    }
    return [points copy];
}

@end
