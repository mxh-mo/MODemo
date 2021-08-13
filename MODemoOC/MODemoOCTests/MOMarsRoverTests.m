//
//  MOMarsRoverTests.m
//  MOOCMockTests
//
//  Created by MikiMo on 2021/5/19.
//
//  TDD: Test-Driven Development 测试驱动开发 课程

#import <XCTest/XCTest.h>
#import <OCMock/OCMock.h>
#import "MOMarsRover.h"

@interface MOMarsRoverTests : XCTestCase

@property (nonatomic, strong) MOMarsRover *rover;

@end

@implementation MOMarsRoverTests

- (void)setUp {
    self.rover = [[MOMarsRover alloc] initWithSize:CGSizeMake(100, 100)
                                          position:CGPointMake(0, 0)
                                       orientation:MOMarsRoverOrientationNorth];
}

- (void)tearDown {
}

- (void)testMoves {
    XCTAssertNotNil(self.rover);
    {
        CGPoint originPosition = self.rover.position;
        NSDictionary *actions = @{MOMarsRoverActionForward: @(10)};
        [self.rover actions:actions];
        XCTAssertEqual(self.rover.position.x, originPosition.x);
        XCTAssertEqual(self.rover.position.y, originPosition.y + 10.0);
    }
    {
        CGPoint originPosition = self.rover.position;
        NSDictionary *actions = @{MOMarsRoverActionBackOf: @(10)};
        [self.rover actions:actions];
        XCTAssertEqual(self.rover.position.x, originPosition.x);
        XCTAssertEqual(self.rover.position.y, originPosition.y);
    }
}

- (void)testTurn {
    {
        NSDictionary *actions = @{MOMarsRoverActionTurnLeft: @(1)};
        [self.rover actions:actions];
        XCTAssertEqual(self.rover.orientation, MOMarsRoverOrientationWest);
    }
    {
        NSDictionary *actions = @{MOMarsRoverActionTurnRight: @(1)};
        [self.rover actions:actions];
        XCTAssertEqual(self.rover.orientation, MOMarsRoverOrientationNorth);
    }
}

@end
