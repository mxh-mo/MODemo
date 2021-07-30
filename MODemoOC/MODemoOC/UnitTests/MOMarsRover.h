//
//  MOMarsRover.h
//  MODemoOC
//
//  Created by MikiMo on 2021/5/19.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

FOUNDATION_EXPORT NSString * const MOMarsRoverActionForward;
FOUNDATION_EXPORT NSString * const MOMarsRoverActionBackOf;
FOUNDATION_EXPORT NSString * const MOMarsRoverActionTurnLeft;
FOUNDATION_EXPORT NSString * const MOMarsRoverActionTurnRight;

typedef NS_ENUM(NSInteger, MOMarsRoverOrientation) {
    MOMarsRoverOrientationNorth, // 北
    MOMarsRoverOrientationSouth, // 南
    MOMarsRoverOrientationWest,  // 西
    MOMarsRoverOrientationEast,  // 东
};

/// 火星车
/// 问题描述：MOSurvey/MOSurveyOC/MOSurveyOC/UnitTests/TDD练习：火星车问题
@interface MOMarsRover : NSObject

@property (nonatomic, assign, readonly) CGSize size;
@property (nonatomic, assign, readonly) CGPoint position;
@property (nonatomic, assign, readonly) MOMarsRoverOrientation orientation;

- (instancetype)initWithSize:(CGSize)size position:(CGPoint)position orientation:(MOMarsRoverOrientation)orientation;

- (void)actions:(NSDictionary *)actions;

@end

NS_ASSUME_NONNULL_END
