//
//  MOWaveTableView.h
//  07.AudioTimeSlider
//
//  Created by moxiaoyan on 2020/6/5.
//  Copyright © 2020 moxiaoyan. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol MOTableViewDelegate <NSObject>

- (void)contentOffsetY:(CGFloat)y;
- (void)willBeginDragging;
- (void)didEndDraggingY:(CGFloat)y;

@end

@interface MOWaveTableView : UITableView

@property (nonatomic, strong) NSArray *points;
@property (nonatomic, assign) CGFloat rightSpace; //指正右边空间
@property (nonatomic, weak) id <MOTableViewDelegate> scrollDelegate;

@end

NS_ASSUME_NONNULL_END
