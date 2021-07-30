//
//  MOMarsRover.m
//  MODemoOC
//
//  Created by MikiMo on 2021/5/19.
//

#import "MOMarsRover.h"

NSString * const MOMarsRoverActionForward = @"MOMarsRoverActionForward";
NSString * const MOMarsRoverActionBackOf = @"MOMarsRoverActionBackOf";
NSString * const MOMarsRoverActionTurnLeft = @"MOMarsRoverActionTurnLeft";
NSString * const MOMarsRoverActionTurnRight = @"MOMarsRoverActionTurnRight";

@implementation MOMarsRover

- (instancetype)initWithSize:(CGSize)size
                    position:(CGPoint)position
                 orientation:(MOMarsRoverOrientation)orientation {
    self = [super init];
    if (self) {
        _size = size;
        _position = position;
        _orientation = orientation;
    }
    return self;
}

- (void)actions:(NSDictionary *)actions {
    [actions enumerateKeysAndObjectsUsingBlock:^(NSString *key, NSNumber *obj, BOOL * _Nonnull stop) {
        if ([key isEqualToString:MOMarsRoverActionForward]) {
            _position = [self actionForwardWithValue:obj];
        } else if ([key isEqualToString:MOMarsRoverActionBackOf]) {
            _position = [self actionBackOfWithValue:obj];
        } else if ([key isEqualToString:MOMarsRoverActionTurnLeft]) {
            _orientation = [self actionTurnLeft];
        } else if ([key isEqualToString:MOMarsRoverActionTurnRight]) {
            _orientation = [self actionTurnRight];
        }
    }];
}

- (MOMarsRoverOrientation)actionTurnLeft {
    switch (_orientation) {
        case MOMarsRoverOrientationNorth: return MOMarsRoverOrientationWest; break;
        case MOMarsRoverOrientationSouth: return MOMarsRoverOrientationEast; break;
        case MOMarsRoverOrientationWest: return MOMarsRoverOrientationSouth; break;
        case MOMarsRoverOrientationEast: return MOMarsRoverOrientationNorth; break;
        default: break;
    }
}

- (MOMarsRoverOrientation)actionTurnRight {
    switch (_orientation) {
        case MOMarsRoverOrientationNorth: return MOMarsRoverOrientationEast; break;
        case MOMarsRoverOrientationSouth: return MOMarsRoverOrientationWest; break;
        case MOMarsRoverOrientationWest: return MOMarsRoverOrientationNorth; break;
        case MOMarsRoverOrientationEast: return MOMarsRoverOrientationSouth; break;
        default: break;
    }
}

- (BOOL)isWithinSafeAreaWithPoint:(CGPoint)point {
    return point.x >= 0 && point.x <= _size.width &&
    point.y >= 0 && point.y <= _size.height;
}

- (CGPoint)actionForwardWithValue:(NSNumber *)value {
    CGPoint currentPostion = _position;
    switch (_orientation) {
        case MOMarsRoverOrientationNorth: {
            currentPostion = CGPointMake(currentPostion.x, currentPostion.y + value.floatValue);
        } break;
        case MOMarsRoverOrientationSouth: {
            currentPostion = CGPointMake(currentPostion.x, currentPostion.y - value.floatValue);
        } break;
        case MOMarsRoverOrientationWest: {
            currentPostion = CGPointMake(currentPostion.x - value.floatValue, currentPostion.y);
        } break;
        case MOMarsRoverOrientationEast: {
            currentPostion = CGPointMake(currentPostion.x + value.floatValue, currentPostion.y);
        } break;
        default: break;
    }
    // 判断结果是否在安全范围内
    if ([self isWithinSafeAreaWithPoint:currentPostion]) {
        return currentPostion;
    }
    return _position;
}

- (CGPoint)actionBackOfWithValue:(NSNumber *)value {
    CGPoint currentPostion = _position;
    switch (_orientation) {
        case MOMarsRoverOrientationNorth: {
            currentPostion = CGPointMake(currentPostion.x, currentPostion.y - value.floatValue);
        } break;
        case MOMarsRoverOrientationSouth: {
            currentPostion = CGPointMake(currentPostion.x, currentPostion.y + value.floatValue);
        } break;
        case MOMarsRoverOrientationWest: {
            currentPostion = CGPointMake(currentPostion.x + value.floatValue, currentPostion.y);
        } break;
        case MOMarsRoverOrientationEast: {
            currentPostion = CGPointMake(currentPostion.x - value.floatValue, currentPostion.y);
        } break;
        default: break;
    }
    // 判断结果是否在安全范围内
    if ([self isWithinSafeAreaWithPoint:currentPostion]) {
        return currentPostion;
    }
    return _position;
}

@end
