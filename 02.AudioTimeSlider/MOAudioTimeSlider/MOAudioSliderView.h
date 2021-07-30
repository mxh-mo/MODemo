//
//  MOAudioSliderView.h
//  07.AudioTimeSlider
//
//  Created by moxiaoyan on 2020/6/3.
//  Copyright © 2020 moxiaoyan. All rights reserved.
//

#import <UIKit/UIKit.h>
extern NSInteger const cellHeight;
extern NSInteger const kAudioPlayerLineSpacing;

NS_ASSUME_NONNULL_BEGIN

@interface MOAudioSliderView : UIView

- (instancetype)initWithFrame:(CGRect)frame playUrl:(NSURL *)playUrl points:(NSArray *)points;

@end

NS_ASSUME_NONNULL_END
